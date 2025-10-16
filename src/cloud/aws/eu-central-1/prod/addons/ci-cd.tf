# ---------------------------------------------------------------------------------------------------------------------
# CI-CD ADDONS
# Namespace ci-cd
# ---------------------------------------------------------------------------------------------------------------------

resource "kubectl_manifest" "namespace_ci_cd" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: ci-cd
  labels:
    app.kubernetes.io/managed-by: tofu-manifest
    app.kubernetes.io/name: ci-cd
    app.kubernetes.io/part-of: ci-cd

YAML
}

# ---------------------------------------------------------------------------------------------------------------------
# ARGO-CD VAULT
# Admin password
# ---------------------------------------------------------------------------------------------------------------------

module "vault_argo_cd_admin" {
  source = "../../../modules/secret"

  description = "Argo-cd admin user password"
  vault_name  = "${module.id_label.id}-vault-argo-cd-admin"

  abac_tags = {
    "ABAC-Vault" = "argo-cd"
  }

  secrets = {
    password = {
      name            = "admin.password"
      password_length = 50
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ARGO-CD
# Required Elasticache Redis -> Shared with Authentik
# ----------------------------------------------------------------------------------------------------------------------

module "argo_cd" {
  source = "../../../modules/addons/argo-cd"

  # Helm
  chart_version = "8.1.3"
  ingress_url   = "argocd.unikiemarshalling.com"
  namespace     = "ci-cd"
  # EKS
  cluster_id               = local.eks_parameters.cluster_id
  oidc_identity_issuer_url = local.eks_parameters.oidc_identity_issuer_url
  oidc_provider_arn        = local.eks_parameters.oidc_provider_arn
  # Elasticache Redis Params
  redis_ssm = "/cache/ums-ec1-prod-core-cache-shared"
  # Secrets
  vault_admin = "ums-ec1-prod-addons-vault-argo-cd-admin"
  vault_redis = "ums-ec1-prod-core-vault-cache-shared"

  abac_tags = {
    vault_admin_pass = {
      tag_type = "ResourceTag"
      abac_key = "ABAC-Vault"
      abac_values = [
        "argo-cd",
        "cache-shared",
      ]
    }
  }

  depends_on = [
    kubectl_manifest.namespace_ci_cd,
    module.cilium,
    module.karpenter,
    module.vault_argo_cd_admin,
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# REPO/PROJECT DEV-SEC-OPS RUNNER TOKEN VAULT
# ---------------------------------------------------------------------------------------------------------------------

module "vault_gl_dev_sec_ops" {
  source = "../../../modules/secret"

  description = "Gitlab Runners access token"
  vault_name  = "${module.id_label.id}-vault-gl-dev-sec-ops"

  abac_tags = {
    "ABAC-Vault" = "gl-dev-sec-ops"
  }

  secrets = {
    password = {
      name = "password"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# REPO/PROJECT DEV-SEC-OPS CLOUD RUNNER HELM
# ---------------------------------------------------------------------------------------------------------------------

module "gl_runner_dev_sec_ops" {
  source = "../../../modules/addons/gitlab-runner"

  # EKS
  cluster_id               = local.eks_parameters.cluster_id
  oidc_identity_issuer_url = local.eks_parameters.oidc_identity_issuer_url
  oidc_provider_arn        = local.eks_parameters.oidc_provider_arn
  # Helm
  project = "dev-sec-ops"
  # Secret
  vault_name = "${module.id_label.id}-vault-gl-dev-sec-ops"

  abac_tags = {
    vault = {
      tag_type = "ResourceTag"
      abac_key = "ABAC-Vault"
      abac_values = [
        "gl-dev-sec-ops",
      ]
    }
  }

  depends_on = [
    module.cilium,
    module.karpenter,
    module.vault_gl_dev_sec_ops,
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# REPO/PROJECT AXP RUNNER TOKEN VAULT
# ---------------------------------------------------------------------------------------------------------------------

module "vault_gl_axp" {
  source = "../../../modules/secret"

  description = "Gitlab Runners access token"
  vault_name  = "${module.id_label.id}-vault-gl-axp"

  abac_tags = {
    "ABAC-Vault" = "gl-axp"
  }

  secrets = {
    password = {
      name = "password"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# REPO/PROJECT AXP CLOUD RUNNER HELM
# ---------------------------------------------------------------------------------------------------------------------

module "gl_runner_axp" {
  source = "../../../modules/addons/gitlab-runner"

  # EKS
  cluster_id               = local.eks_parameters.cluster_id
  oidc_identity_issuer_url = local.eks_parameters.oidc_identity_issuer_url
  oidc_provider_arn        = local.eks_parameters.oidc_provider_arn
  # Helm
  project = "axp"
  # Secrets
  vault_name = "${module.id_label.id}-vault-gl-axp"

  abac_tags = {
    vault = {
      tag_type = "ResourceTag"
      abac_key = "ABAC-Vault"
      abac_values = [
        "gl-axp",
      ]
    }
  }

  depends_on = [
    module.cilium,
    module.karpenter,
    module.vault_gl_axp,
  ]
}
