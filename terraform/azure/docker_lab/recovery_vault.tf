resource "azurerm_resource_group" "rg_backup" {
  name     = "${var.rgname}-backup"
  location = var.location
}

resource "azurerm_recovery_services_vault" "rsv_vault" {
  name                = "rsv-${var.project}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_backup.name
  sku                 = "Standard"
  soft_delete_enabled = false
}

resource "azurerm_backup_policy_vm" "bkp_policy" {
  name                = "bkp-policy-${var.project}"
  resource_group_name = azurerm_resource_group.rg_backup.name
  recovery_vault_name = azurerm_recovery_services_vault.rsv_vault.name

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 7
  }
}