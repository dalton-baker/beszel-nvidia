# ⚙️ GPU-Enabled Beszel Agent

This repo builds a Docker container for [`henrygd/beszel-agent`](https://github.com/henrygd/beszel) with NVIDIA GPU support baked in.

- ✅ Includes `nvidia-smi` for GPU telemetry
- ✅ Based on `nvidia/cuda:12.9.0-base-ubuntu22.04` — minimal but nvidia-smi ready
- ✅ Multi-stage Go build from upstream source
- ✅ Auto-rebuilds when upstream releases new versions
- ✅ Can be used as a drop-in replacement for the official agent

## 🧠 Why?
The original beszel-agent doesn’t support GPU monitoring out of the box. This version patches that in without bloating the container or breaking upstream compatibility.

## 📦 Docker Image

**Docker Hub:** [`daltonsbaker/beszel-agent-nvidia`](https://hub.docker.com/r/daltonsbaker/beszel-agent-nvidia)

### Tags:
| Tag         | Description                             |
|-------------|-----------------------------------------|
| `latest`    | Latest upstream tag, patched for NVIDIA |
| `yyyy-mm-dd`| Added any time a new image is created   |


## 🚀 Usage

### ⚠️ Requirements
You must have the NVIDIA Container Toolkit installed on the host.
Docker must be configured to support the nvidia runtime.
This image is functionally identical to the official one — refer to the original [Beszel agent documentation](https://beszel.dev/guide/getting-started) for full configuration and setup instructions.

### 🐳 Docker Compose (example)

```yaml
services:
  beszel-agent:
    image: daltonsbaker/beszel-agent-nvidia:latest
    runtime: nvidia
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
      - NVIDIA_DRIVER_CAPABILITIES=utility
      # ... add other required env vars here (see beszel docs)
    volumes:
      # ... mount any required volumes here (see beszel docs)
```

### 🧪 Docker CLI (example)
```bash
docker run --rm \
  --runtime=nvidia \
  -e NVIDIA_VISIBLE_DEVICES=all \
  -e NVIDIA_DRIVER_CAPABILITIES=utility \
  # ... add other required env vars and volume mounts (see beszel docs)
  daltonsbaker/beszel-agent-nvidia:latest
```

## 🔧 Build Pipeline
This repo:
- Clones the upstream henrygd/beszel project
- Builds the cmd/agent Go binary
- Packages it into a CUDA-enabled Debian image with nvidia-smi
- Rebuilds automatically when new upstream tags are pushed
Build output is pushed to Docker Hub


## 🙌 Credits
- [henrygd](https://github.com/henrygd) — creator of Beszel
- [NVIDIA](https://developer.nvidia.com/) — for the CUDA base images
