use std::error::Error;
use std::process::Stdio;
use tokio::process::Command;
use serde_json::{Value, json};
use tokio::sync::{mpsc, Semaphore};
use std::sync::Arc;
use futures::StreamExt;
use tokio::sync::Mutex;
use std::fs::OpenOptions;
use std::io::Write;

pub enum DatasetGenMessage {
    Progress(f64),
    Log(String),
}

pub async fn run_dataset_generation(
    file_path: &str,
    api_key: &str,
    tags_input: &str,
    progress_tx: Option<mpsc::Sender<DatasetGenMessage>>
) -> Result<String, Box<dyn Error>> {
    
    // Parse tags early
    let tags: Vec<String> = if !tags_input.trim().is_empty() {
        tags_input.split(',').map(|s| s.trim().to_string()).filter(|s| !s.is_empty()).collect()
    } else {
        Vec::new()
    };

    // 1. If path is not inside data/books/, copy it.
    let mut target_path = file_path.to_string();
    if !file_path.starts_with("data/books/") {
        std::fs::create_dir_all("data/books")?;
        let filename = std::path::Path::new(file_path).file_name()
            .ok_or("Invalid file path")?.to_string_lossy();
        target_path = format!("data/books/{}", filename);
        std::fs::copy(file_path, &target_path)?;
    }
    
    // 2. Invoke extract_pdf.py
    let venv_python = "./python/.venv/bin/python";
    let script_path = "./python/extract_pdf.py";
    
    let abs_target_path = std::fs::canonicalize(&target_path)?;

    if let Some(ref tx) = progress_tx {
        let _ = tx.send(DatasetGenMessage::Log(format!("Parsing PDF/EPUB: {}", target_path))).await;
        let _ = tx.send(DatasetGenMessage::Progress(0.05)).await;
    }

    let output = Command::new(venv_python)
        .arg(script_path)
        .arg("--pdf")
        .arg(abs_target_path)
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .output()
        .await?;

    if !output.status.success() {
        let stderr = String::from_utf8_lossy(&output.stderr);
        return Err(format!("Python script failed: {}", stderr).into());
    }

    let stdout_str = String::from_utf8(output.stdout)?;
    let parsed: Value = serde_json::from_str(&stdout_str)
        .map_err(|e| format!("Failed to parse Python output: {}\nOutput was: {}", e, stdout_str))?;

    if let Some(err) = parsed.get("error") {
        return Err(format!("Python error: {}", err).into());
    }

    let chunks = parsed.get("chunks")
        .and_then(|c| c.as_array())
        .ok_or("No chunks array in output")?;

    if chunks.is_empty() {
        return Err("PDF extraction yielded 0 chunks.".into());
    }

    let total_chunks = chunks.len();
    
    // 3. Setup JSONL output
    std::fs::create_dir_all("data/datasets")?;
    let base_name = std::path::Path::new(&target_path)
        .file_stem()
        .unwrap_or_default()
        .to_string_lossy();
    let output_file_path = format!("data/datasets/{}_dataset.jsonl", base_name);
    let progress_file_path = format!("data/datasets/{}_dataset.progress.json", base_name);

    let mut completed_indices: std::collections::HashSet<usize> = std::collections::HashSet::new();
    if let Ok(content) = std::fs::read_to_string(&progress_file_path) {
        if let Ok(indices) = serde_json::from_str::<Vec<usize>>(&content) {
            completed_indices = indices.into_iter().collect();
        }
    }
    let is_resuming = !completed_indices.is_empty();
    
    let file = OpenOptions::new()
        .create(true)
        .write(true)
        .append(is_resuming)
        .truncate(!is_resuming)
        .open(&output_file_path)?;

    let safe_file = Arc::new(Mutex::new(file));
    let safe_progress = Arc::new(tokio::sync::Mutex::new(completed_indices.clone()));
    let client = reqwest::Client::new();
    let gemini_url = format!("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={}", api_key);
    
    let system_instruction = r#"You are a Dataset Generator. You extract physical therapy and rehab knowledge from the provided textbook chunk and convert it into synthetic conversation examples.
Generate 3 to 5 realistic examples based ONLY on the clinical information in the text chunk below."#;

    let standard_system_prompt = "You are Motus, a world-class AI physical therapist and rehabilitation expert. Your goal is to help users address their aches and pains by generating highly specific rehab and workout protocols based on clinical knowledge.";

    let response_schema = json!({
        "type": "ARRAY",
        "items": {
            "type": "OBJECT",
            "properties": {
                "messages": {
                    "type": "ARRAY",
                    "items": {
                        "type": "OBJECT",
                        "properties": {
                            "role": { "type": "STRING" },
                            "content": { "type": "STRING", "nullable": true },
                            "tool_calls": {
                                "type": "ARRAY",
                                "items": {
                                    "type": "OBJECT",
                                    "properties": {
                                        "id": { "type": "STRING" },
                                        "type": { "type": "STRING" },
                                        "function": {
                                            "type": "OBJECT",
                                            "properties": {
                                                "name": { "type": "STRING" },
                                                "arguments": { "type": "STRING" }
                                            },
                                            "required": ["name", "arguments"]
                                        }
                                    },
                                    "required": ["id", "type", "function"]
                                }
                            }
                        },
                        "required": ["role"]
                    }
                }
            },
            "required": ["messages"]
        }
    });

    // 4. Concurrent chunk processing
    let concurrency_limit = 5; // Safe default
    let semaphore = Arc::new(Semaphore::new(concurrency_limit));
    let chunk_texts: Vec<String> = chunks.iter().map(|c| c.as_str().unwrap_or("").to_string()).collect();

    let processed_count = Arc::new(tokio::sync::Mutex::new(completed_indices.len()));
    
    let futures = chunk_texts.into_iter().enumerate().filter(|(i, text)| !text.trim().is_empty() && !completed_indices.contains(i)).map(|(i, chunk_text)| {
        let sem = semaphore.clone();
        let client = client.clone();
        let gemini_url = gemini_url.clone();
        let safe_file = safe_file.clone();
        let safe_progress = safe_progress.clone();
        let progress_path = progress_file_path.clone();
        let progress_tx = progress_tx.clone();
        let sys_instr = system_instruction.to_string();
        let sys_prompt = standard_system_prompt.to_string();
        let schema = response_schema.clone();
        let processed_count = processed_count.clone();

        async move {
            let _permit = sem.acquire().await.unwrap();

            let req_body = json!({
                "systemInstruction": {
                    "parts": [{"text": sys_instr}]
                },
                "contents": [
                    {
                        "parts": [{"text": format!("Textbook Chunk:\n\n{}", chunk_text)}]
                    }
                ],
                "generationConfig": {
                    "temperature": 0.2,
                    "responseMimeType": "application/json",
                    "responseSchema": schema
                }
            });

            if let Some(ref tx) = progress_tx {
                let _ = tx.send(DatasetGenMessage::Log(format!("Processing chunk {}...", i + 1))).await;
            }

            // Retry logic
            let mut attempts = 0;
            let mut res_text = String::new();
            let mut success = false;
            let mut last_error = String::new();
            
            while attempts < 3 {
                let res = client.post(&gemini_url)
                    .header("Content-Type", "application/json")
                    .json(&req_body)
                    .send()
                    .await;

                match res {
                    Ok(resp) => {
                        if resp.status().is_success() {
                            let resp_json: Value = resp.json().await.unwrap_or_default();
                            if let Some(text) = resp_json.pointer("/candidates/0/content/parts/0/text").and_then(|v| v.as_str()) {
                                res_text = text.to_string();
                                success = true;
                                break;
                            }
                        } else {
                            let status = resp.status();
                            let err_text = resp.text().await.unwrap_or_else(|_| "Unknown".to_string());
                            let formatted_err = if let Ok(json_val) = serde_json::from_str::<Value>(&err_text) {
                                serde_json::to_string_pretty(&json_val).unwrap_or(err_text)
                            } else {
                                err_text
                            };
                            last_error = format!("Status {}: {}", status, formatted_err);
                            attempts += 1;
                            if status == 429 {
                                tokio::time::sleep(tokio::time::Duration::from_secs(2 * attempts)).await;
                            }
                        }
                    }
                    Err(e) => {
                        last_error = e.to_string();
                        attempts += 1;
                        tokio::time::sleep(tokio::time::Duration::from_secs(2 * attempts)).await;
                    }
                }
            }

            if !success {
                if let Some(ref tx) = progress_tx {
                    let _ = tx.send(DatasetGenMessage::Log(format!("Warning: Chunk {} failed after 3 attempts. Error: {}", i + 1, last_error))).await;
                }
                return;
            }

            let generated_examples_res: Result<Vec<Value>, _> = serde_json::from_str(&res_text);
            let generated_examples = match generated_examples_res {
                Ok(ex) => ex,
                Err(e) => {
                    if let Some(ref tx) = progress_tx {
                        let _ = tx.send(DatasetGenMessage::Log(format!("Warning: Chunk {} produced invalid JSON. Error: {}", i + 1, e))).await;
                    }
                    return;
                }
            };

            let mut valid_count = 0;
            for mut example in generated_examples {
                if let Some(messages) = example.get_mut("messages").and_then(|m| m.as_array_mut()) {
                    for msg in messages.iter_mut() {
                        let role = msg.get("role").and_then(|r| r.as_str()).unwrap_or("").to_string();
                        if role == "system" {
                            msg["content"] = json!(sys_prompt);
                        }
                        
                        // Handle cases where Gemini puts an array in content by mistake
                        if role == "assistant" {
                            if let Some(content_val) = msg.get("content") {
                                if content_val.is_array() {
                                    msg["tool_calls"] = content_val.clone();
                                    msg["content"] = Value::Null;
                                }
                            }
                        }
                    }
                }
                
                let row_str = serde_json::to_string(&example).unwrap_or_default();
                if !row_str.is_empty() {
                    let mut file_guard = safe_file.lock().await;
                    let _ = writeln!(file_guard, "{}", row_str);
                    valid_count += 1;
                }
            }

            // Update progress
            {
                let mut p = safe_progress.lock().await;
                p.insert(i);
                let indices: Vec<usize> = p.iter().cloned().collect();
                let _ = std::fs::write(&progress_path, serde_json::to_string_pretty(&indices).unwrap());
            }

            let mut pc = processed_count.lock().await;
            *pc += 1;
            let current_pc = *pc;
            drop(pc);

            if let Some(ref tx) = progress_tx {
                let _ = tx.send(DatasetGenMessage::Log(format!("Chunk {} complete ({} examples).", i + 1, valid_count))).await;
                let progress = 0.05 + 0.95 * (current_pc as f64 / total_chunks as f64);
                let _ = tx.send(DatasetGenMessage::Progress(progress)).await;
            }
        }
    });

    futures::stream::iter(futures).buffer_unordered(concurrency_limit).collect::<Vec<()>>().await;

    // Write sidecar metadata file
    let meta_path = format!("{}.meta", output_file_path);
    let metadata = crate::app::DatasetMetadata { tags };
    if let Ok(meta_json) = serde_json::to_string_pretty(&metadata) {
        let _ = std::fs::write(&meta_path, meta_json);
    }

    Ok(output_file_path)
}

pub async fn recommend_tags(filename: &str, api_key: &str) -> Result<String, Box<dyn Error>> {
    let gemini_url = format!("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={}", api_key);
    let prompt = format!("Given the following medical book filename, output 3 to 5 lowercase, comma-separated tags describing its domain (e.g. anatomy, clinical, rehab, physiology). Do not output anything else. Filename: {}", filename);
    let req_body = json!({
        "contents": [{
            "parts": [{"text": prompt}]
        }],
        "generationConfig": {
            "temperature": 0.2
        }
    });
    
    let client = reqwest::Client::new();
    let mut retries = 3;
    
    while retries > 0 {
        let res = client.post(&gemini_url).json(&req_body).send().await?;
        
        if res.status().is_success() {
            let res_json: serde_json::Value = res.json().await?;
            let text = res_json["candidates"][0]["content"]["parts"][0]["text"]
                .as_str()
                .unwrap_or("")
                .trim()
                .to_string();
            return Ok(text);
        } else if res.status().as_u16() == 503 {
            retries -= 1;
            let err_text = res.text().await.unwrap_or_else(|_| "Unknown error".to_string());
            if retries > 0 {
                tokio::time::sleep(std::time::Duration::from_secs(2)).await;
                continue;
            }
            return Err(format!("Gemini API is currently overloaded (503). Error: {}", err_text).into());
        } else {
            let status = res.status();
            let err_text = res.text().await.unwrap_or_else(|_| "Unknown error".to_string());
            return Err(format!("Gemini Error ({}): {}", status, err_text).into());
        }
    }
    
    Err("Gemini API is currently overloaded. Please type tags manually.".into())
}
