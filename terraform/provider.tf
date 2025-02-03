terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.5.0"
    }
  }
  backend "s3" {}
  required_version = "~> 1.1.9"
}

provider "aws" {
  region = var.aws_region
}

provider "github" {}