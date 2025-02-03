# Define common tags for all resources
locals {
  common_tags = {
    Project   = "Server"
    Managedby = "Terraform"
    Owner     = "Thandi"
  }
}