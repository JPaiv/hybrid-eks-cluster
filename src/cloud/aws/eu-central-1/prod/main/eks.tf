module "eks" {
  source = "../../../modules/eks"

  // -- Naming
  id_label = module.id_label.id

  // -- IAM
  ci_role_arn  = module.dev_sec_ops_ci_role.iam_role_arn
  ci_role_name = module.dev_sec_ops_ci_role.iam_role_name

  //  -- Networking
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
  security_group_ids = module.vpc.security_group_ids

  // -- Cluster Version
  cluster_version = "1.33"

  depends_on = [
    module.dev_sec_ops_ci_role,
    module.vpc,
  ]
}
