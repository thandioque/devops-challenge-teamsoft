output "public_instance_ip" {
  description = "IP of the EC2 instace "
  value       = module.ec2.public_instance_ip
}