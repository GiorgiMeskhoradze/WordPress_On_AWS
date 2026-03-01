variable "public_subnet_ids" {
  description = "public ip for jenkins"
  type        = map(string)
}

variable "private_subnet_ids" {
  description = "private ip for Application Server"
  type        = map(string)
}

variable "launch_template_id" {
  description = "launch_template ID for run asg according to configuration of launch_template"
  type        = string
}

variable "target_group_arn" {
  description = "Target group arn for ASG"
  type        = string
}