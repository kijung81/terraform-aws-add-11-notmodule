######## 01 rds cluster ##########

resource "aws_rds_cluster" "rds_cls" {
  cluster_identifier      = "tf-poc-rds-mysql"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.11.2"
  # availability_zones      = ["us-west-2a", "us-west-2b", "us-west-2c"]
  database_name           = var.rds_dbname
  master_username         = var.rds_username
  master_password         = var.rds_password
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  #아래 4개는 기본예제에서 추가 한 Argument
  skip_final_snapshot     = "true"
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.rds_pg.name
  db_subnet_group_name    = aws_db_subnet_group.rds_sbn_g.name
  vpc_security_group_ids  = [aws_security_group.all_sg.id]
  tags = {
    Name = "${var.prefix}rds-mysql"
  }  
}

resource "aws_rds_cluster_parameter_group" "rds_pg" {
  name   = "tf-poc-cparam-mysql"
  family = "aurora-mysql5.7"
}

######## 02 rds instance ##########
resource "aws_rds_cluster_instance" "rds_cls_in" {
  count              = 2
  identifier         = "tf-poc-rdsins-mysql${count.index}"
  cluster_identifier = aws_rds_cluster.rds_cls.id
  instance_class     = var.db_ins_cls
  engine             = aws_rds_cluster.rds_cls.engine
  engine_version     = aws_rds_cluster.rds_cls.engine_version
  db_parameter_group_name = aws_db_parameter_group.db_pg.name
  db_subnet_group_name    = aws_db_subnet_group.rds_sbn_g.name  
  tags = {
    Name = "${var.prefix}-rdsins-mysql"
  }
}


resource "aws_db_parameter_group" "db_pg" {
  name   = "tf-poc-dparam-mysql"
  family = "aurora-mysql5.7"
}

######## 03 db subnet group ######## 

resource "aws_db_subnet_group" "rds_sbn_g" {
  name       = "tf-poc-dbsbngrp-mysql"
  subnet_ids = [aws_subnet.dbpri_sbn_a.id, aws_subnet.dbpri_sbn_c.id]

  tags = {
    Name = "${var.prefix}-dbsbngrp-mysql"
  }
}