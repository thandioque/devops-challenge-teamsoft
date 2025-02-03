# Provider

variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

# Git Module

variable "git_full_repository_name" {
  type    = string
  default = "thandioque/devops-challenge-teamsoft"
}

variable "git_repository_name" {
  type    = string
  default = "devops-challenge-teamsoft"
}

variable "git_repository_description" {
  type    = string
  default = "This is a challenge by Coodesh"
}

variable "git_repository_visibility" {
  type    = string
  default = "public"
}

variable "is_delete_branch_on_merge" {
  type    = bool
  default = true
}

variable "git_branch_protection_name" {
  type    = string
  default = "main"
}

variable "git_branch_protection_require_approval" {
  type    = number
  default = 0
}

variable "aws_access_key_id" {
  type      = string
  sensitive = true
}

variable "aws_secret_access_key" {
  type      = string
  sensitive = true
}

variable "runner_github_token" {
  type      = string
  sensitive = true
}

variable "git_auth_token" {
  type      = string
  sensitive = true
}

variable "thandi_cidr_ipv4" {
  type      = string
  sensitive = true
}

# S3 Module

variable "s3_server_terraform_bucket_name" {
  type    = string
  default = "devops-challenge-teamsoft-terraform-bucket"
}

variable "s3_server_terraform_bucket_versioning" {
  type    = string
  default = "Enabled"
}

variable "s3_server_ssh_keys_bucket_name" {
  type    = string
  default = "devops-challenge-teamsoft-ssh-keys-bucket"
}

# VPC Module

variable "vpc_cidr_block" {
  type      = string
  sensitive = true
  # This vpc cidr block (/27) was chosen because AWS only allows you to create subnet cidr block up to (/28). So there are 28 addresses available in total, that is, 14 hosts available per subnet.
  default = "10.0.0.0/27"
}

variable "vpc_name" {
  type    = string
  default = "main-vpc"
}

variable "igw_name" {
  type    = string
  default = "main-internet-gateway"
}

variable "sg_name" {
  type    = string
  default = "main-security-group"
}

variable "sg_description" {
  type    = string
  default = "Setup main inbound and outbound rules"
}

variable "main_ssh_source_port" {
  type    = number
  default = 22
}

variable "main_ssh_ip_protocol" {
  type    = string
  default = "tcp"
}

variable "main_ssh_destintion_port" {
  type    = number
  default = 22
}

variable "main_thandi_ssh_rule_name" {
  type    = string
  default = "main-thandi-ssh-rule"
}

variable "main_thandi_prometheus_rule_name" {
  type    = string
  default = "main-thandi-prometheus-rule"
}

variable "main_thandi_node_exporter_rule_name" {
  type    = string
  default = "main-thandi-node-exporter-rule"
}

variable "main_http_cidr_ipv4" {
  type    = string
  default = "0.0.0.0/0"
}

variable "main_http_source_port" {
  type    = number
  default = 80
}

variable "main_http_ip_protocol" {
  type    = string
  default = "tcp"
}

variable "main_http_destintion_port" {
  type    = number
  default = 80
}

variable "main_http_rule_name" {
  type    = string
  default = "main-http-rule"
}

variable "main_prometheus_source_port" {
  type    = number
  default = 9090
}

variable "main_prometheus_ip_protocol" {
  type    = string
  default = "tcp"
}

variable "main_prometheus_destintion_port" {
  type    = number
  default = 9090
}

variable "main_prometheus_rule_name" {
  type    = string
  default = "main-prometheus-rule"
}

variable "main_node_exporter_source_port" {
  type    = number
  default = 9100
}

variable "main_node_exporter_ip_protocol" {
  type    = string
  default = "tcp"
}

variable "main_node_exporter_destintion_port" {
  type    = number
  default = 9100
}

variable "main_node_exporter_rule_name" {
  type    = string
  default = "main-node-exporter-rule"
}

variable "main_allow_all_traffic_cidr_ipv4" {
  type    = string
  default = "0.0.0.0/0"
}

variable "main_allow_all_traffic_ip_protocol" {
  type    = string
  default = "-1"
}

variable "main_allow_all_traffic_rule_name" {
  type    = string
  default = "main-allow-all-traffic-rule"
}

variable "public_subnet_cidr_block" {
  type      = string
  sensitive = true
  # Public available addresses from 10.0.0.1 to 10.0.0.14 (0 and 15 reserved for network and broadcast)
  default = "10.0.0.0/28"
}

variable "is_map_public_ip_on_launch" {
  type    = bool
  default = true
}

variable "public_subnet_name" {
  type    = string
  default = "main-public-subnet-a"
}

variable "public_availability_zone" {
  type    = string
  default = "us-east-1a"
}

variable "public_rt_name" {
  type    = string
  default = "main-public-route-table"
}

variable "public_igw_destination_cidr_block" {
  type    = string
  default = "0.0.0.0/0"
}

# EC2 Module

variable "is_associate_public_ip_address" {
  type    = bool
  default = true
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "user_data_path" {
  type    = string
  default = "./modules/ec2/install.sh"
}

variable "ec2_instance_name" {
  type    = string
  default = "server"
}

variable "is_most_recent" {
  type    = bool
  default = true
}

variable "ami_name_filter" {
  type    = string
  default = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

variable "ami_virtualization_type_filter" {
  type    = string
  default = "hvm"
}

variable "ami_architecture_filter" {
  type    = string
  default = "x86_64"
}

variable "ami_owner" {
  type    = string
  default = "099720109477"
}

variable "key_algorithm" {
  type    = string
  default = "RSA"
}

variable "key_rds_bits" {
  type    = number
  default = 4096
}

variable "key_name" {
  type    = string
  default = "server-key"
}

variable "s3_bucket_acl" {
  type    = string
  default = "private"
}

variable "s3_bucket_server_side_encryption" {
  type    = string
  default = "AES256"
}

variable "tags" {
  type    = map(string)
  default = {}
}