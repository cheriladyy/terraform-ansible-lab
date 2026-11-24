variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "CIDR allowed to connect over SSH"
  type        = string
}

variable "public_key_path" {
  description = "Path to the local SSH public key"
  type        = string
  default     = "~/.ssh/bgd.pub"
}

variable "vpc_id" {
  description = "VPC"
  type        = string
}

variable "subnet_id" {
  description = "Subnet"
  type        = string
}
