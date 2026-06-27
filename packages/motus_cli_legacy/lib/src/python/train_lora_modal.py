import modal
import json

# Define the cloud environment
# We use a base image with PyTorch and install Unsloth and dependencies
image = (
    modal.Image.debian_slim(python_version="3.11")
    .apt_install("git")
    .pip_install(
        "torch",
        "transformers",
        "datasets",
        "trl",
        "peft",
        "accelerate",
        "bitsandbytes",
        "sentencepiece",
        "xformers"
    )
    # Install Unsloth directly from GitHub for the latest hardware support
    .pip_install("unsloth[colab-new] @ git+https://github.com/unslothai/unsloth.git")
)

app = modal.App("motus-lora-trainer")

# Create a persistent volume to store the resulting GGUF model files
# so they can be downloaded back to the local machine
model_volume = modal.Volume.from_name("motus-models", create_if_missing=True)

@app.function(
    image=image, 
    gpu="A10G", # A10G is cheap and has 24GB VRAM, perfect for Qwen 0.8B
    timeout=3600, # 1 hour max
    volumes={"/models": model_volume}
)
def train_lora_on_gpu(dataset_content: str, model_name: str = "unsloth/Llama-3.2-1B-Instruct", lora_name: str = "anatomy_expert"):
    from unsloth import FastLanguageModel
    from datasets import Dataset
    from trl import SFTTrainer
    from transformers import TrainingArguments
    from unsloth import is_bfloat16_supported

    print("🚀 Initializing Unsloth...")
    
    # 1. Load Model
    max_seq_length = 2048
    dtype = None # Auto detection
    load_in_4bit = True # Use 4bit quantization to save memory

    model, tokenizer = FastLanguageModel.from_pretrained(
        model_name = model_name,
        max_seq_length = max_seq_length,
        dtype = dtype,
        load_in_4bit = load_in_4bit,
    )

    # 2. Add LoRA Adapters
    print("🧠 Attaching LoRA Adapters...")
    model = FastLanguageModel.get_peft_model(
        model,
        r = 16, # Choose any number > 0 ! Suggested 8, 16, 32, 64, 128
        target_modules = ["q_proj", "k_proj", "v_proj", "o_proj",
                          "gate_proj", "up_proj", "down_proj",],
        lora_alpha = 16,
        lora_dropout = 0, 
        bias = "none",
        use_gradient_checkpointing = "unsloth",
        random_state = 3407,
        use_rslora = False,
        loftq_config = None,
    )

    # 3. Process Dataset
    print("📚 Processing Dataset...")
    # Parse the JSONL string back into a list of dicts
    data = [json.loads(line) for line in dataset_content.strip().splitlines() if line.strip()]
    
    import tempfile
    from datasets import load_dataset
    
    with tempfile.NamedTemporaryFile("w", suffix=".jsonl", delete=False) as f:
        for row in data:
            for msg in row.get("messages", []):
                if isinstance(msg.get("content"), list):
                    msg["tool_calls"] = msg["content"]
                    msg["content"] = ""
                elif msg.get("content") is None:
                    msg["content"] = ""
            f.write(json.dumps(row) + "\n")
        temp_path = f.name
        
    hf_dataset = load_dataset("json", data_files=temp_path, split="train")

    # We need to apply the chat template so the model learns the correct formatting
    def formatting_prompts_func(examples):
        convos = examples["messages"]
        
        # HuggingFace Datasets pads missing keys (like tool_calls) with None to maintain a uniform schema.
        # This causes the Jinja chat template to crash when it tries to get the length of a NoneType.
        # We must strip out any None values before passing to apply_chat_template.
        clean_convos = []
        for convo in convos:
            clean_convo = []
            for msg in convo:
                clean_msg = {k: v for k, v in msg.items() if v is not None}
                clean_convo.append(clean_msg)
            clean_convos.append(clean_convo)
            
        texts = [tokenizer.apply_chat_template(convo, tokenize=False, add_generation_prompt=False) for convo in clean_convos]
        return {"text": texts}

    dataset = hf_dataset.map(formatting_prompts_func, batched = True)

    # 4. Train
    print("🔥 Starting Training...")
    
    import os
    checkpoint_dir = f"/models/{lora_name}_checkpoints"
    resume = False
    if os.path.exists(checkpoint_dir):
        # Check if it contains checkpoint folders (starts with "checkpoint-")
        checkpoints = [d for d in os.listdir(checkpoint_dir) if d.startswith("checkpoint-")]
        if len(checkpoints) > 0:
            resume = True
            print(f"🔄 Found existing checkpoints in {checkpoint_dir}. Resuming training...")
    trainer = SFTTrainer(
        model = model,
        tokenizer = tokenizer,
        train_dataset = dataset,
        dataset_text_field = "text",
        max_seq_length = max_seq_length,
        dataset_num_proc = 2,
        packing = False,
        args = TrainingArguments(
            per_device_train_batch_size = 2,
            gradient_accumulation_steps = 4,
            warmup_steps = 5,
            max_steps = 60, # Keep it short for prototyping, increase later
            learning_rate = 2e-4,
            fp16 = not is_bfloat16_supported(),
            bf16 = is_bfloat16_supported(),
            logging_steps = 1,
            optim = "adamw_8bit",
            weight_decay = 0.01,
            lr_scheduler_type = "linear",
            seed = 3407,
            output_dir = checkpoint_dir,
            save_strategy = "steps",
            save_steps = 10,
        ),
    )
    
    trainer.train(resume_from_checkpoint=resume)
    print("✅ Training Complete!")

    # 5. Export to GGUF
    print("💾 Exporting to GGUF Format...")
    output_path = f"/models/{lora_name}_lora"
    
    # Save the native peft adapters first (optional but good practice)
    model.save_pretrained(f"/models/{lora_name}_peft")
    tokenizer.save_pretrained(f"/models/{lora_name}_peft")

    # Save to GGUF. We use q4_k_m as it's the standard balance of size and quality
    model.save_pretrained_gguf(output_path, tokenizer, quantization_method = "q4_k_m")
    
    # Force commit the volume so the files are flushed to Modal storage
    model_volume.commit()
    
    print(f"🎉 GGUF exported successfully to {output_path}")
    return f"{lora_name}_lora-unsloth.Q4_K_M.gguf"

@app.local_entrypoint()
def main(dataset_paths: str, lora_name: str):
    """
    Local entrypoint called by the Dart CLI or Rust CLI.
    Example: modal run train_lora_modal.py --dataset-paths data1.jsonl,data2.jsonl --lora-name anatomy
    """
    print(f"Reading datasets from {dataset_paths}...")
    paths = dataset_paths.split(',')
    
    combined_content = ""
    for path in paths:
        path = path.strip()
        if not path:
            continue
        print(f"  - Loading {path}")
        with open(path, "r") as f:
            combined_content += f.read() + "\n"
            
    print(f"Uploading merged dataset to Modal and triggering training for {lora_name}...")
    # Call the cloud function synchronously
    train_lora_on_gpu.remote(combined_content, model_name="unsloth/Llama-3.2-1B-Instruct", lora_name=lora_name)
    
    print("=========================================")
    print("✅ Remote Training Complete!")
    print("To download your LoRA, run this command:")
    print(f"modal volume get motus-models {lora_name}_lora-unsloth.Q4_K_M.gguf ./packages/motus_server/assets/models/")
    print("=========================================")
