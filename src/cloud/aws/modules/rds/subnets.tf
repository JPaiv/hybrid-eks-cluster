resource "aws_db_subnet_group" "this" {
  name       = "${local.name_label}-db-subnet-group"
  subnet_ids = var.priv_subnet_ids

  tags = {
    "Description" = "RDS database instance"
    "Name"        = "${local.name_label}-db-subnet-group"
  }
}
