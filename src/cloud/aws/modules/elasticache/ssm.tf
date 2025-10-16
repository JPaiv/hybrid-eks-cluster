# ---------------------------------------------------------------------------------------------------------------------
# SM PARAMETER STORE
# Store connection params
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_ssm_parameter" "this" {
  # General
  description = "Elasticache Redis ${local.id_label} connection parameters"
  name        = "/cache/${local.id_label}"
  type        = "String"

  value = jsonencode(
    {
      "endpoint" : aws_elasticache_replication_group.this.primary_endpoint_address
      "port" : var.port
    }
  )

  tags = {
    "Description" = "Elasticache Redis ${local.id_label} connection parameters"
    "Name"        = "/cache/${local.id_label}"
  }
}
