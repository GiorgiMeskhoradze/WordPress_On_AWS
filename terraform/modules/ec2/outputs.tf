output "launch_template_id" {
  value = aws_launch_template.aws_instance_launch_template.id
}

output "jenkins_id" {
  value = aws_instance.jenkins_instance.id
}
