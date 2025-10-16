# By default the EBS volumes aren't encrypted
# ref: https://docs.aws.amazon.com/ebs/latest/userguide/encryption-by-default.html
resource "aws_ebs_encryption_by_default" "this" {
  enabled = true
}

# CM KMS default encryption for the all EBS volumes
resource "aws_ebs_default_kms_key" "this" {
  key_arn = aws_kms_key.ebs.arn
}
