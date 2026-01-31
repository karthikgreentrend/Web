resource "aws_opensearch_domain" "opensearch" {
  domain_name           = var.domain_name
  engine_version        = var.engine_version
  cluster_config {
    instance_type = var.instance_type
    instance_count = var.instance_count
  }
  ebs_options {
    ebs_enabled = true
    volume_size = var.volume_size
    volume_type = var.volume_type
  }
  vpc_options {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }
  access_policies = var.access_policies
}
