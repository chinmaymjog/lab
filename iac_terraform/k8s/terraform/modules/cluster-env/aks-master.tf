resource "azurerm_network_interface" "master_net_int" {
  name                = "master_nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.cluster_rg.name

  ip_configuration {
    name                          = "master_pub_ip"
    subnet_id                     = azurerm_subnet.kub_subnet.id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
    public_ip_address_id          = azurerm_public_ip.master_pub_int.id
  }
}

resource "azurerm_public_ip" "master_pub_int" {
  name                = "master_pub_ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.cluster_rg.name
  allocation_method   = "Static"
}

data "template_file" "kub_master" {
  template = "${file("${path.module}/scripts/kub_master.tpl")}"
  vars = {
    pod_subnet = "${var.pod_subnet}"
    token      = "${var.token}"
  }
}

resource "azurerm_virtual_machine" "master_host" {
  name                  = "master_host"
  location              = var.location
  resource_group_name   = azurerm_resource_group.cluster_rg.name
  network_interface_ids = ["${azurerm_network_interface.master_net_int.id}"]
  vm_size               = var.mastervm_size

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    id        = data.azurerm_image.template.id
  }

  os_profile {
    computer_name  = "masterhost"
    admin_username = "manage"
    admin_password = "Password1234!"
    custom_data    = "data.template_file.kub_master.rendered"
  }

  storage_os_disk {
    name              = "master_host_osdisk"
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
