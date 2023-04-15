module "ec2" {
  source = "../"

  server_name        = "bastion"
  security_group_ids = ["sg-05bd24bb429900190"]
  subnet_id          = "subnet-0ddcde2aa05c988f9"

  user_data_path = "files/init.sh"
  vars = {
    foo = "bar"
  }
}