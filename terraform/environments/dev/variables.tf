variable "region" {
  description = "AWS region for deploy"  
  type = string
}
variable "vpc_cidr" {
  description = "VPC CIDR"  
  type = string
}
variable "public_subnet_cidrs" {
  description = "Public Subnet CIDRS Mapped to Availability Zones"  
  type = map(string)
}
variable "private_subnet_cidrs" {
  description = "Private Subnet CIDRS Mapped to Availability Zones"  
  type = map(string)
}

variable "db_password" {
  description = "RDS password for mysql"
  type = string
}
