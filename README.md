# tf‑tg‑eks

A Terragrunt-driven, opinionated Terraform setup to provision production-grade Amazon EKS clusters.

This project builds upon Particule’s tEKS framework, combining Terraform modules and Terragrunt orchestration to deliver a ready-to-run EKS cluster with sensible defaults and built‑in add‑ons


## 🧩 What It Does
    Orchestrates infrastructure using Terraform and Terragrunt
    Provisions a VPC (via terraform‑aws‑vpc), EKS cluster (terraform‑aws‑eks), and curated Kubernetes add-ons (terraform‑kubernetes‑addons)
    Supports multi‑cluster deployments with minimal setup and automated configuration

## 📦 Requirements
    Open Tofu
    Terragrunt
    AWS credentials configured for CLI access

## 🗂️ Directory Structure
    ├── src/
        └── cloud/
                └── aws/
                │     └── prod/
                └── modules/

## ⚙️ Customization & Variables
    Default variables can be overridden in .tfvars files per environment
    Customize VPC CIDR, number of AZs, node group settings, add-ons, cluster version, IAM roles, etc.

## 🔧 Add‑On Support
    The setup includes sensible configuration for Kubernetes add-ons such as:
        CoreDNS
        EBS CSI