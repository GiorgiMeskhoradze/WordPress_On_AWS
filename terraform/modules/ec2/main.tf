resource "aws_instance" "jenkins_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = values(var.public_subnet_ids)[0]
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.jenkins_sg_id]
  associate_public_ip_address = true

  tags = {
    "Name" = "Jenkins-Server"
    "Role" = "jenkins" 
  }
}

resource "aws_launch_template" "aws_instance_launch_template" {
  name          = "Template-for-WordPress"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    security_groups             = [var.asg_sg_id]
    associate_public_ip_address = false
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    efs_id      = var.efs_id
    db_host     = var.db_host
    db_password = var.db_password
    PHP_VERSION  = "8.3"
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      "Name" = "WordPress-Instance"
      "Role" = "wordpress"
    }
  }
}