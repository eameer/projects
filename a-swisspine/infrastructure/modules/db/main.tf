

resource "azurerm_private_dns_zone" "default" {
  name = "${var.dns_zone_name}.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "default" {
  name                  = "pl-${var.name}-flex-postgres"
  private_dns_zone_name = azurerm_private_dns_zone.default.name
  virtual_network_id    = var.vnet_id
  resource_group_name   = var.resource_group_name
}

resource "random_password" "db_password" {
  length = 12
  special = false
  min_numeric = 1
  min_upper = 1
  min_lower = 1
}

resource "azurerm_postgresql_flexible_server" "default" {
  name                   = var.name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = "11"
  delegated_subnet_id    = var.db_subnet_id
  private_dns_zone_id    = azurerm_private_dns_zone.default.id
  administrator_login    = var.db_username
  administrator_password = random_password.db_password.result
  zone                   = "1"
  storage_mb             = var.storage_mb # 32768
  sku_name               = var.sku_name # "B_Standard_B1ms"
  backup_retention_days  = var.backup_retention_days
  depends_on = [azurerm_private_dns_zone_virtual_network_link.default]
}

resource "azurerm_postgresql_flexible_server_database" "database" {
  name = "tablename-swisspine"
  server_id = azurerm_postgresql_flexible_server.default.id
  lifecycle {
    prevent_destroy = true
  }
}