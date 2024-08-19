output "eip_ip" {
  value       = try(aws_eip.this[0].public_ip, null)
  description = "public ip of instance"
}

output "private_ip" {
  value       = try(module.ec2_instance[0].private_ip, null)
  description = "private ip of instance"
}

output "ami_id" {
  value       = data.aws_ami.ami.id
  description = "ami id"
}

output "instance_role" {
  value       = var.instance_profile == null ? aws_iam_role.instance_role[0].name : null
  description = "ec2_instance_profile"
}

output "ec2_instance_profile" {
  value       = var.instance_profile == null ? aws_iam_instance_profile.ec2_instance_profile[0].name : null
  description = "ec2_instance_profile"
}

output "instance_id" {
  value       = try(module.ec2_instance[0].id, null)
  description = "instance id"
}

output "private_dns_name" {
  value       = try(module.ec2_instance.private_dns, null)
  description = "private dns name"
}

output "public_dns_name" {
  value       = try(module.ec2_instance.public_dns, null)
  description = "public dns name"
}