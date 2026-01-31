# ElastiCache Module

This module provisions an AWS ElastiCache cluster (Redis).

## Inputs
- `cluster_id`: Name of the ElastiCache cluster
- `engine`: Cache engine (default: redis)
- `node_type`: Instance type
- `num_cache_nodes`: Number of nodes
- `parameter_group_name`: Parameter group
- `port`: Port (default: 6379)
- `subnet_group_name`: Subnet group name
- `subnet_ids`: List of subnet IDs
- `security_group_ids`: List of security group IDs

## Outputs
- `primary_endpoint_address`: Redis endpoint
- `port`: Redis port
