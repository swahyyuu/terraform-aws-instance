variable "cidr_vpc" {
  type        = string
  description = "CIDR Block of VPC"
  default     = "10.50.0.0/16"
}

variable "cidr_subnet" {
  type        = string
  description = "CIDR Block of Subnet"
  default     = "10.50.10.0/24"
}

variable "az_subnet" {
  type        = string
  description = "Availability Zone for Subnet"
  default     = "ap-southeast-1c"
}
