terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.5.0"
    }
  }
  backend "s3" {
    bucket  = "devops-challenge-teamsoft-terraform-bucket"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    profile = "terraform"
  }
  required_version = "~> 1.1.9"
}

provider "github" {}