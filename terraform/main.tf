# Root modules: Calls S3, Git, VPC and EC2 modules

module "s3" {
  source                                = "./modules/s3"
  s3_server_terraform_bucket_name       = var.s3_server_terraform_bucket_name
  s3_server_terraform_bucket_versioning = var.s3_server_terraform_bucket_versioning
  s3_server_ssh_keys_bucket_name        = var.s3_server_ssh_keys_bucket_name
  tags                                  = var.tags
}

module "git" {
  source                                 = "./modules/git"
  git_full_repository_name               = var.git_full_repository_name
  git_repository_name                    = var.git_repository_name
  git_repository_description             = var.git_repository_description
  git_repository_visibility              = var.git_repository_visibility
  is_delete_branch_on_merge              = var.is_delete_branch_on_merge
  git_branch_protection_name             = var.git_branch_protection_name
  git_branch_protection_require_approval = var.git_branch_protection_require_approval
  aws_access_key_id                      = var.aws_access_key_id
  aws_secret_access_key                  = var.aws_secret_access_key
  runner_github_token                    = var.runner_github_token
  git_auth_token                         = var.git_auth_token
  thandi_cidr_ipv4                       = var.thandi_cidr_ipv4
}

module "vpc" {
  source                              = "./modules/vpc"
  vpc_cidr_block                      = var.vpc_cidr_block
  vpc_name                            = var.vpc_name
  igw_name                            = var.igw_name
  sg_name                             = var.sg_name
  sg_description                      = var.sg_description
  main_thandi_cidr_ipv4               = var.thandi_cidr_ipv4
  main_ssh_source_port                = var.main_ssh_source_port
  main_ssh_ip_protocol                = var.main_ssh_ip_protocol
  main_ssh_destintion_port            = var.main_ssh_destintion_port
  main_thandi_ssh_rule_name           = var.main_thandi_ssh_rule_name
  main_thandi_prometheus_rule_name    = var.main_thandi_ssh_rule_name
  main_thandi_node_exporter_rule_name = var.main_thandi_ssh_rule_name
  main_http_cidr_ipv4                 = var.main_http_cidr_ipv4
  main_http_source_port               = var.main_http_source_port
  main_http_ip_protocol               = var.main_http_ip_protocol
  main_http_destintion_port           = var.main_http_destintion_port
  main_http_rule_name                 = var.main_http_rule_name
  main_prometheus_cidr_ipv4           = "${module.ec2.public_instance_ip}/32"
  main_prometheus_source_port         = var.main_prometheus_source_port
  main_prometheus_ip_protocol         = var.main_prometheus_ip_protocol
  main_prometheus_destintion_port     = var.main_prometheus_destintion_port
  main_prometheus_rule_name           = var.main_prometheus_rule_name
  main_node_exporter_cidr_ipv4        = "${module.ec2.public_instance_ip}/32"
  main_node_exporter_source_port      = var.main_node_exporter_source_port
  main_node_exporter_ip_protocol      = var.main_node_exporter_ip_protocol
  main_node_exporter_destintion_port  = var.main_node_exporter_destintion_port
  main_node_exporter_rule_name        = var.main_node_exporter_rule_name
  main_allow_all_traffic_cidr_ipv4    = var.main_allow_all_traffic_cidr_ipv4
  main_allow_all_traffic_ip_protocol  = var.main_allow_all_traffic_ip_protocol
  main_allow_all_traffic_rule_name    = var.main_allow_all_traffic_rule_name
  public_availability_zone            = var.public_availability_zone
  public_subnet_cidr_block            = var.public_subnet_cidr_block
  is_map_public_ip_on_launch          = var.is_map_public_ip_on_launch
  public_subnet_name                  = var.public_subnet_name
  public_rt_name                      = var.public_rt_name
  public_igw_destination_cidr_block   = var.public_igw_destination_cidr_block
  tags                                = local.common_tags
}

module "ec2" {
  source                           = "./modules/ec2"
  is_associate_public_ip_address   = var.is_associate_public_ip_address
  instance_type                    = var.instance_type
  security_group_id                = module.vpc.security_group_id
  public_subnet_id                 = module.vpc.public_subnet_id
  user_data_path                   = var.user_data_path
  ec2_instance_name                = var.ec2_instance_name
  ebs_device_name                  = var.ebs_device_name
  ebs_is_encrypted                 = var.ebs_is_encrypted
  ebs_volume_size                  = var.ebs_volume_size
  is_most_recent                   = var.is_most_recent
  ami_name_filter                  = var.ami_name_filter
  ami_virtualization_type_filter   = var.ami_virtualization_type_filter
  ami_architecture_filter          = var.ami_architecture_filter
  ami_owner                        = var.ami_owner
  tags                             = local.common_tags
  key_algorithm                    = var.key_algorithm
  key_rds_bits                     = var.key_rds_bits
  key_name                         = var.key_name
  s3_object_bucket_name            = module.s3.s3_bucket_server_ssh_keys
  s3_bucket_acl                    = var.s3_bucket_acl
  s3_bucket_server_side_encryption = var.s3_bucket_server_side_encryption
}