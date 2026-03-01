variable "alb_sg_group_id" {
  description = "Firewall for ALB"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public Subnet for ALB"
  type        = map(string)
}

variable "vpc_id" {
  description = "VPC for Target Groups"
  type        = string
}

variable "certificate_arn" {
  description = "Certificate arn for HTTPS Listener"
  type        = string
}