resource "azurerm_resource_group" "swiss_pine_rg" {
  name = "SwissPine_RG_${terraform.workspace}"
  location = "southeastasia"
}

module "virtual_network" {
  source = "../modules/network"
  resource_group_name = azurerm_resource_group.swiss_pine_rg.name
  location = azurerm_resource_group.swiss_pine_rg.location
  vnet_name = "swisspine-vnet-${terraform.workspace}"
  aks_subnet_name = "swisspine-aks-subnet-${terraform.workspace}"
  db_subnet_name = "swisspine-db-subnet-${terraform.workspace}"
  address_space = "192.168.0.0/16"
  aks_subnet_a_cidr = "192.168.0.1/24"
  aks_subnet_b_cidr = "192.168.0.2/24"
  db_subnet_cidr = "192.168.1.1/24"
}

module "aks_cluster" {
  source = "../modules/aks"
  resource_group_name = azurerm_resource_group.swiss_pine_rg.name
  location = azurerm_resource_group.swiss_pine_rg.location
  cluster_name = "swisspine-cluster-${terraform.workspace}"
  vnet_subnet_a_id = module.virtual_network.aks_subnet_a_id
  kubernetes_version = "1.29.4"
  service_cidr = "192.168.0.0/16"
  dns_service_ip = "192.168.2.1"
  dns_prefix = "swisspine-${terraform.workspace}"
  agent_count = 2
  node_count = 2
  scale_max_count = 2
  scale_min_count = 2
}

module "db_instance" {
  source = "../modules/db"
  resource_group_name = azurerm_resource_group.swiss_pine_rg.name
  application_name = "swisspine-${terraform.workspace}"
  name = "swisspine-${terraform.workspace}-db"
  vnet_id = module.virtual_network.aks_vnet_id
  vnet_name = module.virtual_network.aks_vnet_name
  db_subnet_id = module.virtual_network.db_subnet_id
  dns_zone_name = "swisspine-${terraform.workspace}-db"
}