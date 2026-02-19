FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04
LABEL org.opencontainers.image.source=https://github.com/jsyoo5b/calcplus-env

COPY --from=golang:1.25-bookworm /usr/local/go /usr/local/go
ENV PATH=$PATH:/usr/local/go/bin

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl wget gnupg lsb-release software-properties-common build-essential \
    python3-pip python3-venv openjdk-25-jre-headless \
    python3 graphviz \
    # Install LLVM \
    && bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)" -- 20 \
    && ln -s /usr/bin/clang-20 /usr/bin/clang \
    && ln -s /usr/bin/llc-20 /usr/bin/llc \
    # Install ANTLR4 \
    && pip3 install --no-cache-dir antlr4-tools graphviz --break-system-packages \
    && echo "grammar Temp; r: '1';" > Temp.g4 \
    && antlr4 Temp.g4 && rm Temp* \
    # Remove caches for docker image size optimization \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*
ENV ANTLR4_TOOLS_ANTLR_VERSION="4.13.2"
COPY tree2img /usr/local/bin/tree2img

WORKDIR /workspace