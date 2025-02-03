variable "is_associate_public_ip_address" {
  type = bool
}

variable "instance_type" {
  type = string
}

variable "security_group_id" {
  type = list(string)
}

variable "public_subnet_id" {
  type = string
}

variable "user_data_path" {
  type = string
}

variable "ec2_instance_name" {
  type = string
}

variable "ebs_volume_size" {
  type = number
}

variable "is_most_recent" {
  type = bool
}

variable "ami_name_filter" {
  type = string
}

variable "ami_virtualization_type_filter" {
  type = string
}

variable "ami_architecture_filter" {
  type = string
}

variable "ami_owner" {
  type = string
}

# Key pair

variable "key_algorithm" {
  type = string
}
variable "key_rds_bits" {
  type = number
}
variable "key_name" {
  type = string
}

variable "s3_object_bucket_name" {
  type = string
}

variable "s3_bucket_acl" {
  type = string
}

variable "s3_bucket_server_side_encryption" {
  type = string
}

variable "tags" {
  type = map(string)
}