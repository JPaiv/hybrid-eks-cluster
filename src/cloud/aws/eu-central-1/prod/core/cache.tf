# ---------------------------------------------------------------------------------------------------------------------
# SHARED ELASTICACHE REDIS
# Vault with Redis password and ABAC tags
# Elasticache Redis
# ---------------------------------------------------------------------------------------------------------------------

module "vault_cache_shared" {
  source = "../../../modules/secret"

  description = "Elasticache Redis password"
  vault_name  = "${module.id_label.id}-vault-cache-shared"

  abac_tags = {
    "ABAC-Vault" = "cache-shared"
  }

  secrets = {
    password = {
      exclude_characters = "!@#$%^&*()_+-=[]{}|;:',.<>/?`~\"\\"
      name               = "password"
      password_length    = 50
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CACHE SHARED
# Used by the Argo-CD and Authentik Helm chart modules
# Must be in the same VPC as the EKS Cluster
# Traffic only allowed between the worker nodes in the EKS Cluster default security group
# ---------------------------------------------------------------------------------------------------------------------

module "cache_shared" {
  source = "../../../modules/elasticache"

  cache_name      = "cache-shared"
  cluster_id      = module.id_label.id
  vault_name      = "${module.id_label.id}-vault-cache-shared"
  priv_subnet_ids = module.vpc.private_subnet_ids
  vpc_id          = module.vpc.vpc_id

  depends_on = [
    module.eks,
    module.vault_cache_shared,
    module.vpc,
  ]
}
