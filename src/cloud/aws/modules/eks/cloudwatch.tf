# ---------------------------------------------------------------------------------------------------------------------
# EKS CONTROL PLANE MONITORING
# AWS creates a CW log group for the EKS Cluster
# This log group doesnt't have encryption, etc.
# We create this log group prior to the cluster deployment
# Thus we can have encryption, etc.
# ---------------------------------------------------------------------------------------------------------------------

locals {
  cluster_log_group_name = "/aws/eks/${var.id_label}/cluster"
}

resource "aws_cloudwatch_log_group" "this" {
  # General
  name              = local.cluster_log_group_name
  retention_in_days = 180

  # Encryption
  kms_key_id = aws_kms_key.cloudwatch.arn

  depends_on = [
    aws_kms_key.cloudwatch,
    aws_kms_key_policy.cloudwatch,
  ]

  tags = {
    "Description" = "Control Plane Logs"
    "Name"        = local.cluster_log_group_name
  }
}
