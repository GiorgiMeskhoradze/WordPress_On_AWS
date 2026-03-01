# Gets local IP adress dynamically
data "http" "my_ip" {
  url = "https://ifconfig.me/ip"
}

# ================ ALB Security Group ================
resource "aws_security_group" "alb_sg_group" {
  name = "alb-sg"
  vpc_id = var.vpc_id
  
  tags = {
    "Name" = "alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_alb" {
  security_group_id = aws_security_group.alb_sg_group.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_alb" {
  security_group_id = aws_security_group.alb_sg_group.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb_egress_rule_http" {
  security_group_id = aws_security_group.alb_sg_group.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}


# ================ ASG Security Group ================
resource "aws_security_group" "asg_sg_group" {
  name = "asg-sg"
  vpc_id = var.vpc_id
  
  tags = {
    "Name" = "asg-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ingress_asg" {
  security_group_id = aws_security_group.asg_sg_group.id
  referenced_security_group_id = aws_security_group.alb_sg_group.id
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_ingress_asg" {
  security_group_id = aws_security_group.asg_sg_group.id
  referenced_security_group_id = aws_security_group.alb_sg_group.id
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "asg_ssh_from_jenkins" {
  security_group_id            = aws_security_group.asg_sg_group.id
  referenced_security_group_id = aws_security_group.jenkins_sg_group.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "asg_egress_rule" {
  security_group_id = aws_security_group.asg_sg_group.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}


# ================ Jenkins Security Group ================
resource "aws_security_group" "jenkins_sg_group" {
  name = "jenkins-sg"
  vpc_id = var.vpc_id
  
  tags = {
    "Name" = "jenkins-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_jenkins_ui_port" {
  security_group_id = aws_security_group.jenkins_sg_group.id
  cidr_ipv4 = "${trimspace(data.http.my_ip.response_body)}/32"
  from_port = 8080
  to_port = 8080
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_jenkins_ssh_port" {
  security_group_id = aws_security_group.jenkins_sg_group.id
  cidr_ipv4 = "${trimspace(data.http.my_ip.response_body)}/32"
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "jenkins_to_all_port_egress" {
  security_group_id = aws_security_group.jenkins_sg_group.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

# ================ RDS Security Group ================
resource "aws_security_group" "rds_sg_group" {
  name = "rds-sg"
  vpc_id = var.vpc_id
  
  tags = {
    "Name" = "rds-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_mysql_inbound" {
  security_group_id = aws_security_group.rds_sg_group.id
  referenced_security_group_id = aws_security_group.asg_sg_group.id
  from_port = 3306
  to_port = 3306
  ip_protocol = "tcp"
}


# ================ EFS Security Group ================
resource "aws_security_group" "efs_sg_group" {
  name = "efs-sg"
  vpc_id = var.vpc_id
  
  tags = {
    "Name" = "efs-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_nfs_port" {
  security_group_id = aws_security_group.efs_sg_group.id
  referenced_security_group_id = aws_security_group.asg_sg_group.id
  from_port = 2049
  to_port = 2049
  ip_protocol = "tcp"
}