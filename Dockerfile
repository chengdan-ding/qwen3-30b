FROM docker.1ms.run/vllm/vllm-openai:latest

WORKDIR /data

# 1. 安装 modelscope
RUN pip install --no-cache-dir modelscope

# 2. 设置环境变量
ENV SAFETENSORS_FAST_GPU=1 \
    NCCL_P2P_DISABLE=0 \
    VLLM_TUNED_CONFIG_FOLDER=/data \
    PYTHONUNBUFFERED=1

# 3. 下载模型
# ModelScope 默认下载到 /data/models/Qwen/Qwen3-30B-A3B
RUN python3 -c "from modelscope import snapshot_download; \
    snapshot_download('Qwen/Qwen3-30B-A3B', \
    cache_dir='/data/models')"

# 启动命令
ENTRYPOINT ["python3", "-m", "vllm.entrypoints.openai.api_server"]

# 对应 ModelScope 默认存储的完整路径
CMD ["--model", "/data/models/Qwen/Qwen3-30B-A3B", \
     "--served-model-name", "Qwen3-30B-A3B", \
     "--tensor-parallel-size", "4", \
     "--max-model-len", "32768", \
     "--max-num-batched-tokens", "32768", \
     "--gpu-memory-utilization", "0.95", \
     "--max-num-seqs", "256", \
     "--api-key", "begdCdeQcrNVLYMwrEgMD3WG-tsDcUoRTIHFQF8M-x0=", \
     "--reasoning-parser", "deepseek_r1", \
     "--trust-remote-code"]
