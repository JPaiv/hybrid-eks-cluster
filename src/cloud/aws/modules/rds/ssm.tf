resource "aws_ssm_parameter" "this" {
  // -- General
  description = "RDS instance ${local.id_label} connection parameters"
  name        = "/rds/${local.id_label}"
  type        = "String"

  value = jsonencode(
    {
      "endpoint" : aws_db_instance.this.address
      "name" : aws_db_instance.this.db_name
      "port" : tostring(aws_db_instance.this.port)
      "username" : aws_db_instance.this.username
    }
  )

  tags = {
    "Description" = "RDS instance ${local.id_label} connection parameters"
    "Name"        = "/rds/${local.id_label}"
  }
}
