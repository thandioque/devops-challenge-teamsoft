variable "s3_server_terraform_bucket_name" {
  type = string
}

variable "s3_server_terraform_bucket_versioning" {
  type = string
}

variable "s3_server_ssh_keys_bucket_name" {
  type = string
}

variable "tags" {
  type = map(string)
}