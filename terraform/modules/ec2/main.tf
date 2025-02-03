# Key pair

resource "tls_private_key" "main" {
  algorithm = var.key_algorithm
  rsa_bits  = var.key_rds_bits
}

resource "aws_key_pair" "main" {
  key_name   = var.key_name
  public_key = tls_private_key.main.public_key_openssh
  tags       = merge({ Name = var.key_name }, var.tags)
}

resource "aws_s3_object" "ssh_private_key" {
  bucket                 = var.s3_object_bucket_name
  key                    = "ssh-keys/${var.key_name}.pem"
  content                = tls_private_key.main.private_key_pem
  acl                    = var.s3_bucket_acl
  server_side_encryption = var.s3_bucket_server_side_encryption
}

# EC2

resource "aws_instance" "server" {
  ami                         = data.aws_ami.server.id
  associate_public_ip_address = var.is_associate_public_ip_address
  key_name                    = aws_key_pair.main.key_name
  instance_type               = var.instance_type
  vpc_security_group_ids      = var.security_group_id
  subnet_id                   = var.public_subnet_id
  user_data                   = file(var.user_data_path)
  tags                        = merge({ Name = var.ec2_instance_name }, var.tags)

  ebs_block_device {
    device_name = var.ebs_device_name
    volume_size = var.ebs_volume_size
    tags        = merge({ Name = var.ec2_instance_name }, var.tags)
  }
}

data "aws_ami" "server" {
  most_recent = var.is_most_recent

  filter {
    name   = "name"
    values = [var.ami_name_filter]
  }

  filter {
    name   = "virtualization-type"
    values = [var.ami_virtualization_type_filter]
  }

  filter {
    name   = "architecture"
    values = [var.ami_architecture_filter]
  }

  owners = [var.ami_owner]
}
