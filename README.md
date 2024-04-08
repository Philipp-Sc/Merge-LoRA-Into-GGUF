# Merge-LoRA-Into-GGUF

docker build -t merge-lora-into-gguf .

# 1) .safetensors => .bin
docker run -it --rm -v "$(pwd)/lora:/lora" merge-lora-into-gguf python3 safetensors_to_bin.py "cognitivecomputations/dolphin-2_6-phi-2"

# 2) convert-lora-to-ggml.py
docker run -it --rm -v "$(pwd)/lora:/lora" merge-lora-into-gguf llama.cpp/convert-lora-to-ggml.py /lora/save_pretrained phi2

# 3) export-lora
docker run -it --rm -v "$(pwd)/lora:/lora" merge-lora-into-gguf ./llama.cpp/export-lora -m /lora/dolphin-2_6-phi-2.Q8_0.gguf -l /lora/save_pretrained/ggml-adapter-model.bin -o /lora/hypnosis-chat-dolphin-2_6-phi-2.Q8_0.gguf

