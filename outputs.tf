output "eip_ip" {
  value       = aws_eip.main.public_ip
  description = "public ip of instance"
}