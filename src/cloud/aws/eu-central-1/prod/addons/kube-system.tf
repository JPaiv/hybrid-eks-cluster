# ---------------------------------------------------------------------------------------------------------------------
# NAMESPACE KUBE-SYSTEM
# Karpenter and Cilium are critical add-ons
# -> Their controllers are deployed to the EKS Managed Node Group workers
# Other workloaads are run in the Karpenter managed nodes
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# CILIUM HELM
# ---------------------------------------------------------------------------------------------------------------------

module "cilium" {
  source = "../../../modules/addons/cilium"

  # Helm
  chart_version = "1.18.2"
  # EKS Params
  cluster_endpoint         = local.eks_parameters.cluster_endpoint
  cluster_id               = local.eks_parameters.cluster_id
  oidc_identity_issuer_url = local.eks_parameters.oidc_identity_issuer_url
  oidc_provider_arn        = local.eks_parameters.oidc_provider_arn
}

# ---------------------------------------------------------------------------------------------------------------------
# KARPENTER HELM
# ---------------------------------------------------------------------------------------------------------------------

module "karpenter" {
  source = "../../../modules/addons/karpenter"

  # Helm
  chart_version = "1.7.1"
  # EKS Params
  cluster_endpoint         = local.eks_parameters.cluster_endpoint
  cluster_id               = local.eks_parameters.cluster_id
  node_role_arn            = local.eks_parameters.node_role_arn
  node_role_name           = local.eks_parameters.node_role_name
  oidc_identity_issuer_url = local.eks_parameters.oidc_identity_issuer_url
  oidc_provider_arn        = local.eks_parameters.oidc_provider_arn
}

# ---------------------------------------------------------------------------------------------------------------------
# ALB HELM
# ---------------------------------------------------------------------------------------------------------------------

module "alb" {
  source = "../../../modules/addons/alb"

  # Helm
  chart_version = "1.13.4"
  # EKS Params
  cluster_id               = local.eks_parameters.cluster_id
  oidc_identity_issuer_url = local.eks_parameters.oidc_identity_issuer_url
  oidc_provider_arn        = local.eks_parameters.oidc_provider_arn
  # VPC Params
  vpc_id = local.vpc_parameters.vpc_id

  depends_on = [
    module.cilium,
    module.karpenter,
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# EXTERNAL-DNS HELM
# ---------------------------------------------------------------------------------------------------------------------

module "external_dns" {
  source = "../../../modules/addons/external-dns"

  # Helm
  chart_version = "1.18.0"
  # EKS Params
  cluster_id               = local.eks_parameters.cluster_id
  oidc_identity_issuer_url = local.eks_parameters.oidc_identity_issuer_url
  oidc_provider_arn        = local.eks_parameters.oidc_provider_arn

  depends_on = [
    module.cilium,
    module.karpenter,
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# EXTERNAL-SECRETS OPERATOR HELM
# ---------------------------------------------------------------------------------------------------------------------

module "external_secrets" {
  source = "../../../modules/addons/external-secrets"

  # Helm
  chart_version = "0.19.2"
  # EKS Params
  cluster_id               = local.eks_parameters.cluster_id
  oidc_identity_issuer_url = local.eks_parameters.oidc_identity_issuer_url
  oidc_provider_arn        = local.eks_parameters.oidc_provider_arn

  depends_on = [
    module.cilium,
    module.karpenter,
  ]
}
