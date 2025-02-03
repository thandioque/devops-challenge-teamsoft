resource "aws_s3_bucket" "server_terraform_bucket" {
  bucket = var.s3_server_terraform_bucket_name

  tags = var.tags
}

resource "aws_s3_bucket_versioning" "server_terraform_bucket" {
  bucket = aws_s3_bucket.server_terraform_bucket.id
  versioning_configuration {
    status = var.s3_server_terraform_bucket_versioning
  }
}

resource "aws_s3_bucket" "server_ssh_keys_bucket" {
  bucket = var.s3_server_ssh_keys_bucket_name

  tags = var.tags
}