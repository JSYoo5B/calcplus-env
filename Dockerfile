FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04
LABEL org.opencontainers.image.source https://github.com/jsyoo5b/calcplus-env

ENV ANT_VER=4.13.2
ENV CLASSPATH=".:/usr/local/lib/antlr-${ANT_VER}-complete.jar:$CLASSPATH"
ENV GO_VERSION=1.25
ENV PATH=/usr/local/go/bin:$PATH

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl wget gnupg lsb-release software-properties-common build-essential openjdk-17-jdk \
    && bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)" -- 20 \
    && ln -s /usr/bin/clang-20 /usr/bin/clang \
    && ln -s /usr/bin/llc-20 /usr/bin/llc \
    && curl -sL https://www.antlr.org/download/antlr-${ANT_VER}-complete.jar -o /usr/local/lib/antlr-${ANT_VER}-complete.jar \
    && printf '#!/bin/bash\njava -Xmx500M -cp "/usr/local/lib/antlr-'${ANT_VER}'-complete.jar:$CLASSPATH" org.antlr.v4.Tool "$@"' > /usr/local/bin/antlr4 \
    && printf '#!/bin/bash\njava -Xmx500M -cp "/usr/local/lib/antlr-'${ANT_VER}'-complete.jar:$CLASSPATH" org.antlr.v4.gui.TestRig "$@"' > /usr/local/bin/grun \
    && chmod +x /usr/local/bin/antlr4 /usr/local/bin/grun \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=golang:1.25-bookworm /usr/local/go /usr/local/go

WORKDIR /workspace