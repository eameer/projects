variable "cluster_name" {
  type = string
}

variable "location" {
  type = string
  default = "southeastasia"
}

variable "agent_count" {
  type = string
}

variable "time_zone" {
  type = string
  default = "Asia/Manila"
}

variable "kubernetes_version" {
  type = string
}

variable "kubernetes_vm_size" {
  type = string
  default = "Standard_D2s_v3"
}

variable "resource_group_name" {
  type = string
}

variable "dns_prefix" {
  type = string
}

variable "os_disk_size_gb" {
  type = string
  default = "100GB"
}

variable "dns_service_ip" {
  type = string
}

variable "service_cidr" {
  type = string
}

variable "vnet_subnet_a_id" {
  type = string
}

variable "outbound_ip_address_ids" {
  type = list
  default = []
}


variable "outbound_type" {
  type = string
  default = "loadBalancer"
}

variable "enable_auto_scaling" {
  type = bool
  default = "false"
}

variable "scale_max_count" {
  type = string
}

variable "scale_min_count" {
  type = string
}

variable "node_count" {
  type = string
}