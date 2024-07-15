variable "aks_subnet_name" {
  description = "name to give the subnet"
  type = string
}

variable "db_subnet_name" {
  description = "name to give the subnet"
  type = string
}

variable "resource_group_name" {
  description = "resource group that the vnet resides in"
  type = string
}

variable "vnet_name" {
  description = "name of the vnet that this subnet will belong to"
  type = string
}

variable "aks_subnet_a_cidr" {
  type = list
  description = "the aks subnet a cidr range"
}

variable "aks_subnet_b_cidr" {
  type = list
  description = "the aks subnet a cidr range"
}

variable "db_subnet_cidr" {
  type = list
  description = "the db subnet cidr range"
}

variable "location" {
  description = "the cluster location"
  type = string
}

variable "address_space" {
  description = "Network address space"
  type = string
}

variable "service_endpoints" {
  type = list
  default = []
}