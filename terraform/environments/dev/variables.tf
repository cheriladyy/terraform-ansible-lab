variable "project" {
  description = "Project name"
  type        = string
  default     = "app"
}

variable "owner" {
  description = "Owner of the project"
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

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "public_key_path" {
  description = "Path to the local SSH public key"
  type        = string
  default     = "~/.ssh/bgd.pub"
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)
  default     = []
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = []
}

variable "monitoring_instance_type" {
  description = "EC2 instance type for Zabbix monitoring server"
  type        = string
}