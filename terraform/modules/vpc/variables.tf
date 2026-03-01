variable "vpc_cidr" {
  description = "CIDR block for VPC"  
  type = string
}

variable "public_subnets" {
  description = "Public Subnet CIDRS Mapped to Availability Zones"  
  type = map(string)
}
variable "private_subnets" {
  description = "Private Subnet CIDRS Mapped to Availability Zones"  
  type = map(string)
}
