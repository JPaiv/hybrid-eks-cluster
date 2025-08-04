// -- Account ID
data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "autokrat" {
  name = module.id_label.id
}
