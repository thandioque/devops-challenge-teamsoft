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

