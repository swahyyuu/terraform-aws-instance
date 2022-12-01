output "vpc_id" {
  description = "VPC Id which recently created"
  value       = aws_vpc.vpc.id
}

output "subnet_id" {
  description = "Subnet Id which recently created"
  value       = aws_subnet.subnet.id
}
