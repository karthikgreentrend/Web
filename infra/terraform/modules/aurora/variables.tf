variable "cluster_identifier" {}
variable "engine" { default = "aurora-mysql" }
variable "engine_version" { default = "8.0.mysql_aurora.3.04.0" }
variable "master_username" {}
variable "master_password" {}
variable "database_name" {}
variable "vpc_security_group_ids" { type = list(string) }
variable "db_subnet_group_name" {}
variable "instance_count" { default = 2 }
variable "instance_class" { default = "db.r6g.large" }
variable "publicly_accessible" { default = false }
