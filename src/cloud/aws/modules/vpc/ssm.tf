# ---------------------------------------------------------------------------------------------------------------------
# VPC, PRIVATE AND PUBLIC SUBNETS OUTPUTS PARAMETER
# Storage module outputs to the AWS Systems Manager Parameter Store
# Does not contain secrets
# -> Store everything as a string JSON
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_ssm_parameter" "this" {
  # General
  description = "VPC ${var.id_label} parameters"
  name        = "/vpc/${var.id_label}"
  type        = "String"

  value = jsonencode(
    {
      "private_subnet_cidrs" = var.private_subnet_cidrs
      "private_subnet_ids"   = aws_subnet.private.*.id
      "public_subnet_cidrs"  = var.public_subnet_cidrs
      "public_subnet_ids"    = aws_subnet.public.*.id
      "security_group_ids"   = aws_security_group.this.id
      "vpc_id"               = aws_vpc.this.id
    }
  )

  tags = {
    "Description" = "VPC ${var.id_label} parameters"
    "Name"        = "/vpc/${var.id_label}"
  }
}
