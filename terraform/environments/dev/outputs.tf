# ── ALB ───────────────────────────────────────────────────
output "alb_dns_name" {
  description = "ALB DNS name — public entry point for WordPress"
  value       = module.alb.aws_dns_name
}

# ── RDS ───────────────────────────────────────────────────
output "rds_endpoint" {
  description = "RDS endpoint — WordPress database host"
  value       = module.rds.db_endpoint
}

# ── NETWORK ───────────────────────────────────────────────
output "vpc_id" {
  description = "VPC ID — useful for debugging networking issues"
  value       = module.networking.vpc_id
}

output "jenkins_ip" {
  value = module.ec2.jenkins_ip
}