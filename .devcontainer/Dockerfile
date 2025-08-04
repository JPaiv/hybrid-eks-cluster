### --- Builder base image for depencies ---

# -- Base image to install depencies
FROM alpine:3.22.1 AS builder

# -- Install depencies as root
USER root

# -- Install OS packages
RUN apk update \
    && apk upgrade \
    && apk add --no-cache \
    bash=5.2.37-r0 \
    curl=8.14.1-r1

# -- Set workdir to the project name
WORKDIR /usr/src/dev-sec-ops

## -- Languages

# -- Golang
RUN wget "https://go.dev/dl/go1.24.0.linux-amd64.tar.gz" -O "go.tar.gz" \
    && tar -xzvf "go.tar.gz" -C /usr/local/bin \
    && rm "go.tar.gz"

# -- Rust
RUN curl "https://sh.rustup.rs" -sSf | sh -s -- -y

## -- Docker

# -- Docker Engine
RUN curl -sL "https://download.docker.com/linux/static/stable/x86_64/docker-27.5.1.tgz" -o "docker.tgz" \
    && tar xzvf "docker.tgz" && rm "docker.tgz" \
    && cp docker/* /usr/local/bin

# -- Moby BuiltKit
RUN curl -sL "https://github.com/moby/buildkit/releases/download/v0.19.0/buildkit-v0.19.0.darwin-amd64.tar.gz" -o "moby.tar.gz" \
    && tar -xzf "moby.tar.gz" \
    && rm "moby.tar.gz" \
    && mv bin/* /usr/local/bin

## -- Kubernetes

# -- Install Helm
RUN curl -sL "https://get.helm.sh/helm-v3.17.4-linux-amd64.tar.gz" -o "helm.tar.gz" \
    && tar -xzf "helm.tar.gz" && rm "helm.tar.gz" \
    && mv "linux-amd64/helm" /usr/local/bin

# -- Install eksctl
RUN curl -sL "https://github.com/eksctl-io/eksctl/releases/download/v0.211.0/eksctl_Linux_amd64.tar.gz" -o "eksctl.tar.gz" \
    && tar -xzf "eksctl.tar.gz" \
    && rm "eksctl.tar.gz" \
    && mv "eksctl" /usr/local/bin

# -- Install Kubectl latest
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 "kubectl" /usr/local/bin/

# -- Install Kubecolor
RUN curl -sL "https://github.com/kubecolor/kubecolor/releases/download/v0.5.1/kubecolor_0.5.1_linux_amd64.tar.gz" -o "kubecolor.tar.gaz" \
    && tar -xzf "kubecolor.tar.gaz" -C /tmp \
    && rm "kubecolor.tar.gaz" \
    && mv "/tmp/kubecolor" /usr/local/bin

# -- Install K9S
RUN curl -SL "https://github.com/derailed/k9s/releases/download/v0.50.9/k9s_Linux_amd64.tar.gz" -o "k9s.tar.gz" \
    && tar -xzf "k9s.tar.gz" \
    && mv "k9s" /usr/local/bin

# -- Cilium CLI
RUN curl -sL "https://github.com/cilium/cilium-cli/releases/download/v0.18.4/cilium-linux-amd64.tar.gz" -o "cilium.tar.gz" \
    && tar -xzf "cilium.tar.gz" \
    && rm "cilium.tar.gz" \
    && mv "cilium" /usr/local/bin

## -- IaC

# -- Terraform
RUN curl -sL "https://releases.hashicorp.com/terraform/1.12.2/terraform_1.12.2_linux_amd64.zip" -o "terraform.zip" \
    && unzip "terraform.zip" \
    && rm "terraform.zip" \
    && mv "terraform" /usr/local/bin/

# -- OpenTofu
RUN curl -sL "https://github.com/opentofu/opentofu/releases/download/v1.10.3/tofu_1.10.3_linux_amd64.tar.gz" -o "tofu.tar.gz" \
    && tar -xzf "tofu.tar.gz" \
    && rm "tofu.tar.gz" \
    && mv "tofu" /usr/local/bin/

# -- Terragrunt
RUN curl -sL "https://github.com/gruntwork-io/terragrunt/releases/download/v0.83.2/terragrunt_linux_amd64" -o "terragrunt" \
    && chmod u+x "terragrunt" \
    && mv "terragrunt" /usr/local/bin/

# -- Install Terraform-docs
RUN curl -sSLo ./terraform-docs.tar.gz "https://terraform-docs.io/dl/v0.20.0/terraform-docs-v0.20.0-Linux-amd64.tar.gz" \
    && tar -xzf "terraform-docs.tar.gz" \
    && rm "terraform-docs.tar.gz" \
    && chmod +x "terraform-docs" \
    && mv "terraform-docs" /usr/local/bin/terraform-docs

# -- Tfsec
RUN curl -SL "https://github.com/aquasecurity/tfsec/releases/download/v1.28.14/tfsec-checkgen-linux-amd64" -o "tfsec" \
    && chmod +x "tfsec" \
    &&  mv "tfsec" /usr/local/bin/

## -- Cloud

# -- Cloud-nuke
RUN curl -sLO "https://github.com/gruntwork-io/cloud-nuke/releases/download/v0.41.0/cloud-nuke_linux_amd64" \
    && mv "cloud-nuke_linux_amd64" "cloud-nuke" \
    && chmod +x "cloud-nuke" \
    && mv "cloud-nuke" /usr/local/bin/

# -- Install AWS CLI v2 Latest
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip "awscliv2.zip" \
    &&  ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli \
    && rm -r "awscliv2.zip"

# -- Install ArgoCD CLI
RUN curl -sL "https://github.com/argoproj/argo-cd/releases/download/v3.6.0/argocd-linux-amd64" -o "argocd" \
    && install -m 555 "argocd" /usr/local/bin/argocd \
    && rm "argocd"

### -- Runtime Devcontainer

# -- Build the runtime devcontainer
FROM mcr.microsoft.com/devcontainers/base:ubuntu AS runtime

# -- Install depencies as root
USER root

# -- Set workdir to project name
WORKDIR /usr/src/dev-sec-ops

# -- Bin depencies
COPY --from=builder /usr/local/bin /usr/local/bin

# -- AWS CLI v2
COPY --from=builder /usr/local/aws-cli /usr/local/aws-cli

# -- Rust
COPY --from=builder /root/.cargo/ /root/.cargo/

# -- Set PATH to all depencies
ENV PATH="/root/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin"

# --Set time zone to Helsinki
ENV TZ="Europe/Helsinki"

# -- Use the default non-root user
USER vscode

# -- Run post-start script to see that everything works
COPY post-start.sh /usr/local/bin/post-start

# -- Allow Terragrunt and post-start devcontainer script
RUN chmod +x /usr/local/bin/post-start \
    && chmod u+x /usr/local/bin/terragrunt
