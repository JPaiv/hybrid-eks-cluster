resource "aws_ssm_parameter" "this" {
  // -- General
  description = "RDS database instance ${local.id_label} connection config values"
  name        = "/elasticache/${local.id_label}"
  type        = "String"

  value = jsonencode({
    "endpoint" : aws_elasticache_replication_group.this.primary_endpoint_address
    "port" : var.port
  })

  tags = {
    "Description" = "RDS Postgres instance ${local.id_label} connection parameters"
    "Name"        = "/elasticache/${local.id_label}"
  }
}
