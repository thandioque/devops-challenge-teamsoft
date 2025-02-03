output "s3_bucket_server_ssh_keys" {
  description = "S3 bucket of the server project "
  value       = aws_s3_bucket.server_ssh_keys_bucket.id
}
