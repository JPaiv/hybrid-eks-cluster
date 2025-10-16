# ---------------------------------------------------------------------------------------------------------------------
# AUTH ADDONS
# Namespace auth
# ---------------------------------------------------------------------------------------------------------------------

resource "kubectl_manifest" "namespace_auth" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: auth
  labels:
    app.kubernetes.io/managed-by: tofu-manifest
    app.kubernetes.io/name: auth
    app.kubernetes.io/part-of: authentication

YAML
}

# ---------------------------------------------------------------------------------------------------------------------
# AUTHENTIK VAULT
# Secrey key is used to signed requests
# Admin is admin user password
# Token is API token
# To be used with the external-secrets operator module
# ---------------------------------------------------------------------------------------------------------------------

module "vault_authentik_skey" {
  source = "../../../modules/secret"

  description = "Authentik external secrets"
  vault_name  = "${module.id_label.id}-vault-authentik-skey"

  abac_tags = {
    "ABAC-Vault" = "authentik"
  }

  secrets = {
    secret_key = {
      name            = "secret-key"
      password_length = 50
    }
    admin = {
      name            = "admin"
      password_length = 50
    }
    token = {
      name            = "token"
      password_length = 50
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# AUTHENTIK HELM
# Requires Elasticache Redis module -> Shared with Argo-CD
# Requires RDS Postgres module
# ----------------------------------------------------------------------------------------------------------------------

module "authentik" {
  source = "../../../modules/addons/authentik"

  # Helm
  chart_version = "2025.8.3"
  namespace     = "auth"
  # EKS
  cluster_id               = local.eks_parameters.cluster_id
  oidc_identity_issuer_url = local.eks_parameters.oidc_identity_issuer_url
  oidc_provider_arn        = local.eks_parameters.oidc_provider_arn
  # Databases
  rds_ssm   = "	/rds/ums-ec1-prod-core-authentik"
  redis_ssm = "/cache/ums-ec1-prod-core-cache-shared"
  # Secrets
  vault_rds   = "ums-ec1-prod-core-vault-authentik-rds"
  vault_redis = "ums-ec1-prod-core-vault-cache-shared"
  vault_skey  = "${module.id_label.id}-vault-authentik-skey"

  abac_tags = {
    vaults = {
      tag_type = "ResourceTag"
      abac_key = "ABAC-Vault"
      abac_values = [
        "authentik",
        "cache-shared",
        "rds-authentik",
      ]
    }
  }

  depends_on = [
    module.cilium,
    module.karpenter,
    module.vault_authentik_skey,
  ]
}
