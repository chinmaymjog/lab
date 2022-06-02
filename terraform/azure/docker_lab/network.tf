resource "azurerm_virtual_network" "vnet_docker_lab" {
  name                = "vnet-docker-lab"
  location            = var.location
  resource_group_name = var.rgname
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_monitor_diagnostic_setting" "dlog_vnet_docker_lab" {
  name                       = "dlog-vnet-docker-lab"
  target_resource_id         = azurerm_virtual_network.vnet_docker_lab.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_docker_lab.id

  log {
    category = "VMProtectionAlerts"
  }

  metric {
    category = "AllMetrics"
  }
}