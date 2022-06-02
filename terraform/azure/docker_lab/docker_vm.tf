resource "azurerm_resource_group" "rg_docker_lab" {
  name     = var.rgname
  location = var.location
}

resource "azurerm_public_ip" "pip_docker_lab" {
  name                = "pip-vm-${var.project}-${count.index}"
  resource_group_name = azurerm_resource_group.rg_docker_lab.name
  location            = azurerm_resource_group.rg_docker_lab.location
  allocation_method   = "Static"
  count               = var.enable_docker_vm == "true" ? "${var.docker_vm_count}" : "0"
}

resource "azurerm_network_interface" "nic_docker_lab" {
  name                = "nic-vm-${var.project}-${count.index}"
  resource_group_name = azurerm_resource_group.rg_docker_lab.name
  location            = azurerm_resource_group.rg_docker_lab.location
  count               = var.enable_docker_vm == "true" ? "${var.docker_vm_count}" : "0"

  ip_configuration {
    name                          = "nic1"
    subnet_id                     = azurerm_subnet.net_docker_lab.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_docker_lab[count.index].id
  }
}

resource "azurerm_virtual_machine" "vm_docker_lab" {
  name                  = "vm-${var.project}-${count.index}"
  resource_group_name   = azurerm_resource_group.rg_docker_lab.name
  location              = azurerm_resource_group.rg_docker_lab.location
  network_interface_ids = [azurerm_network_interface.nic_docker_lab[count.index].id]
  vm_size               = var.vmsize
  count                 = var.enable_docker_vm == "true" ? "${var.docker_vm_count}" : "0"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true
/*
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.vmsku
    version   = "latest"
  }
*/
  storage_image_reference {
    id = data.azurerm_image.source_image.id
  }

  storage_os_disk {
    name              = "vm-${var.project}-${count.index}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = "vm-${var.project}-${count.index}-datadisk"
    caching           = "ReadWrite"
    create_option     = "Empty"
    managed_disk_type = "Standard_LRS"
    lun               = "1"
    disk_size_gb      = var.datadisksize
  }

  os_profile {
    computer_name  = "vm-${var.project}-${count.index}"
    admin_username = var.username
    admin_password = var.password
  }
  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      key_data = file("~/.ssh/id_rsa.pub")
      path     = "/home/${var.username}/.ssh/authorized_keys"
    }
  }
}

resource "azurerm_backup_protected_vm" "vm_backups" {
  count               = var.enable_docker_vm == "true" ? "${var.docker_vm_count}" : "0"
  resource_group_name = azurerm_resource_group.rg_backup.name
  recovery_vault_name = azurerm_recovery_services_vault.rsv_vault.name
  source_vm_id        = azurerm_virtual_machine.vm_docker_lab[count.index].id
  backup_policy_id    = azurerm_backup_policy_vm.bkp_policy.id
}