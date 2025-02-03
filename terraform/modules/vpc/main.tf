# This module creates a VPC with a public subnet, internet gateway, route and security group settings.

# VPC

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  tags       = merge({ Name = var.vpc_name }, var.tags)
}

# Internet Gateway

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = merge({ Name = var.igw_name }, var.tags)
}

# Security Groups

resource "aws_security_group" "main" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = aws_vpc.main.id
  tags        = merge({ Name = var.sg_name }, var.tags)
}

resource "aws_vpc_security_group_ingress_rule" "main_thandi_ssh_ingress_rule" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = var.main_thandi_cidr_ipv4
  from_port         = var.main_ssh_source_port
  ip_protocol       = var.main_ssh_ip_protocol
  to_port           = var.main_ssh_destintion_port
  tags              = merge({ Name = var.main_thandi_ssh_rule_name }, var.tags)
  description       = var.main_thandi_ssh_sg_descripion
}

resource "aws_vpc_security_group_ingress_rule" "main_thandi_prometheus_ingress_rule" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = var.main_thandi_cidr_ipv4
  from_port         = var.main_prometheus_source_port
  ip_protocol       = var.main_prometheus_ip_protocol
  to_port           = var.main_prometheus_destintion_port
  tags              = merge({ Name = var.main_thandi_prometheus_rule_name }, var.tags)
  description       = var.main_thandi_prometheus_sg_descripion
}

resource "aws_vpc_security_group_ingress_rule" "main_thandi_node_exporter_ingress_rule" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = var.main_thandi_cidr_ipv4
  from_port         = var.main_node_exporter_source_port
  ip_protocol       = var.main_node_exporter_ip_protocol
  to_port           = var.main_node_exporter_destintion_port
  tags              = merge({ Name = var.main_thandi_node_exporter_rule_name }, var.tags)
  description       = var.main_thandi_node_exporter_sg_descripion
}

resource "aws_vpc_security_group_ingress_rule" "main_http_ingress_rule" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = var.main_http_cidr_ipv4
  from_port         = var.main_http_source_port
  ip_protocol       = var.main_http_ip_protocol
  to_port           = var.main_http_destintion_port
  tags              = merge({ Name = var.main_http_rule_name }, var.tags)
  description       = var.main_http_cidr_http_sg_descripion
}

resource "aws_vpc_security_group_egress_rule" "main_allow_all_traffic_egress_rule" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = var.main_allow_all_traffic_cidr_ipv4
  ip_protocol       = var.main_allow_all_traffic_ip_protocol
  tags              = merge({ Name = var.main_allow_all_traffic_rule_name }, var.tags)
  description       = var.main_allow_all_traffic_sg_descripion
}

# Pubic Subnet

resource "aws_subnet" "main_public" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = var.public_availability_zone
  cidr_block              = var.public_subnet_cidr_block
  map_public_ip_on_launch = var.is_map_public_ip_on_launch
  tags                    = merge({ Name = var.public_subnet_name }, var.tags)
}

# Route table

resource "aws_route_table" "main_public" {
  vpc_id = aws_vpc.main.id
  tags   = merge({ Name = var.public_rt_name }, var.tags)
}

# Route
resource "aws_route" "main_public_internet_access" {
  # This route enables access to the Internet via the Internet Gateway
  route_table_id         = aws_route_table.main_public.id
  destination_cidr_block = var.public_igw_destination_cidr_block
  gateway_id             = aws_internet_gateway.main.id
}

# Route table association

resource "aws_route_table_association" "main_public" {
  subnet_id      = aws_subnet.main_public.id
  route_table_id = aws_route_table.main_public.id
}

