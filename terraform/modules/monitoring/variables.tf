variable "asg_name" {
  description = "ASG name for cloudwatch metrics"
  type        = string
}

variable "jenkins_id" {
  description = "Jenkins ID for cloudwatch metrics"
  type        = string
}

variable "alert_email" {
  description = "Email address to send alarms to"
  type        = string
}