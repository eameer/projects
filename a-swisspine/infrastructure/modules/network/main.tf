resource "azurerm_virtual_network" "aks_vnet" {
  name                = var.vnet_name
  address_space       = [var.address_space]
  resource_group_name = var.resource_group_name
  location            = var.location
}
resource "azurerm_subnet" "aks_subnet_a" {
  name                 = "${var.aks_subnet_name}-a"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = var.aks_subnet_a_cidr
  service_endpoints    = var.service_endpoints
}
resource "azurerm_subnet" "aks_subnet_b" {
  name                 = "${var.aks_subnet_name}-b"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = var.aks_subnet_b_cidr
  service_endpoints    = var.service_endpoints
}
resource "azurerm_subnet" "db_subnet" {
  name                 = var.db_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = var.db_subnet_cidr
  service_endpoints    = ["Microsoft.Sql"]

  delegation {
    name = "postgresDelegation"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
    }
  }
}

resource "azurerm_network_security_group" "db_subnet_nsg" {
  name                = "${var.db_subnet_name}-db-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name  

  security_rule {
    name                       = "${var.db_subnet_name}-db-sec-rule-a"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "5423"
    destination_port_range     = "5423"
    source_address_prefix      = azurerm_subnet.aks_subnet_a.address_prefixes[0]
    destination_address_prefix = azurerm_subnet.db_subnet.address_prefixes[0]
  }
  security_rule {
    name                       = "${var.db_subnet_name}-db-sec-rule-b"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "5423"
    destination_port_range     = "5423"
    source_address_prefix      = azurerm_subnet.aks_subnet_b.address_prefixes[0]
    destination_address_prefix = azurerm_subnet.db_subnet.address_prefixes[0]
  }
}

resource "azurerm_subnet_network_security_group_association" "db_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.db_subnet.id
  network_security_group_id = azurerm_network_security_group.db_subnet_nsg.id
}

resource "azurerm_network_security_group" "aks_subnet_nsg" {
  name                = "${var.aks_subnet_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "${var.aks_subnet_name}-sec-inbound-http-rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "${var.aks_subnet_name}-sec-inbound-https-rule"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "${var.aks_subnet_name}-sec-outbound-rule-k8s-110"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "2579"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "${var.aks_subnet_name}-sec-outbound-rule-k8s-1"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "1194"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "${var.aks_subnet_name}-sec-outbound-rule-k8s-2"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "${var.aks_subnet_name}-sec-outbound-rule-k8s-3"
    priority                   = 300
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "123"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "${var.aks_subnet_name}-sec-outbound-rule-k8s-4"
    priority                   = 400
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "${var.aks_subnet_name}-sec-outbound-rule-k8s-5"
    priority                   = 500
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "aks_subnet_nsg_association_a" {
  subnet_id                 = azurerm_subnet.aks_subnet_a.id
  network_security_group_id = azurerm_network_security_group.aks_subnet_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "aks_subnet_nsg_association_b" {
  subnet_id                 = azurerm_subnet.aks_subnet_b.id
  network_security_group_id = azurerm_network_security_group.aks_subnet_nsg.id
}

