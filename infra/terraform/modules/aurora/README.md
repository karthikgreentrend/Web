# Aurora Module

This module provisions an AWS Aurora cluster and its instances.

## Inputs
- `cluster_identifier`: Name of the Aurora cluster
- `engine`: Aurora engine (default: aurora-mysql)
- `engine_version`: Aurora engine version
- `master_username`: DB master username
- `master_password`: DB master password
- `database_name`: Initial database name
- `vpc_security_group_ids`: List of security group IDs
- `db_subnet_group_name`: Subnet group name
- `instance_count`: Number of Aurora instances
- `instance_class`: Instance type
- `publicly_accessible`: Whether instances are public

## Outputs
- `cluster_endpoint`: Writer endpoint
- `reader_endpoint`: Reader endpoint
- `cluster_id`: Cluster ID
