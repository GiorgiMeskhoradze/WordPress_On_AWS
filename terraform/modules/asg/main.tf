resource "aws_autoscaling_group" "aws_asg_group" {
  name                = "WordPress-ASG"
  vpc_zone_identifier = values(var.private_subnet_ids)
  target_group_arns   = [var.target_group_arn]
  health_check_type   = "ELB"
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1

  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }
}