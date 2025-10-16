# ---------------------------------------------------------------------------------------------------------------------
# VPC IP TRAFFIC LOGS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_flow_log" "this" {
  log_destination      = aws_s3_bucket.this.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.this.id

  # Flow Log format fields
  log_format = "$${version} $${vpc-id} $${subnet-id} $${instance-id} $${interface-id} $${account-id} $${type} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${pkt-srcaddr} $${pkt-dstaddr} $${protocol} $${bytes} $${packets} $${start} $${end} $${action} $${tcp-flags} $${log-status}"

  tags = {
    "Description" = "Network traffic monitoring and auditing with encrypted S3 storage"
    "Name"        = local.name_label
  }
}
