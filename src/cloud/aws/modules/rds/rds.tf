resource "aws_db_instance" "this" {
  // -- General
  engine         = "postgres"
  engine_version = "16.8"
  identifier     = local.id_label
  instance_class = "db.t3.small"

  // -- Database
  db_name              = var.db_name
  db_subnet_group_name = aws_db_subnet_group.this.name

  // -- Authentication
  username = var.db_username
  password = jsondecode(data.aws_secretsmanager_secret_version.this.secret_string)["password"]

  // -- Networking
  availability_zone      = "eu-central-1a"
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.this.id]

  // -- Storage
  allocated_storage     = 20
  max_allocated_storage = 40
  storage_type          = "gp3"

  // -- Backup
  backup_retention_period = var.backup_retention_period
  backup_window           = "03:00-04:00"
  copy_tags_to_snapshot   = true

  // -- Maintenance
  apply_immediately          = true
  auto_minor_version_upgrade = true
  maintenance_window         = "sun:05:00-sun:06:00"

  // -- Encryption
  kms_key_id        = aws_kms_key.this.arn
  storage_encrypted = true

  // -- Performance Insight
  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  // -- Monitoring
  enabled_cloudwatch_logs_exports = [
    "postgresql",
    "upgrade",
  ]
  monitoring_interval = "60"
  monitoring_role_arn = aws_iam_role.this.arn

  // -- Other
  deletion_protection = var.deletion_protection
  skip_final_snapshot = var.skip_final_snapshot

  tags = {
    "Description" = "RDS ${local.id_label}"
    "Name"        = local.id_label
  }
}
