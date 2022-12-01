output "vpc_id" {
  description = "value of VPC Id"
  value       = module.aws_terra_vpc.vpc_id
}

output "instance_id" {
  description = "Instance Id"
  value       = module.aws_terra_instance.instance_id
}

output "instance_public_id" {
  description = "Instance Public Id"
  value       = module.aws_terra_instance.instance_public_id
}

output "user_id" {
  description = "AWS User Account ID"
  value       = data.aws_caller_identity.current.user_id
}