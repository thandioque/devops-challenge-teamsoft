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