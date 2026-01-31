variable "cluster_id" {}
variable "engine" { default = "redis" }
variable "node_type" { default = "cache.t3.micro" }
variable "num_cache_nodes" { default = 1 }
variable "parameter_group_name" { default = "default.redis7" }
variable "engine_version" { default = "7.0" }
variable "port" { default = 6379 }
variable "subnet_group_name" {}
variable "subnet_ids" { type = list(string) }
variable "security_group_ids" { type = list(string) }
