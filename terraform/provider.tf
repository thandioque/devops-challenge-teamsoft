terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.5.0"
    }
  }
  backend "s3" {}
  required_version = "~> 1.1.9"
}

provider "github" {}