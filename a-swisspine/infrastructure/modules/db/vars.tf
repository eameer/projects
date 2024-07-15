variable "name" {
  description = "Postgres DB Name"
}

variable "application_name" {
  description = "name of the application"
  type = string
}

variable "dns_zone_name" {
  description = "DNS name of DB"
}

variable "resource_group_name" {
  description = "Resource Group Name"
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
}

variable "vnet_id" {
  description = "ID of the Virtual Network"
}

variable "db_subnet_id" {
  description = "Subnet ID of the DB Subnet"
}

variable "location" {
  default     = "southeastasia"
  description = "Location of the resource."
}

variable "db_username" {
  description = "PSQL DB USername"
  default = "platform11"
}

variable "storage_mb" {
  description = "DB storage in MB"
  default = 32768
  type = number
}

variable "sku_name" {
  description = "SKU Name of the DB Instance"
  type = string
  default = "B_Standard_B1ms"
}

variable "backup_retention_days" {
  description = "Number of days to keep backups"
  default = 7
}