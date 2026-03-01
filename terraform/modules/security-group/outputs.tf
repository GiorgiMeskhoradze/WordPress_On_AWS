output "alb_sg_id" {
  value = aws_security_group.alb_sg_group.id
}

output "asg_sg_id" {
  value = aws_security_group.asg_sg_group.id
}

output "jenkins_sg_id" {
  value = aws_security_group.jenkins_sg_group.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg_group.id
}

output "efs_sg_id" {
  value = aws_security_group.efs_sg_group.id
}