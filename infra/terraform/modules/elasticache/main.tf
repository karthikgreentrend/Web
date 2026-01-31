resource "aws_elasticache_subnet_group" "elasticache" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_replication_group" "elasticache" {
  replication_group_id          = var.cluster_id
  replication_group_description = "Redis replication group for ${var.cluster_id}"
  engine                       = var.engine
  engine_version               = var.engine_version
  node_type                    = var.node_type
  number_cache_clusters        = var.num_cache_nodes
  parameter_group_name         = var.parameter_group_name
  port                         = var.port
  subnet_group_name            = aws_elasticache_subnet_group.elasticache.name
  security_group_ids           = var.security_group_ids
  automatic_failover_enabled   = var.num_cache_nodes > 1 ? true : false
  at_rest_encryption_enabled   = true
  transit_encryption_enabled   = true
  apply_immediately            = true
}
