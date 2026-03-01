variable "private_subnet_ids" {
  description = "Private subnet IDs mapped to availability zones"
  type        = map(string)
}

variable "db_password" {
  description = "RDS database password"
  type        = string
  sensitive   = true
}

variable "rds_sg_id" {
  description = "Security group ID for RDS"
  type        = string
}