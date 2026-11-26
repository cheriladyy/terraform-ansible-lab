variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "instance_type" {
  description = "Monitoring EC2 instance type"
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "CIDR allowed to connect over SSH"
  type        = string
}

variable "public_key_path" {
  description = "Path to local SSH public key"
  type        = string
  default     = "~/.ssh/bgd.pub"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "agent_security_group_id" {
  description = "Security Group ID of the EC2 instances monitored by Zabbix"
  type        = string
}
