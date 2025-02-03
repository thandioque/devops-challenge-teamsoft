data "github_repository" "devops_challenge" {
  full_name = var.git_full_repository_name
}

resource "github_repository" "devops_challenge" {
  name        = var.git_repository_name
  description = var.git_repository_description

  visibility             = var.git_repository_visibility
  delete_branch_on_merge = var.is_delete_branch_on_merge
}

resource "github_branch_protection" "devops_challenge" {
  repository_id = data.github_repository.devops_challenge.name
  pattern       = var.git_branch_protection_name

  required_pull_request_reviews {
    required_approving_review_count = 0
  }
}

data "github_actions_public_key" "devops_challenge" {
  repository = data.github_repository.devops_challenge.name
}

resource "github_actions_secret" "devops_challenge_aws_access_key_id" {
  repository      = data.github_actions_public_key.devops_challenge.repository
  secret_name     = "AWS_ACCESS_KEY_ID"
  plaintext_value = var.aws_access_key_id
}

resource "github_actions_secret" "devops_challenge_aws_secret_access_key" {
  repository      = data.github_actions_public_key.devops_challenge.repository
  secret_name     = "AWS_SECRET_ACCESS_KEY"
  plaintext_value = var.aws_secret_access_key
}

resource "github_actions_secret" "devops_challenge_runner_github_token" {
  repository      = data.github_actions_public_key.devops_challenge.repository
  secret_name     = "RUNNER_GITHUB_TOKEN"
  plaintext_value = var.runner_github_token
}

resource "github_actions_secret" "devops_challenge_git_auth_token" {
  repository      = data.github_actions_public_key.devops_challenge.repository
  secret_name     = "GIT_AUTH_TOKEN"
  plaintext_value = var.git_auth_token
}

resource "github_actions_secret" "devops_challenge_thandi_cidr_ipv4" {
  repository      = data.github_actions_public_key.devops_challenge.repository
  secret_name     = "THANDI_CIDR_IPV4"
  plaintext_value = var.thandi_cidr_ipv4
}