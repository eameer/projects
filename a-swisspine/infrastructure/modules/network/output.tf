output "aks_subnet_a_id" {
  value = azurerm_subnet.aks_subnet_a.id
}
output "aks_subnet_b_id" {
  value = azurerm_subnet.aks_subnet_b.id
}
output "aks_vnet_id" {
  value = azurerm_virtual_network.aks_vnet.id
}
output "aks_vnet_name" {
  value = azurerm_virtual_network.aks_vnet.name
}

output "db_subnet_id" {
  value = azurerm_subnet.db_subnet.id
}