variable "git_full_repository_name" {
  type = string
}

variable "git_repository_name" {
  type = string
}

variable "git_repository_description" {
  type = string
}

variable "git_repository_visibility" {
  type = string
}

variable "is_delete_branch_on_merge" {
  type = bool
}

variable "git_branch_protection_name" {
  type = string
}

variable "git_branch_protection_require_approval" {
  type = string
}

variable "aws_access_key_id" {
  type = string
}

variable "aws_secret_access_key" {
  type = string
}

variable "runner_github_token" {
  type = string
}

variable "git_auth_token" {
  type = string
}

variable "thandi_cidr_ipv4" {
  type = string
}