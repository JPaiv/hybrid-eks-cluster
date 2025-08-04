// -- EKS Cluster requires specific name for the log group
// -- Same as the cluster name
resource "aws_cloudwatch_log_group" "this" {
  // -- General
  name              = local.cluster_log_group_name
  retention_in_days = 180

  // -- Encryption
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
