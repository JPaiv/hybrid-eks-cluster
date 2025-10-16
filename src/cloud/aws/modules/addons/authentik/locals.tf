locals {
  stage = element(split("-", var.cluster_id), 2)

  #Naming
  name_label   = "${var.namespace}-authentik"
  secret_label = "${local.name_label}-vault"
  irsa_name    = "${var.cluster_id}-${local.name_label}-irsa"

  # DB params
  rds_params   = jsondecode(data.aws_ssm_parameter.rds.value)
  redis_params = jsondecode(data.aws_ssm_parameter.redis.value)
}
