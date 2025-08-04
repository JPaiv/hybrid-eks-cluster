resource "aws_cloudtrail" "this" {
  // -- General
  enable_log_file_validation = true
  name                       = local.id_label

  // -- Cloudwatch
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.this.arn}:*" // --  CloudTrail Requires Wildcard
  cloud_watch_logs_role_arn  = aws_iam_role.this.arn

  // -- Scope
  include_global_service_events = true
  is_multi_region_trail         = true

  // -- Encryption
  kms_key_id = aws_kms_key.trail.arn // -- Use ARN, even if it says key_id --> Hashicorp are idiots as usual

  // -- Storage
  s3_bucket_name = aws_s3_bucket.trail.id
  s3_key_prefix  = local.ctrail_s3_prefix

  event_selector {
    include_management_events = true
    read_write_type           = "All"
  }

  tags = {
    "Description" = "Track Events In All Regions"
    "Name"        = local.id_label
  }
}
