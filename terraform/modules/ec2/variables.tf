
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

variable "public_subnet_ids" {
  description = "public ip for jenkins"
  type        = map(string)
}

variable "private_subnet_ids" {
  description = "private ip for Application Server"
  type        = map(string)
}

variable "asg_sg_id" {
  description = "Security-Group for Application Server"
  type        = string
}

variable "jenkins_sg_id" {
  description = "Security-Group for Jenkins Server"
  type        = string
}

variable "efs_id" {
  description = "efs_id"
  type        = string
}

variable "db_host" {
  type = string
}

variable "db_password" {
  type = string
}