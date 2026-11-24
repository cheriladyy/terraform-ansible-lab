output "public_ip" {
  description = "Elastic IP of the web server"
  value       = module.compute.public_ip
}
