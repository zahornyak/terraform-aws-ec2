output "eip_ip" {
  value       = aws_eip.this[0].public_ip
  description = "public ip of instance"
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