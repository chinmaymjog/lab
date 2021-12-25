resource "azurerm_network_interface" "bastion_net_int" {
  name                = "bastion_nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.cluster_rg.name

  ip_configuration {
    name                          = "bastion_pub_ip"
    subnet_id                     = azurerm_subnet.bastion_subnet.id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
    public_ip_address_id          = azurerm_public_ip.bastion_pub_int.id
  }
}

resource "azurerm_public_ip" "bastion_pub_int" {
  name                = "bastion_pub_ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.cluster_rg.name
  allocation_method   = "Static"
}

resource "azurerm_virtual_machine" "bastion_host" {
  name                  = "bastion_host"
  location              = var.location
  resource_group_name   = azurerm_resource_group.cluster_rg.name
  network_interface_ids = ["${azurerm_network_interface.bastion_net_int.id}"]
  vm_size               = var.bastionvm_size

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    id        = data.azurerm_image.template.id
  }

  os_profile {
    computer_name  = "bastionhost"
    admin_username = "manage"
    admin_password = "Password1234!"
  }

  storage_os_disk {
    name              = "bastion_host_osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("~/.ssh/id_rsa.pub")
      path = "/home/manage/.ssh/authorized_keys"
    }
  }

  tags = var.tags
}
