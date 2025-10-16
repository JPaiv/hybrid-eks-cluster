locals {
  eks_parameters = jsondecode(data.aws_ssm_parameter.cluster.value)
  vpc_parameters = jsondecode(data.aws_ssm_parameter.vpc.value)
}
