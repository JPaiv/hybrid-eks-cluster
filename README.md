# Hybrid EKS Cluster

EKS Cluster with both on-prem and cloud worker nodes.

## 🧩 What It Does
    Orchestrates infrastructure using Terraform and Terragrunt
    Supports multi‑cluster deployments with minimal setup and automated configuration

## 📦 Requirements
    Open Tofu
    Terragrunt
    AWS credentials configured for CLI access with SSO
    AWS IAM with admin permissions

## 🗂️ Directory Structure
     src/
        └── cloud/
            └── aws/
                ├── eu-central-1/
                │   └── prod/ -> Where the deployment happens
                └── modules/ -> Where the modules to be deployed rest

## ⚙️ Customization & Variables
    Default variables can be overridden in .tfvars files per environment
    Customize VPC CIDR, number of AZs, node group settings, add-ons, cluster version, IAM roles, etc.

## 🔧 Add‑On Support
    The setup includes sensible configuration for Kubernetes AWS managed add-ons such as:
        CoreDNS
        EBS CSI
        Metrics Server