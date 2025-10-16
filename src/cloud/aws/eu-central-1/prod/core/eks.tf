# ---------------------------------------------------------------------------------------------------------------------
# UMS PRIMARY EKS CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

module "eks" {
  source = "../../../modules/eks"

  cluster_version = "1.34"
  id_label        = module.id_label.id
  # VPC Params
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids

  depends_on = [
    module.vpc,
  ]
}
