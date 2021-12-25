resource "azurerm_resource_group" "cluster_rg" {
  name = "${var.resource_group}_env"
  location = var.location
  tags = var.tags
}

resource "azurerm_virtual_network" "cluster_vnet" {
  name = "${var.location}_${var.environment}_vnet"
  location = var.location
  resource_group_name = azurerm_resource_group.cluster_rg.name
  address_space = [var.vnet]
  tags = var.tags
}

resource "azurerm_subnet" "bastion_subnet" {
  name                      = "${var.location}_${var.environment}_bastion_snet"
  resource_group_name       = azurerm_resource_group.cluster_rg.name
  virtual_network_name      = azurerm_virtual_network.cluster_vnet.name
  address_prefix            = var.bastion_subnet
}

resource "azurerm_network_security_group" "bastion_sg" {
  name                = "${var.location}_${var.environment}_bastion_sg"
  location            = var.location
  resource_group_name = azurerm_resource_group.cluster_rg.name

  security_rule {
    name                       = "SSH_Port"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "bastion_sg_asso" {
  subnet_id                 = azurerm_subnet.bastion_subnet.id
  network_security_group_id = azurerm_network_security_group.bastion_sg.id
}

resource "azurerm_subnet" "kub_subnet" {
  name                      = "${var.location}_${var.environment}_kub_snet"
  resource_group_name       = azurerm_resource_group.cluster_rg.name
  virtual_network_name      = azurerm_virtual_network.cluster_vnet.name
  address_prefix            = var.kub_subnet
}

resource "azurerm_network_security_group" "kub_sg" {
  name                = "${var.location}_${var.environment}_kub_sg"
  location            = var.location
  resource_group_name = azurerm_resource_group.cluster_rg.name

  security_rule {
    name                       = "SSH_Port"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP_Port"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPs_Port"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "kub_sg_asso" {
  subnet_id                 = azurerm_subnet.kub_subnet.id
  network_security_group_id = azurerm_network_security_group.kub_sg.id
}

resource "azurerm_subnet" "redis_subnet" {
  name                      = "${var.location}_${var.environment}_redis_snet"
  resource_group_name       = azurerm_resource_group.cluster_rg.name
  virtual_network_name      = azurerm_virtual_network.cluster_vnet.name
  address_prefix            = var.redis_subnet
}

resource "azurerm_network_security_group" "redis_sg" {
  name                = "${var.location}_${var.environment}_redis_sg"
  location            = var.location
  resource_group_name = azurerm_resource_group.cluster_rg.name
  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "redis_sg_asso" {
  subnet_id                 = azurerm_subnet.redis_subnet.id
  network_security_group_id = azurerm_network_security_group.redis_sg.id
}

data "azurerm_image" "template" {
  resource_group_name = "${var.resource_group}"
  name_regex = "^source_image*"
}
