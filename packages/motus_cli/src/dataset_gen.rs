use std::error::Error;
use std::process::Stdio;
use tokio::process::Command;
use serde_json::{Value, json};
use tokio::sync::mpsc;
use std::fs::OpenOptions;
use std::io::Write;

pub async fn generate_dataset(
    file_path: &str,
    api_key: &str,
    progress_tx: Option<mpsc::Sender<f64>>
) -> Result<String, Box<dyn Error>> {
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
    // We assume the venv is located at packages/motus_cli_legacy/.venv
    let venv_python = "../motus_cli_legacy/.venv/bin/python";
    let script_path = "../motus_cli_legacy/lib/src/python/extract_pdf.py";
    
    let abs_target_path = std::fs::canonicalize(&target_path)?;

    // Send a small progress bump to indicate parsing started
    if let Some(ref tx) = progress_tx {
        let _ = tx.send(0.05).await;
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
    
    let mut file = OpenOptions::new()
        .create(true)
        .write(true)
        .truncate(true)
        .open(&output_file_path)?;

    let client = reqwest::Client::new();
    let gemini_url = format!("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={}", api_key);
    
    let system_instruction = r#"You are a Dataset Generator. You extract physical therapy and rehab knowledge from the provided textbook chunk and convert it into synthetic conversation examples.
Output strictly a JSON array of conversational objects. Each object should have a "messages" array representing the conversation, ending with a tool call.

Example output format:
[
  {
    "messages": [
      {"role": "system", "content": "You are Motus, an AI physical therapist..."},
      {"role": "user", "content": "I have shoulder impingement, it hurts when I lift my arm."},
      {
        "role": "assistant",
        "content": "I've generated a rehab protocol for shoulder impingement based on your symptoms.",
        "tool_calls": [
          {
            "id": "call_rehab_1",
            "type": "function",
            "function": {
              "name": "generate_workout_protocol",
              "arguments": "{\"exercises\":[\"Wall Slides\",\"Scapular Retractions\"],\"intensity\":\"low\"}"
            }
          }
        ]
      }
    ]
  }
]

Generate 3 to 5 realistic examples based ONLY on the clinical information in the text chunk below. Return ONLY the raw JSON array."#;

    let standard_system_prompt = "You are Motus, a world-class AI physical therapist and rehabilitation expert. Your goal is to help users address their aches and pains by generating highly specific rehab and workout protocols based on clinical knowledge.";

    // 4. Iterate chunks and call Gemini
    for (i, chunk_val) in chunks.iter().enumerate() {
        let chunk_text = chunk_val.as_str().unwrap_or("");
        if chunk_text.trim().is_empty() {
            continue;
        }

        let req_body = json!({
            "systemInstruction": {
                "parts": [{"text": system_instruction}]
            },
            "contents": [
                {
                    "parts": [{"text": format!("Textbook Chunk:\n\n{}", chunk_text)}]
                }
            ],
            "generationConfig": {
                "temperature": 0.2,
                "responseMimeType": "application/json"
            }
        });

        let res = client.post(&gemini_url)
            .header("Content-Type", "application/json")
            .json(&req_body)
            .send()
            .await?;

        if !res.status().is_success() {
            let status = res.status();
            let err_text = res.text().await.unwrap_or_default();
            return Err(format!("Gemini API failed with status: {} - {}", status, err_text).into());
        }

        let resp_json: Value = res.json().await?;
        
        let text_response = resp_json
            .pointer("/candidates/0/content/parts/0/text")
            .and_then(|v| v.as_str())
            .ok_or("Failed to extract text from Gemini response")?;

        let generated_examples: Vec<Value> = serde_json::from_str(text_response)
            .map_err(|e| format!("Failed to parse Gemini output as JSON array: {}\nOutput was: {}", e, text_response))?;

        for mut example in generated_examples {
            if let Some(messages) = example.get_mut("messages").and_then(|m| m.as_array_mut()) {
                for msg in messages.iter_mut() {
                    let role = msg.get("role").and_then(|r| r.as_str()).unwrap_or("").to_string();
                    
                    // Enforce Standard System Prompt
                    if role == "system" {
                        msg["content"] = json!(standard_system_prompt);
                    }
                    
                    // Fix Tool Call Hallucination (content is an array instead of tool_calls)
                    if role == "assistant" {
                        if let Some(content_val) = msg.get("content") {
                            if content_val.is_array() {
                                // Move the array to tool_calls and nullify content
                                msg["tool_calls"] = content_val.clone();
                                msg["content"] = Value::Null;
                            }
                        }
                    }
                }
            }
            
            let row_str = serde_json::to_string(&example)?;
            writeln!(file, "{}", row_str)?;
        }

        if let Some(ref tx) = progress_tx {
            // progress is 5% + 95% * (i+1)/total
            let progress = 0.05 + 0.95 * ((i + 1) as f64 / total_chunks as f64);
            let _ = tx.send(progress).await;
        }
    }

    Ok(output_file_path)
}
