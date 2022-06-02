resource "azurerm_log_analytics_workspace" "log_docker_lab" {
  name                = "log-docker-lab"
  location            = var.location
  resource_group_name = var.rgname
}

data "azurerm_log_analytics_workspace" "log_docker_lab" {
  name                = "log-docker-lab"
  resource_group_name = var.rgname
  depends_on          = [azurerm_log_analytics_workspace.log_docker_lab]
}