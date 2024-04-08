FROM rust:latest

RUN apt-get update && apt-get -y install openssl libclang-dev python3-dev python3-pip python3

RUN git clone https://github.com/ggerganov/llama.cpp.git Merge-LoRA-Into-GGUF/llama.cpp
RUN cd Merge-LoRA-Into-GGUF/llama.cpp; pip install -r requirements.txt --break-system-packages;make
RUN pip install torch --break-system-packages
RUN pip install safetensors --break-system-packages
RUN pip install peft --break-system-packages
RUN pip install transformers --break-system-packages
RUN pip install einops --break-system-packages

WORKDIR Merge-LoRA-Into-GGUF

RUN echo "import sys\n\
from transformers import AutoModelForCausalLM, AutoTokenizer\n\
\ndef load_and_save_model(model_id):\n\
    model = AutoModelForCausalLM.from_pretrained(model_id)\n\
    tokenizer = AutoTokenizer.from_pretrained(model_id)\n\
    model.load_adapter(\"/lora\")\n\
    model.save_pretrained(\"/lora/save_pretrained\", safe_serialization=False)\n\
\n\
if __name__ == \"__main__\":\n\
    if len(sys.argv) != 2:\n\
        print(\"Usage: python script.py <model_id>\")\n\
        sys.exit(1)\n\
\n\
    model_id = sys.argv[1]\n\
    load_and_save_model(model_id)" > safetensors_to_bin.py

# Make script executable
RUN chmod +x safetensors_to_bin.py

