# Provider

variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

# Git Module

variable "git_full_repository_name" {
  description = "The full name of the Git repository (e.g., owner/repository)"
  type        = string
  default     = "thandioque/devops-challenge-teamsoft"
}

variable "git_repository_name" {
  description = "The name of the Git repository"
  type        = string
  default     = "devops-challenge-teamsoft"
}

variable "git_repository_description" {
  description = "The description of the Git repository"
  type        = string
  default     = "This is a challenge by Coodesh"
}

variable "git_repository_visibility" {
  description = "The visibility of the Git repository (e.g., public or private)"
  type        = string
  default     = "public"
}

variable "is_delete_branch_on_merge" {
  description = "Whether to delete the branch after it is merged"
  type        = bool
  default     = true
}

variable "git_branch_protection_name" {
  description = "The name of the protected branch"
  type        = string
  default     = "main"
}

variable "git_branch_protection_require_approval" {
  description = "The number of required approvals for pull requests to be merged"
  type        = number
  default     = 0
}

variable "aws_access_key_id" {
  description = "The AWS access key ID"
  type        = string
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "The AWS secret access key"
  type        = string
  sensitive   = true
}

variable "runner_github_token" {
  description = "GitHub token for the runner"
  type        = string
  sensitive   = true
}

variable "git_auth_token" {
  description = "Authentication token for Git operations"
  type        = string
  sensitive   = true
}

variable "thandi_cidr_ipv4" {
  description = "The CIDR block for Thandi network"
  type        = string
  sensitive   = true
}

# S3 Module

variable "s3_server_terraform_bucket_name" {
  description = "The name of the S3 bucket used for Terraform storage"
  type        = string
  default     = "devops-challenge-teamsoft-terraform-bucket"
}

variable "s3_server_terraform_bucket_versioning" {
  description = "The versioning status of the S3 Terraform bucket"
  type        = string
  default     = "Enabled"
}

variable "s3_server_ssh_keys_bucket_name" {
  description = "The name of the S3 bucket used for storing SSH keys"
  type        = string
  default     = "devops-challenge-teamsoft-ssh-keys-bucket"
}

# VPC Module

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  sensitive   = true
  default     = "10.0.0.0/27"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "main-vpc"
}

variable "igw_name" {
  description = "The name of the Internet Gateway"
  type        = string
  default     = "main-internet-gateway"
}

variable "sg_name" {
  description = "The name of the security group"
  type        = string
  default     = "main-security-group"
}

variable "sg_description" {
  description = "The description of the security group"
  type        = string
  default     = "Setup main inbound and outbound rules"
}

variable "main_ssh_source_port" {
  description = "The source port for SSH traffic"
  type        = number
  default     = 22
}

variable "main_ssh_ip_protocol" {
  description = "The IP protocol for SSH traffic"
  type        = string
  default     = "tcp"
}

variable "main_ssh_destintion_port" {
  description = "The destination port for SSH traffic"
  type        = number
  default     = 22
}

variable "main_thandi_ssh_sg_descripion" {
  description = "The description of the Thandi security grup to SSH"
  type        = string
  default     = "SSH ingress rule for Thandi, allowing SSH traffic from the specified CIDR block."
}

variable "main_thandi_ssh_rule_name" {
  description = "The name of the Thandi SSH rule"
  type        = string
  default     = "main-thandi-ssh-rule"
}

variable "main_thandi_prometheus_rule_name" {
  description = "The name of the Thandi Prometheus rule"
  type        = string
  default     = "main-thandi-prometheus-rule"
}

variable "main_thandi_node_exporter_rule_name" {
  description = "The name of the Thandi Node Exporter rule"
  type        = string
  default     = "main-thandi-node-exporter-rule"
}

variable "main_http_cidr_ipv4" {
  description = "The CIDR block for HTTP traffic"
  type        = string
  default     = "0.0.0.0/0"
}

variable "main_http_source_port" {
  description = "The source port for HTTP traffic"
  type        = number
  default     = 80
}

variable "main_http_ip_protocol" {
  description = "The IP protocol for HTTP traffic"
  type        = string
  default     = "tcp"
}

variable "main_http_destintion_port" {
  description = "The destination port for HTTP traffic"
  type        = number
  default     = 80
}

variable "main_http_cidr_http_sg_descripion" {
  description = "The description of the security grup to acess the HTTP"
  type        = string
  default     = "HTTP ingress rule, allowing HTTP traffic from the specified CIDR block."
}

variable "main_http_rule_name" {
  description = "The name of the HTTP rule"
  type        = string
  default     = "main-http-rule"
}

variable "main_prometheus_source_port" {
  description = "The source port for Prometheus traffic"
  type        = number
  default     = 9090
}

variable "main_prometheus_ip_protocol" {
  description = "The IP protocol for Prometheus traffic"
  type        = string
  default     = "tcp"
}

variable "main_prometheus_destintion_port" {
  description = "The destination port for Prometheus traffic"
  type        = number
  default     = 9090
}

variable "main_thandi_prometheus_sg_descripion" {
  description = "The description of the Thandi security grup to acess the Prometheus"
  type        = string
  default     = "Ingress rule for Prometheus, allowing Prometheus traffic from the specified CIDR block."
}

variable "main_prometheus_rule_name" {
  description = "The name of the Prometheus rule"
  type        = string
  default     = "main-prometheus-rule"
}

variable "main_node_exporter_source_port" {
  description = "The source port for Node Exporter traffic"
  type        = number
  default     = 9100
}

variable "main_node_exporter_ip_protocol" {
  description = "The IP protocol for Node Exporter traffic"
  type        = string
  default     = "tcp"
}

variable "main_node_exporter_destintion_port" {
  description = "The destination port for Node Exporter traffic"
  type        = number
  default     = 9100
}

variable "main_thandi_node_exporter_sg_descripion" {
  description = "The description of the Thandi security grup to acess the Node Exporter"
  type        = string
  default     = "Ingress rule for Node Exporter, allowing Node Exporter traffic from the specified CIDR block."
}

variable "main_node_exporter_rule_name" {
  description = "The name of the Node Exporter rule"
  type        = string
  default     = "main-node-exporter-rule"
}

variable "main_allow_all_traffic_cidr_ipv4" {
  description = "The CIDR block for allowing all traffic"
  type        = string
  default     = "0.0.0.0/0"
}

variable "main_allow_all_traffic_ip_protocol" {
  description = "The IP protocol for allowing all traffic"
  type        = string
  default     = "-1"
}

variable "main_allow_all_traffic_sg_descripion" {
  description = "The description of the security grup to outbound traffic"
  type        = string
  default     = "Egress rule allowing all outbound traffic from the security group."
}

variable "main_allow_all_traffic_rule_name" {
  description = "The name of the rule allowing all traffic"
  type        = string
  default     = "main-allow-all-traffic-rule"
}

variable "public_subnet_cidr_block" {
  description = "The CIDR block for the public subnet"
  type        = string
  sensitive   = true
  default     = "10.0.0.0/28"
}

variable "is_map_public_ip_on_launch" {
  description = "Whether to map public IP on launch for instances"
  type        = bool
  default     = true
}

variable "public_subnet_name" {
  description = "The name of the public subnet"
  type        = string
  default     = "main-public-subnet-a"
}

variable "public_availability_zone" {
  description = "The availability zone for the public subnet"
  type        = string
  default     = "us-east-1a"
}

variable "public_rt_name" {
  description = "The name of the public route table"
  type        = string
  default     = "main-public-route-table"
}

variable "public_igw_destination_cidr_block" {
  description = "The CIDR block for the destination in the public Internet Gateway"
  type        = string
  default     = "0.0.0.0/0"
}

# EC2 Module

variable "is_associate_public_ip_address" {
  description = "Whether to associate a public IP address with EC2 instances"
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "user_data_path" {
  description = "The path to the user data script for EC2 instances"
  type        = string
  default     = "./modules/ec2/install.sh"
}

variable "ec2_instance_name" {
  description = "The name of the EC2 instance"
  type        = string
  default     = "server"
}

variable "ebs_device_name" {
  description = "The name of the EBS device"
  type        = string
  default     = "/dev/sda1"
}

variable "ebs_is_encrypted" {
  description = "Whether to encrypt the EBS volume"
  type        = bool
  default     = true
}

variable "ebs_volume_size" {
  description = "The size of the EBS volume in GiB"
  type        = number
  default     = 30
}

variable "is_most_recent" {
  description = "Whether to use the most recent AMI"
  type        = bool
  default     = true
}

variable "ami_name_filter" {
  description = "The name filter for the AMI"
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

variable "ami_virtualization_type_filter" {
  description = "The virtualization type filter for the AMI"
  type        = string
  default     = "hvm"
}

variable "ami_architecture_filter" {
  description = "The architecture filter for the AMI"
  type        = string
  default     = "x86_64"
}

variable "ami_owner" {
  description = "The owner of the AMI"
  type        = string
  default     = "099720109477"
}

variable "key_algorithm" {
  description = "The algorithm used for generating SSH keys"
  type        = string
  default     = "RSA"
}

variable "key_rds_bits" {
  description = "The number of bits used for the SSH key (RDS)"
  type        = number
  default     = 4096
}

variable "key_name" {
  description = "The name of the SSH key"
  type        = string
  default     = "server-key"
}

variable "s3_bucket_acl" {
  description = "The ACL for the S3 bucket"
  type        = string
  default     = "private"
}

variable "s3_bucket_server_side_encryption" {
  description = "The server-side encryption for the S3 bucket"
  type        = string
  default     = "AES256"
}

variable "tags" {
  description = "The tags to apply to the resources"
  type        = map(string)
  default     = {}
}