# Terraform aws EC2 instance + ssm role + instance profile + custom user data + elastic ip creation

Useful for fast creation of instance with ssm access

### Example usage
```hcl
module "ec2" {
  source  = "zahornyak/ec2/aws"

  server_name        = "bastion"
  security_group_ids = ["sg-05bd24bb429900190"]
  subnet_id          = "subnet-0ddcde2aa05c988f9"

  user_data_path = "files/init.sh"
  vars = {
    foo = "bar"
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0, < 6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2_instance"></a> [ec2\_instance](#module\_ec2\_instance) | terraform-aws-modules/ec2-instance/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_policy.scale_down](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_autoscaling_policy.scale_up](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_cloudwatch_metric_alarm.cpu_high](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cpu_low](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.ec2_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.instance_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_launch_template.as_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_ami.ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami"></a> [ami](#input\_ami) | custom ami id | `string` | `null` | no |
| <a name="input_architecture"></a> [architecture](#input\_architecture) | architecture | `string` | `"x86_64"` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | associate public ip address | `bool` | `true` | no |
| <a name="input_create_autoscaling_group"></a> [create\_autoscaling\_group](#input\_create\_autoscaling\_group) | if create autoscaling group | `bool` | `false` | no |
| <a name="input_create_eip"></a> [create\_eip](#input\_create\_eip) | creates eip | `bool` | `true` | no |
| <a name="input_instance_profile"></a> [instance\_profile](#input\_instance\_profile) | custom instance profile | `string` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | instance type | `string` | `"t2.micro"` | no |
| <a name="input_managed_policy_arns"></a> [managed\_policy\_arns](#input\_managed\_policy\_arns) | additional managed policy arns | `list(string)` | `[]` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | max\_size asg | `number` | `1` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | min\_size asg | `number` | `1` | no |
| <a name="input_monitoring"></a> [monitoring](#input\_monitoring) | enable monitoring | `bool` | `true` | no |
| <a name="input_private_ip"></a> [private\_ip](#input\_private\_ip) | private ip | `string` | `null` | no |
| <a name="input_root_block_device"></a> [root\_block\_device](#input\_root\_block\_device) | volume config | `any` | `[]` | no |
| <a name="input_scale_down_config"></a> [scale\_down\_config](#input\_scale\_down\_config) | scale down config | `any` | `{}` | no |
| <a name="input_scale_up_config"></a> [scale\_up\_config](#input\_scale\_up\_config) | scale up config | `any` | `{}` | no |
| <a name="input_scaling_default_cooldown"></a> [scaling\_default\_cooldown](#input\_scaling\_default\_cooldown) | default cooldown | `number` | `300` | no |
| <a name="input_scaling_termination_policies"></a> [scaling\_termination\_policies](#input\_scaling\_termination\_policies) | termination policies | `list(string)` | <pre>[<br>  "OldestInstance"<br>]</pre> | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | security\_group\_ids | `list(string)` | `null` | no |
| <a name="input_server_name"></a> [server\_name](#input\_server\_name) | server\_name | `string` | `null` | no |
| <a name="input_source_dest_check"></a> [source\_dest\_check](#input\_source\_dest\_check) | source\_dest\_check | `bool` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | subnet\_id | `string` | `null` | no |
| <a name="input_user_data_path"></a> [user\_data\_path](#input\_user\_data\_path) | user\_data\_path | `string` | `null` | no |
| <a name="input_user_data_replace_on_change"></a> [user\_data\_replace\_on\_change](#input\_user\_data\_replace\_on\_change) | recreate on user data change | `bool` | `true` | no |
| <a name="input_vars"></a> [vars](#input\_vars) | variable for user\_data | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ami_id"></a> [ami\_id](#output\_ami\_id) | ami id |
| <a name="output_ec2_instance_profile"></a> [ec2\_instance\_profile](#output\_ec2\_instance\_profile) | ec2\_instance\_profile |
| <a name="output_eip_ip"></a> [eip\_ip](#output\_eip\_ip) | public ip of instance |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | instance id |
| <a name="output_instance_role"></a> [instance\_role](#output\_instance\_role) | ec2\_instance\_profile |
| <a name="output_private_dns_name"></a> [private\_dns\_name](#output\_private\_dns\_name) | private dns name |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | private ip of instance |
| <a name="output_public_dns_name"></a> [public\_dns\_name](#output\_public\_dns\_name) | public dns name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
