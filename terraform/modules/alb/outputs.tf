output "target_group_arn" {
  value = aws_lb_target_group.alb_tg_group.arn
}

output "aws_dns_name" {
  value = aws_lb.aws_alb_server.dns_name
}