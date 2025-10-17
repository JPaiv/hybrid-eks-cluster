# Hybrid EKS Cluster

A Terragrunt-driven, opinionated Terraform setup to provision production-grade Amazon EKS clusters.

This project builds upon Particule’s tEKS framework, combining Terraform modules and Terragrunt orchestration to deliver a ready-to-run EKS cluster with sensible defaults and built‑in add‑ons


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