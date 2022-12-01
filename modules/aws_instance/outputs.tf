output "instance_id" {
  description = "Instance Id"
  value       = aws_instance.pub_instance.id
}

output "instance_public_id" {
  description = "Instance Public Id"
  value       = aws_instance.pub_instance.public_ip
}
