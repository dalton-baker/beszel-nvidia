# ----------- Stage 1: Fetch code from GitHub -------------
FROM alpine/git AS fetcher
WORKDIR /src
RUN git clone --depth 1 https://github.com/henrygd/beszel.git .

# ----------- Stage 2: Build agent binary -----------------
FROM golang:alpine AS builder
WORKDIR /app

# Copy source from fetcher
COPY --from=fetcher /src/beszel ./

# Build statically linked Go binary
ARG TARGETOS TARGETARCH
RUN CGO_ENABLED=0 GOGC=75 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -ldflags "-w -s" -o /agent ./cmd/agent

# ----------- Stage 3: Minimal runtime with nvidia-smi ----
FROM nvidia/cuda:12.9.0-base-ubuntu22.04

COPY --from=builder /agent /usr/local/bin/agent

ENTRYPOINT ["/usr/local/bin/agent"]