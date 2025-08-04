resource "aws_elasticache_replication_group" "this" {
  // -- General
  apply_immediately          = true
  auto_minor_version_upgrade = true
  description                = "Redis ${var.cache_name}"
  replication_group_id       = local.id_label

  // -- Node
  node_type          = "cache.t3.small"
  num_cache_clusters = 1
  port               = var.port

  // -- Cache
  engine         = "redis"
  engine_version = "7.1"

  // -- Encryption and authentication
  at_rest_encryption_enabled = true
  auth_token                 = jsondecode(data.aws_secretsmanager_secret_version.this.secret_string)["password"]
  kms_key_id                 = aws_kms_key.cache.arn
  transit_encryption_enabled = true

  // -- Networking
  network_type       = "ipv4"
  security_group_ids = [aws_security_group.this.id]
  subnet_group_name  = aws_elasticache_subnet_group.this.name

  // -- Updates
  automatic_failover_enabled = false

  // -- Create Cloudwatch log group for both engine and slow logs
  dynamic "log_delivery_configuration" {
    for_each = { for k, v in var.elasticache_logs : k => v }

    content {
      destination      = aws_cloudwatch_log_group.this[log_delivery_configuration.key].name
      destination_type = "cloudwatch-logs"
      log_format       = "json"
      log_type         = log_delivery_configuration.value.log_type
    }
  }

  // -- Ignore changes, or else updates take forever and ever
  lifecycle {
    ignore_changes = [
      node_type,
      num_cache_clusters,
      tags,
    ]
  }

  tags = {
    "Description" = "Redis Cluster for ${var.cache_name}"
    "Name"        = local.id_label
  }
}

resource "aws_elasticache_subnet_group" "this" {
  name       = local.id_label
  subnet_ids = var.priv_subn_ids

  tags = {
    "Description" = "Redis Cluster ${local.id_label} subnet group"
    "Name"        = local.id_label
  }
}
