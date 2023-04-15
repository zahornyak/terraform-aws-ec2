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
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  count = var.instance_role != null ? 0 : 1

  name = "${var.server_name}_instance_profile"
  role = aws_iam_role.instance_role[0].name
}

data "template_file" "user_data" {
  template = file(var.user_data_path)

  vars = var.vars
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.3"

  name = var.server_name

  ami                         = var.ami != null ? var.ami : data.aws_ami.ami.id
  instance_type               = var.instance_type
  monitoring                  = var.monitoring
  vpc_security_group_ids      = var.security_group_ids
  subnet_id                   = var.subnet_id
  iam_instance_profile        = var.instance_role != null ? var.instance_role : aws_iam_instance_profile.ec2_instance_profile[0].name
  user_data                   = base64encode(data.template_file.user_data.rendered)
  user_data_replace_on_change = var.user_data_replace_on_change
}

resource "aws_iam_role" "instance_role" {
  count = var.instance_role != null ? 0 : 1

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


#resource "aws_iam_policy_attachment" "ecs_instance_policy_attachment_ssm" {
#  name       = "${var.server_name}_ecs_policy_attachemnt_ssm"
#  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#  roles      = [aws_iam_role.instance_role.name]
#}

resource "aws_eip" "this" {
  count    = var.create_eip ? 1 : 0
  instance = module.ec2_instance.id
  vpc      = true
}
