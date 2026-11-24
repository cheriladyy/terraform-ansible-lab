output "public_ip" {
  description = "Elastic IP of the web server"
  value       = aws_eip.web.public_ip
}