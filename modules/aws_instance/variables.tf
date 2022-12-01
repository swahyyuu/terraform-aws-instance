variable "account_id" {
  description = "Current account ID"
  type        = string
}

variable "vpc_id" {
  description = "VPC Id from another folder"
  type        = string
}

variable "subnet_id" {
  description = "Subnet Id from another folder"
  type        = string
}

variable "any_port" {
  description = "Receive access from any ports"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ingress_ports" {
  type        = list(number)
  description = "list of ingress ports for security group of instance"
  default     = [22, 80]
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.medium"
}

variable "key_name" {
  type        = string
  description = "Name of Key Pair"
  default     = "terraform-test"
}

variable "bash_dir" {
  type        = string
  description = "Path directory of bash scripts"
  default     = "modules/bash_scripts"
}