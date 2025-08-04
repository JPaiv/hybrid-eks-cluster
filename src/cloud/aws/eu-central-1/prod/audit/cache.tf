// -- Shared Redis Elasticache
module "shared_echache" {
  source = "../../../modules/elasticache"

  // -- Naming
  cache_name = "shared"
  cluster_id = module.id_label.id

  // -- Networking configs
  priv_subn_ids  = module.vpc.private_subnet_ids
  sg_ids         = local.security_group_ids
  vpc_id         = module.vpc.vpc_id
  pass_secr_name = "main-ec1-prod-secrets/shared-ecache"
  eks_sg_id      = data.aws_eks_cluster.autokrat.vpc_config[0].cluster_security_group_id

  depends_on = [
    module.vpc,
  ]
}
