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
  name = "${var.server_name}_instance_profile"
  role = aws_iam_role.instance_role.name
}

data "template_file" "user_data" {
  template = file(var.user_data_path)

  vars = var.vars
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.3"

  name = var.server_name

  ami                    = data.aws_ami.ami.id
  instance_type          = var.instance_type
  monitoring             = var.monitoring
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.subnet_id
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  key_name               = "management-uptain-ds"
  user_data              = base64encode(data.template_file.user_data.rendered)


}

resource "aws_iam_role" "instance_role" {
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

  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}

#resource "aws_iam_policy_attachment" "ecs_instance_policy_attachment_ssm" {
#  name       = "${var.server_name}_ecs_policy_attachemnt_ssm"
#  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#  roles      = [aws_iam_role.instance_role.name]
#}

resource "aws_eip" "main" {
  instance = module.ec2_instance.id
  vpc      = true
}
