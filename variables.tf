variable "instance_type" {
  default     = "t2.micro"
  description = "instance type"
  type        = string
}

variable "monitoring" {
  default     = true
  description = "enable monitoring"
  type        = bool
}

variable "security_group_ids" {
  default     = null
  description = "security_group_ids"
  type        = list(string)
}

variable "subnet_id" {
  default     = null
  description = "subnet_id"
  type        = string
}

variable "user_data_path" {
  default     = null
  description = "user_data_path"
  type        = string
}

variable "server_name" {
  default     = null
  description = "server_name"
  type        = string
}

variable "vars" {
  default     = {}
  description = "variable for user_data"
  type        = map(string)
}

variable "managed_policy_arns" {
  default     = []
  description = "additional managed policy arns"
  type        = list(string)
}

variable "create_eip" {
  default     = true
  description = "creates eip"
  type        = bool
}

variable "ami" {
  default     = null
  description = "custom ami id"
  type        = string
}

variable "instance_profile" {
  default     = null
  description = "custom instance profile"
  type        = string
}

variable "user_data_replace_on_change" {
  default     = true
  description = "recreate on user data change"
  type        = bool
}

variable "root_block_device" {
  description = "volume config"
  type        = any
  default     = []
}

variable "create_autoscaling_group" {
  description = "if create autoscaling group"
  type        = bool
  default     = false
}

variable "min_size" {
  description = "min_size asg"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "max_size asg"
  type        = number
  default     = 1
}

variable "private_ip" {
  description = "private ip"
  type        = string
  default     = null
}

variable "architecture" {
  description = "architecture"
  type        = string
  default     = "x86_64"
}


