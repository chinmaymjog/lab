resource "azurerm_subnet" "net_docker_lab" {
  name                 = "net_docker_lab"
  resource_group_name  = var.rgname
  virtual_network_name = azurerm_virtual_network.vnet_docker_lab.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "nsg_asso_docker_lab" {
  subnet_id                 = azurerm_subnet.net_docker_lab.id
  network_security_group_id = azurerm_network_security_group.nsg_docker_lab.id
}