ARG VARIANT="bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}

# Default OS packages.
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt update \
    && apt upgrade -yqq \
    && apt install -yqq \
    apt-transport-https \
    ca-certificates \
    curl \
    fzf \
    make \
    software-properties-common \
    tar \
    tree \
    unzip \
    vim \
    zip

RUN test "$(uname -m)" = "aarch64" \
    && curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_arm64/session-manager-plugin.deb" -o "/tmp/session-manager-plugin.deb" \
    || true
RUN test "$(uname -m)" = "x86_64" \
    && curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "/tmp/session-manager-plugin.deb" \
    || true
RUN dpkg -i /tmp/session-manager-plugin.deb \
    && rm /tmp/session-manager-plugin.deb

# Swith user
USER vscode

ENV HOME=/home/vscode

# Default environment variables.
ENV LOCAL_BIN=${HOME}/.local/bin
ENV PATH=$LOCAL_BIN:$PATH

# Local binaries.
RUN mkdir -p $LOCAL_BIN \
    && echo "npx --yes aws-cdk@1.x \$@" > $LOCAL_BIN/cdk1 \
    && echo "npx --yes aws-cdk@2.x \$@" > $LOCAL_BIN/cdk2 \
    && chmod +x $LOCAL_BIN/*

# Add FZF setup to .bashrc
RUN echo "# FZF" >> ${HOME}/.bashrc \
    && echo "source /usr/share/doc/fzf/examples/completion.bash" >> ~/.bashrc \
    && echo "source /usr/share/doc/fzf/examples/key-bindings.bash" >> ~/.bashrc

# Add FZF setup to .zshrc
RUN echo "# FZF" >> ${HOME}/.zshrc \
    && echo "source /usr/share/doc/fzf/examples/completion.zsh" >> ~/.zshrc \
    && echo "source /usr/share/doc/fzf/examples/key-bindings.zsh" >> ~/.zshrc

# Add MVN dir - named volume permissions require this!
RUN mkdir ${HOME}/.m2
