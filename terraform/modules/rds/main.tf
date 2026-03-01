resource "aws_db_subnet_group" "database_subnet_group" {
  name       = "wordpress-subnet-group"
  subnet_ids = values(var.private_subnet_ids)
}

resource "aws_db_instance" "database_instance" {
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"

  db_name  = "wordpress"
  username = "admin"
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids = [var.rds_sg_id]

  allocated_storage   = 20
  skip_final_snapshot = true

  tags = {
    Name = "wordpress-rds"
  }
}

