output "eip_ip" {
  value       = aws_eip.this[0].public_ip
  description = "public ip of instance"
}