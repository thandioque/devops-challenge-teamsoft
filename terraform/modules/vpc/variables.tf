variable "vpc_cidr_block" {
  type      = string
  sensitive = true
}

variable "vpc_name" {
  type = string
}

variable "igw_name" {
  type = string
}

variable "sg_name" {
  type = string
}

variable "sg_description" {
  type = string
}

variable "main_thandi_cidr_ipv4" {
  type = string
}

variable "main_ssh_source_port" {
  type = number
}

variable "main_ssh_ip_protocol" {
  type = string
}

variable "main_ssh_destintion_port" {
  type = number
}

variable "main_thandi_ssh_sg_descripion" {
  type = string
}

variable "main_thandi_ssh_rule_name" {
  type = string
}

variable "main_thandi_prometheus_rule_name" {
  type = string
}

variable "main_thandi_node_exporter_rule_name" {
  type = string
}

variable "main_http_cidr_ipv4" {
  type = string
}

variable "main_http_source_port" {
  type = number
}

variable "main_http_ip_protocol" {
  type = string
}

variable "main_http_destintion_port" {
  type = number
}

variable "main_http_cidr_http_sg_descripion" {
  type = string
}

variable "main_http_rule_name" {
  type = string
}

variable "main_prometheus_cidr_ipv4" {
  type = string
}

variable "main_prometheus_source_port" {
  type = number
}

variable "main_prometheus_ip_protocol" {
  type = string
}

variable "main_prometheus_destintion_port" {
  type = number
}

variable "main_thandi_prometheus_sg_descripion" {
  type = string
}

variable "main_prometheus_rule_name" {
  type = string
}

variable "main_node_exporter_cidr_ipv4" {
  type = string
}

variable "main_node_exporter_source_port" {
  type = number
}

variable "main_node_exporter_ip_protocol" {
  type = string
}

variable "main_node_exporter_destintion_port" {
  type = number
}

variable "main_thandi_node_exporter_sg_descripion" {
  type = string
}

variable "main_node_exporter_rule_name" {
  type = string
}

variable "main_allow_all_traffic_cidr_ipv4" {
  type = string
}

variable "main_allow_all_traffic_sg_descripion" {
  type = string
}

variable "main_allow_all_traffic_ip_protocol" {
  type = string
}

variable "main_allow_all_traffic_rule_name" {
  type = string
}

# Public

variable "public_availability_zone" {
  type = string
}

variable "public_subnet_cidr_block" {
  type      = string
  sensitive = true
}

variable "is_map_public_ip_on_launch" {
  type = bool
}

variable "public_subnet_name" {
  type = string
}

variable "public_rt_name" {
  type = string
}

variable "public_igw_destination_cidr_block" {
  type = string
}

variable "tags" {
  type = map(string)
}