data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = [var.architecture]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  count = var.instance_profile != null ? 0 : 1

  name = "${var.server_name}_instance_profile"
  role = aws_iam_role.instance_role[0].name
}

data "template_file" "user_data" {
  template = file(var.user_data_path)

  vars = var.vars
}

module "ec2_instance" {
  count   = var.create_autoscaling_group ? 0 : 1
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.3"

  name = var.server_name

  private_ip = var.private_ip

  source_dest_check = var.source_dest_check

  ami                         = var.ami != null ? var.ami : data.aws_ami.ami.id
  instance_type               = var.instance_type
  monitoring                  = var.monitoring
  vpc_security_group_ids      = var.security_group_ids
  subnet_id                   = var.subnet_id
  iam_instance_profile        = var.instance_profile != null ? var.instance_profile : aws_iam_instance_profile.ec2_instance_profile[0].name
  user_data                   = base64encode(data.template_file.user_data.rendered)
  user_data_replace_on_change = var.user_data_replace_on_change
  root_block_device           = var.root_block_device
}

resource "aws_iam_role" "instance_role" {
  count = var.instance_profile != null ? 0 : 1

  name = "${var.server_name}_ecsInstanceRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  managed_policy_arns = concat([
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ], var.managed_policy_arns)
}

resource "aws_eip" "this" {
  count = var.create_eip ? 1 : 0

  instance                  = var.create_eip && var.create_autoscaling_group == false ? module.ec2_instance[0].id : null
  associate_with_private_ip = var.create_eip && var.create_autoscaling_group == false ? module.ec2_instance[0].private_ip : var.private_ip

  tags = {
    Server_name = var.server_name
  }
}


resource "aws_launch_template" "as_template" {
  count = var.create_autoscaling_group ? 1 : 0

  name_prefix   = var.server_name
  image_id      = var.ami != null ? var.ami : data.aws_ami.ami.id
  instance_type = var.instance_type
  user_data     = base64encode(data.template_file.user_data.rendered)

  iam_instance_profile {
    name = var.instance_profile != null ? var.instance_profile : aws_iam_instance_profile.ec2_instance_profile[0].name
  }

  vpc_security_group_ids = var.security_group_ids

  dynamic "block_device_mappings" {
    for_each = var.root_block_device
    content {
      device_name = "/dev/xvda"

      ebs {
        delete_on_termination = try(block_device_mappings.value.delete_on_termination, null)
        encrypted             = try(block_device_mappings.value.encrypted, null)
        iops                  = try(block_device_mappings.value.iops, null)
        throughput            = try(block_device_mappings.value.throughput, null)
        volume_size           = try(block_device_mappings.value.volume_size, null)
        volume_type           = try(block_device_mappings.value.volume_type, null)
      }
    }
  }

  network_interfaces {
    private_ip_address = var.private_ip
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  count = var.create_autoscaling_group ? 1 : 0

  name = "${var.server_name}-asg"
  launch_template {
    id      = aws_launch_template.as_template[0].id
    version = "$Latest"
  }

  min_size            = var.min_size
  max_size            = var.max_size
  vpc_zone_identifier = [var.subnet_id]


  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = var.server_name
  }

}
