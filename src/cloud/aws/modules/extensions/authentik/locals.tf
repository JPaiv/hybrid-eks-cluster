locals {
  stage        = element(split("-", var.cluster_id), 2)
  id_label     = "${var.namespace}-authentik"
  rds_params   = jsondecode(data.aws_ssm_parameter.rds.value)
  redis_params = jsondecode(data.aws_ssm_parameter.redis.value)
  ses_params   = jsondecode(data.aws_ssm_parameter.ses.value)
}
