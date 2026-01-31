output "primary_endpoint_address" {
  value = aws_elasticache_replication_group.elasticache.primary_endpoint_address
}

output "reader_endpoint_address" {
  value = aws_elasticache_replication_group.elasticache.reader_endpoint_address
}

output "port" {
  value = aws_elasticache_replication_group.elasticache.port
}
