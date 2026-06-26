import modal
import os
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
def train_lora_on_gpu(dataset_content: str, model_name: str = "unsloth/Qwen3.5-0.8B", lora_name: str = "anatomy_expert"):
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
    data = [json.loads(line) for line in dataset_content.strip().split("\\n") if line.strip()]
    
    # Convert to HuggingFace dataset
    # We expect the format {"messages": [{"role": "user", "content": "..."}, ...]}
    hf_dataset = Dataset.from_list(data)

    # We need to apply the chat template so the model learns the correct formatting
    def formatting_prompts_func(examples):
        convos = examples["messages"]
        texts = [tokenizer.apply_chat_template(convo, tokenize=False, add_generation_prompt=False) for convo in convos]
        return {"text": texts}

    dataset = hf_dataset.map(formatting_prompts_func, batched = True)

    # 4. Train
    print("🔥 Starting Training...")
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
            output_dir = "outputs",
        ),
    )
    
    trainer_stats = trainer.train()
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
def main(dataset_path: str, lora_name: str):
    """
    Local entrypoint called by the Dart CLI.
    Example: modal run extract_pdf.py --dataset-path data.jsonl --lora-name anatomy
    """
    print(f"Reading dataset from {dataset_path}...")
    with open(dataset_path, "r") as f:
        content = f.read()
        
    print(f"Uploading dataset to Modal and triggering training for {lora_name}...")
    # Call the cloud function synchronously
    filename = train_lora_on_gpu.remote(content, model_name="unsloth/Qwen3.5-0.8B", lora_name=lora_name)
    
    print("=========================================")
    print("✅ Remote Training Complete!")
    print(f"To download your LoRA, run this command:")
    print(f"modal volume get motus-models {lora_name}_lora-unsloth.Q4_K_M.gguf ./packages/motus_server/assets/models/")
    print("=========================================")
