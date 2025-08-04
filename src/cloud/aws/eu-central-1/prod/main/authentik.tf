locals {
  # -- List all EKS Cluster affiliated security groups
  all_eks_cluster_sg = concat(
    [data.aws_eks_cluster.autokrat.vpc_config[0].cluster_security_group_id],
    module.vpc.security_group_ids,
    tolist(data.aws_eks_cluster.autokrat.vpc_config[0].security_group_ids),
  )
  # -- Clean final list without duplicates
  security_group_ids = distinct(local.all_eks_cluster_sg)
}

module "authentik" {
  source = "../../../modules/rds"

  // -- Naming
  cluster_id = module.id_label.id

  //  -- Networking
  db_name            = "authentik"
  db_username        = "authentik"
  passw_secr_name    = "ums-ec1-prod-secrets/authentik-rds-pass"
  priv_subnet_ids    = module.vpc.private_subnet_ids
  security_group_ids = [data.aws_eks_cluster.autokrat.vpc_config[0].cluster_security_group_id]
  vpc_id             = module.vpc.vpc_id
}

// -- ACM DNS Certs for unikiemarshalling.com subdomains
module "authentik_ses" {
  source = "../../../modules/ses"

  // -- Naming
  cluster_id = module.id_label.id
}
