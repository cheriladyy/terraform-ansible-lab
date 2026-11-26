output "public_ip" {
  description = "Elastic IP of the web server"
  value       = aws_eip.web.public_ip
}

output "private_ip" {
  description = "Private IP of the web server"
  value       = aws_instance.web.private_ip
}

output "security_group_id" {
  description = "Security Group ID of the web server"
  value       = aws_security_group.BGD_security_group.id
}