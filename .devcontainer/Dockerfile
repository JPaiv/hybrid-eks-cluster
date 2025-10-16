# ---------- Stage 1/3: Base builder ----------
FROM alpine:3.22.1 AS base-builder

# OS packages
RUN apk update \
    && apk add --no-cache \
    bash \
    curl

# -----------------------------------------------------------------------------
# KUBERNETES
# -----------------------------------------------------------------------------

# Helm
RUN curl -sL https://get.helm.sh/helm-v3.19.0-linux-amd64.tar.gz -o helm.tar.gz \
    && tar -xzf helm.tar.gz \
    && rm helm.tar.gz \
    && mv linux-amd64/helm /usr/local/bin

# Eksctl
RUN curl -sL https://github.com/eksctl-io/eksctl/releases/download/v0.215.0/eksctl_Linux_amd64.tar.gz -o eksctl.tar.gz \
    && tar -xzf eksctl.tar.gz \
    && rm eksctl.tar.gz \
    && mv eksctl /usr/local/bin

# Kubectl
RUN curl -sL https://dl.k8s.io/release/1.34.1/bin/linux/amd64/kubectl -o kubectl \
    && mv kubectl /usr/local/bin/

# Kubecolor
RUN curl -sL https://github.com/kubecolor/kubecolor/releases/download/v0.5.2/kubecolor_0.5.2_linux_amd64.tar.gz -o kubecolor.tar.gaz \
    && tar -xzf kubecolor.tar.gaz \
    && rm kubecolor.tar.gaz \
    && mv kubecolor /usr/local/bin

# K9s
RUN curl -SL https://github.com/derailed/k9s/releases/download/v0.50.15/k9s_Linux_amd64.tar.gz -o k9s.tar.gz \
    && tar -xzf k9s.tar.gz \
    && rm k9s.tar.gz \
    && mv k9s /usr/local/bin

# Cilium CLI
RUN curl -sL https://github.com/cilium/cilium-cli/releases/download/v0.18.4/cilium-linux-amd64.tar.gz -o cilium.tar.gz \
    && tar -xzf cilium.tar.gz \
    && rm cilium.tar.gz \
    && mv cilium /usr/local/bin

# ArgoCD CLI
RUN curl -sSL https://github.com/argoproj/argo-cd/releases/download/v3.1.8/argocd-linux-amd64 -o argocd \
    && mv argocd /usr/local/bin/

# Hubble CLI
RUN curl -sL https://github.com/cilium/hubble/releases/download/v1.18.0/hubble-linux-amd64.tar.gz -o hubble.tar.gz \
    && tar -xzf hubble.tar.gz \
    && rm hubble.tar.gz \
    && mv hubble /usr/local/bin

# -----------------------------------------------------------------------------
# INFRASTRUCSTURE-AS-CODE
# -----------------------------------------------------------------------------

# Terraform
RUN curl -sL https://releases.hashicorp.com/terraform/1.13.3/terraform_1.13.3_linux_amd64.zip -o terraform.zip \
    && unzip terraform.zip \
    && rm terraform.zip \
    && mv terraform /usr/local/bin/

# OpenTofu
RUN curl -sL https://github.com/opentofu/opentofu/releases/download/v1.10.6/tofu_1.10.6_linux_amd64.tar.gz -o tofu.tar.gz \
    && tar -xzf tofu.tar.gz \
    && rm tofu.tar.gz \
    && mv tofu /usr/local/bin/

# Terragrunt
RUN curl -sL https://github.com/gruntwork-io/terragrunt/releases/download/v0.90.0/terragrunt_linux_amd64 -o terragrunt \
    && mv terragrunt /usr/local/bin/

# Terraform-docs
RUN curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v0.20.0/terraform-docs-v0.20.0-Linux-amd64.tar.gz \
    && tar -xzf terraform-docs.tar.gz \
    && rm terraform-docs.tar.gz \
    && mv terraform-docs /usr/local/bin/terraform-docs

# Tfsec
RUN curl -SL https://github.com/aquasecurity/tfsec/releases/download/v1.28.14/tfsec-checkgen-linux-amd64 -o tfsec \
    && mv tfsec /usr/local/bin/

# -----------------------------------------------------------------------------
# CLOUD TOOLS
# -----------------------------------------------------------------------------

# Cloud-Nuke
RUN curl -sL https://github.com/gruntwork-io/cloud-nuke/releases/download/v0.43.0/cloud-nuke_linux_amd64 -o cloud-nuke \
    && mv cloud-nuke /usr/local/bin/

# AWS CLI v2 Latest
RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && rm -r awscliv2.zip \
    &&  ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli

# -----------------------------------------------------------------------------
# LOCAL DEV ENV
# -----------------------------------------------------------------------------

# Tilt
RUN curl -fsSL https://github.com/tilt-dev/tilt/releases/download/v0.35.1/tilt.0.35.1.linux.x86_64.tar.gz -o tilt.tar.gz \
    && tar -xzf tilt.tar.gz \
    && rm tilt.tar.gz \
    && mv tilt /usr/local/bin/

# ---------- Stage 2/3: Node builder ----------
FROM node:24.8.0 AS node-builder

# Typescript
# TSX
# Semantic release
# Verify versions
RUN npm install -g \
    @types/node \
    tsx \
    typescript \
    typescript ts-node

# ---------- Stage 3/3: Runtime devcontainer ----------
FROM mcr.microsoft.com/devcontainers/base:ubuntu AS runtime

# Depencies
COPY --chmod=765 --from=base-builder /usr/local/bin /usr/local/bin

# AWS CLI v2
COPY --chmod=765 --from=base-builder /usr/local/aws-cli /usr/local/aws-cli

# Node
COPY --chmod=765 --from=node-builder /usr/local/bin /usr/local/bin
COPY --chmod=765 --from=node-builder /usr/local/lib/node_modules /usr/local/lib/node_modules

# Devcontainer post-start script
COPY --chmod=765 post-start.sh /usr/local/bin/post-start

# DEPENCIES
# Python3
# C++
# Common utils
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv  \
    apache2-utils \
    bash-completion \
    ripgrep \
    && rm -rf /var/lib/apt/lists/*

# PATH
ENV PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Set time zone to Helsinki
ENV TZ="Europe/Helsinki"

USER vscode
