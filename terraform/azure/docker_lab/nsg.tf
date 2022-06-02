resource "azurerm_network_security_group" "nsg_docker_lab" {
  name                = "nsg-docker-lab"
  location            = var.location
  resource_group_name = var.rgname

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}


resource "azurerm_monitor_diagnostic_setting" "dlog_nsg_docker_lab" {
  name                       = "dlog-nsg-docker-lab"
  target_resource_id         = azurerm_network_security_group.nsg_docker_lab.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_docker_lab.id

  log {
    category = "NetworkSecurityGroupEvent"
  }

  log {
    category = "NetworkSecurityGroupRuleCounter"
  }
}