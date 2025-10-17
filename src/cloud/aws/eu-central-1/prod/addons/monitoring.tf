# ---------------------------------------------------------------------------------------------------------------------
# MONITORING ADDONS
# Namespace: monitoring
# ---------------------------------------------------------------------------------------------------------------------

resource "kubectl_manifest" "namespace_monitoring" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: monitoring
  labels:
    app.kubernetes.io/managed-by: tofu-manifest
    app.kubernetes.io/name: monitoring
    app.kubernetes.io/part-of: monitoring

YAML
}

module "vault_loki" {
  source = "../../../modules/secret"

  description = "Grafana admin password and username"
  vault_name  = "${module.id_label.id}-vault-loki"

  abac_tags = {
    "ABAC-Vault" = "loki"
  }

  secrets = {
    admin-password = {
      name            = ".htpasswd"
      password_length = 50
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# LOKI HELM
# ---------------------------------------------------------------------------------------------------------------------

module "loki" {
  source = "../../../modules/addons/loki"

  # Helm
  chart_version = "6.41.1"
  ingress_url   = "loki.unikiemarshalling.com"

  # EKS
  cluster_id               = local.eks_parameters.cluster_id
  oidc_identity_issuer_url = local.eks_parameters.oidc_identity_issuer_url
  oidc_provider_arn        = local.eks_parameters.oidc_provider_arn

  # Secrets
  vault_name = "${module.id_label.id}-vault-loki"
  abac_tags = {
    vault = {
      tag_type = "ResourceTag"
      abac_key = "ABAC-Vault"
      abac_values = [
        "loki",
      ]
    }
  }

  depends_on = [
    kubectl_manifest.namespace_monitoring,
    module.cilium,
    module.karpenter,
    module.vault_loki,
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# ALLOY HELM CHART
# Requires Loki Helm
# ---------------------------------------------------------------------------------------------------------------------

module "alloy" {
  source = "../../../modules/addons/alloy"

  # Helm
  chart_version = "1.2.1"

  # EKS
  cluster_id               = local.eks_parameters.cluster_id
  oidc_identity_issuer_url = local.eks_parameters.oidc_identity_issuer_url
  oidc_provider_arn        = local.eks_parameters.oidc_provider_arn

  # Secrets
  vault_name = "${module.id_label.id}-vault-loki"
  abac_tags = {
    vault = {
      tag_type = "ResourceTag"
      abac_key = "ABAC-Vault"
      abac_values = [
        "loki",
      ]
    }
  }
  depends_on = [
    kubectl_manifest.namespace_monitoring,
    module.cilium,
    module.karpenter,
    module.loki,
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# GRAFANA VAULT
# Grafana admin user password
# Grafana admin username has to be placed manually
# ---------------------------------------------------------------------------------------------------------------------

module "vault_grafana" {
  source = "../../../modules/secret"

  description = "Grafana admin password and username"
  vault_name  = "${module.id_label.id}-vault-monitoring-grafana"

  abac_tags = {
    "ABAC-Vault" = "grafana"
  }

  secrets = {
    admin-password = {
      name            = "admin-password"
      password_length = 50
    }
    admin-user = {
      name            = "admin-user"
      password_length = 50
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# KUBE-PROMETHEUS-STACK HELM
# ---------------------------------------------------------------------------------------------------------------------

module "kube_prometheus_stack" {
  source = "../../../modules/addons/kube-prometheus-stack"

  # Helm
  chart_vers = "77.0.1"

  # EKS
  cluster_id               = local.eks_parameters.cluster_id
  oidc_identity_issuer_url = local.eks_parameters.oidc_identity_issuer_url
  oidc_provider_arn        = local.eks_parameters.oidc_provider_arn
  ingress_url              = "placeholder.com"

  # Secrets
  vault_name = "${module.id_label.id}-vault-monitoring-grafana"

  abac_tags = {
    vault = {
      tag_type = "ResourceTag"
      abac_key = "ABAC-Vault"
      abac_values = [
        "grafana",
      ]
    }
  }

  depends_on = [
    kubectl_manifest.namespace_monitoring,
    module.cilium,
    module.karpenter,
    module.vault_grafana,
  ]
}
