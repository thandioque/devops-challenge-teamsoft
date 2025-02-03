output "instance_id" {
  description = "Id of the EC2 instace "
  value       = aws_instance.server.id
}

output "public_instance_ip" {
  description = "IP of the EC2 instace "
  value       = aws_instance.server.public_ip
}