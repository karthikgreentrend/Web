# OpenSearch Module

This module provisions an AWS OpenSearch domain.

## Inputs
- `domain_name`: Name of the OpenSearch domain
- `engine_version`: OpenSearch version
- `instance_type`: Instance type
- `instance_count`: Number of nodes
- `volume_size`: EBS volume size
- `volume_type`: EBS volume type
- `subnet_ids`: List of subnet IDs
- `security_group_ids`: List of security group IDs
- `access_policies`: Access policy JSON

## Outputs
- `endpoint`: OpenSearch endpoint
