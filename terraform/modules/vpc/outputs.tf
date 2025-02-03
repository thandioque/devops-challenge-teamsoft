output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.main_public.id
}

output "security_group_id" {
  description = "Id of the security group"
  value       = [aws_security_group.main.id]
}
