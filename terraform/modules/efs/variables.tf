variable "private_subnet_ids" {
  description = "Private subnet IDs mapped to availability zones"
  type        = map(string)
}

variable "efs_sg_group_id" {
  description = "Security group ID for EFS mount targets"
  type        = string
}