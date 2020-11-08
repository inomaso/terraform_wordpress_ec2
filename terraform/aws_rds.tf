####################
# RDS DB Instance
####################
resource "aws_db_instance" "rds" {
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.micro"
  name                    = "wpdb"
  username                = "dbadmin"
  password                = "SuperSecret"
  parameter_group_name    = aws_db_parameter_group.db_pg.name
  option_group_name       = aws_db_option_group.db_og.name
  multi_az                = true
  db_subnet_group_name    = aws_db_subnet_group.db_sub_gp.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  backup_retention_period = "7"
  backup_window           = "22:29-22:59"
  //DB削除前にスナップショットを作成しない
  skip_final_snapshot = true
  //自動スケーリング上限
  max_allocated_storage = 200
  //接続エンドポイント
  identifier = "wpdb"

  tags = {
    Name = "wp_dev_rds"
  }
}

####################
# RDS DB Option Group
####################
resource "aws_db_option_group" "db_og" {
  name                 = "wp-dev-db-og"
  engine_name          = "mysql"
  major_engine_version = "5.7"
}

####################
# RDS DB Parameter Group
####################
resource "aws_db_parameter_group" "db_pg" {
  name   = "wp-dev-db-pg"
  family = "mysql5.7"
}