variable "region" {
  description = "AWS region for deploy"
  type        = string
}
variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}
variable "public_subnet_cidrs" {
  description = "Public Subnet CIDRS Mapped to Availability Zones"
  type        = map(string)
}
variable "private_subnet_cidrs" {
  description = "Private Subnet CIDRS Mapped to Availability Zones"
  type        = map(string)
}

variable "db_password" {
  description = "RDS password for mysql"
  type        = string
}

variable "domain_name" {
  description = "Domain Name for Web Server"
  type        = string
}

variable "hosted_zone_id" {
  description = "Hosted Zone id for DNS"
  type        = string
}

variable "ami_id" {
  description = "ami ID for Server"
  type        = string
}

variable "instance_type" {
  description = "instance type for Server"
  type        = string
}

variable "key_name" {
  description = "key for Server to ssh"
  type        = string
}

variable "alert_email" {
  description = "Email address to send alarms to"
  type        = string
}