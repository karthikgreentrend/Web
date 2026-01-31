resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = var.cluster_identifier
  engine                 = var.engine
  engine_version         = var.engine_version
  master_username        = var.master_username
  master_password        = var.master_password
  database_name          = var.database_name
  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name
  skip_final_snapshot    = true
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count              = var.instance_count
  identifier         = "${var.cluster_identifier}-instance-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = var.instance_class
  engine             = var.engine
  engine_version     = var.engine_version
  publicly_accessible = var.publicly_accessible
}
