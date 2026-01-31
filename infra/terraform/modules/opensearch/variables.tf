variable "domain_name" {}
variable "engine_version" { default = "OpenSearch_2.11" }
variable "instance_type" { default = "t3.small.search" }
variable "instance_count" { default = 1 }
variable "volume_size" { default = 10 }
variable "volume_type" { default = "gp3" }
variable "subnet_ids" { type = list(string) }
variable "security_group_ids" { type = list(string) }
variable "access_policies" { default = "" }
