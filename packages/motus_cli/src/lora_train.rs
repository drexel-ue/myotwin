use std::error::Error;
use std::process::Stdio;
use tokio::process::Command;
use tokio::io::{AsyncBufReadExt, BufReader};
use tokio::sync::mpsc;
use futures::stream::StreamExt;

pub enum LoraTrainMessage {
    Log(String),
}

pub async fn run_lora_training(
    dataset_paths: Vec<String>,
    lora_name: &str,
    progress_tx: Option<mpsc::Sender<LoraTrainMessage>>
) -> Result<String, Box<dyn Error>> {
    let combined_paths = dataset_paths.join(",");
    let mut child = Command::new("../motus_cli_legacy/.venv/bin/python")
        .arg("-m")
        .arg("modal")
        .arg("run")
        .arg("../motus_cli_legacy/lib/src/python/train_lora_modal.py")
        .arg("--dataset-paths")
        .arg(combined_paths)
        .arg("--lora-name")
        .arg(lora_name)
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()?;

    let stdout = child.stdout.take().expect("Failed to open stdout");
    let stderr = child.stderr.take().expect("Failed to open stderr");

    let mut stdout_reader = BufReader::new(stdout).lines();
    let mut stderr_reader = BufReader::new(stderr).lines();

    if let Some(ref tx) = progress_tx {
        let tx1 = tx.clone();
        let tx2 = tx.clone();
        
        tokio::spawn(async move {
            while let Ok(Some(line)) = stdout_reader.next_line().await {
                let _ = tx1.send(LoraTrainMessage::Log(line)).await;
            }
        });
        
        tokio::spawn(async move {
            while let Ok(Some(line)) = stderr_reader.next_line().await {
                let _ = tx2.send(LoraTrainMessage::Log(line)).await;
            }
        });
    }

    let status = child.wait().await?;
    if !status.success() {
        return Err("Modal training process failed".into());
    }

    let output_gguf = format!("{}_lora-unsloth.Q4_K_M.gguf", lora_name);

    if let Some(ref tx) = progress_tx {
        let _ = tx.send(LoraTrainMessage::Log(format!("Training successful! Downloading {} from Modal...", output_gguf))).await;
    }

    std::fs::create_dir_all("data/models")?;

    let mut download_child = Command::new("../motus_cli_legacy/.venv/bin/python")
        .arg("-m")
        .arg("modal")
        .arg("volume")
        .arg("get")
        .arg("motus-models")
        .arg(&output_gguf)
        .arg("./data/models/")
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()?;

    let dl_stdout = download_child.stdout.take().expect("Failed to open stdout");
    let dl_stderr = download_child.stderr.take().expect("Failed to open stderr");

    let mut dl_stdout_reader = BufReader::new(dl_stdout).lines();
    let mut dl_stderr_reader = BufReader::new(dl_stderr).lines();

    if let Some(ref tx) = progress_tx {
        let tx1 = tx.clone();
        let tx2 = tx.clone();
        
        tokio::spawn(async move {
            while let Ok(Some(line)) = dl_stdout_reader.next_line().await {
                let _ = tx1.send(LoraTrainMessage::Log(line)).await;
            }
        });
        
        tokio::spawn(async move {
            while let Ok(Some(line)) = dl_stderr_reader.next_line().await {
                let _ = tx2.send(LoraTrainMessage::Log(line)).await;
            }
        });
    }

    let dl_status = download_child.wait().await?;
    if !dl_status.success() {
        return Err("Failed to download model from Modal volume".into());
    }

    let final_path = format!("data/models/{}", output_gguf);
    Ok(final_path)
}
