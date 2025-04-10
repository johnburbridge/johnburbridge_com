# Start from a base Ubuntu image
FROM ubuntu:22.04

# Set noninteractive frontend to avoid prompts during installs
ENV DEBIAN_FRONTEND=noninteractive

# Install common utilities, Node.js dependencies, Git, Zsh, and tools for kubectl
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    jq \
    git \
    sudo \
    openssh-client \
    zsh \
    apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20.x
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y --no-install-recommends nodejs

# Install Docker CLI
RUN curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh && rm get-docker.sh
# Add docker group and user (see user setup below)
RUN groupadd docker || true

# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y --no-install-recommends gh

# Install kubectl
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update \
    && apt-get install -y kubectl \
    && rm -rf /var/lib/apt/lists/*

# Install ShellCheck
RUN apt-get update && apt-get install -y --no-install-recommends shellcheck && rm -rf /var/lib/apt/lists/*

# Download actionlint (specific version from validate workflow)
ARG ACTIONLINT_VERSION=1.6.25
RUN curl -sL https://raw.githubusercontent.com/rhysd/actionlint/main/scripts/download-actionlint.bash | bash -s -- ${ACTIONLINT_VERSION} \
    && mv actionlint /usr/local/bin/

# Create a non-root user with zsh as default shell and add to sudo/docker groups
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /usr/bin/zsh \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && usermod -aG sudo $USERNAME \
    && usermod -aG docker $USERNAME

# Switch to non-root user FOR oh-my-zsh install
USER $USERNAME
WORKDIR /home/$USERNAME

# Install Oh My Zsh and configure plugins
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    && sed -i 's/plugins=(git)/plugins=(git history kubectl)/g' /home/$USERNAME/.zshrc

# Set default command (optional) - Keep bash for initial container start if needed, terminal will use zsh via settings
# CMD [ "/bin/bash" ]

# Final switch back for container runtime user is implicitly vscode due to USER command above
WORKDIR /home/$USERNAME

# Optional: Clean up apt cache if needed (usually done earlier)
# RUN rm -rf /var/lib/apt/lists/*
