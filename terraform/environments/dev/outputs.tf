output "public_ip" {
  description = "Elastic IP of the web server"
  value       = module.compute.public_ip
}

output "web_private_ip" {
  description = "Private IP of the web server"
  value       = module.compute.private_ip
}

output "web_security_group_id" {
  description = "Security Group ID of the web server"
  value       = module.compute.security_group_id
}