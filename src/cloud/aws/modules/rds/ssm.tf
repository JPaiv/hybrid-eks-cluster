resource "aws_ssm_parameter" "this" {
  description = "RDS instance connection parameters"
  name        = "/rds/${local.name_label}"
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
    "Description" = "RDS instance connection parameters"
    "Name"        = "/rds/${local.name_label}"
  }
}
