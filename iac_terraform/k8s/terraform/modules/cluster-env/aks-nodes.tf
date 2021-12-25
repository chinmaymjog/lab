resource "azurerm_network_interface" "node_net_int" {
  count               = var.nodevm_count
  name                = "k8s-node-${count.index}_nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.cluster_rg.name

  ip_configuration {
    name                          = "k8s-node-${count.index}_pub_ip"
    subnet_id                     = azurerm_subnet.kub_subnet.id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
    public_ip_address_id          = azurerm_public_ip.bastion_node_pub_int[count.index].id
  }
}

resource "azurerm_public_ip" "node_pub_int" {
  count               = var.nodevm_count
  name                = "k8s-node-${count.index}_pub_ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.cluster_rg.name
  allocation_method   = "Static"
}

data "template_file" "kub_nodes" {
  template = "${file("${path.module}/scripts/kub_nodes.tpl")}"
  vars = {
    master_ip = "${azurerm_network_interface.master_net_int.private_ip_address}"
    token     = "${var.token}"
  }
}

resource "azurerm_virtual_machine" "node_host" {
  count                 = var.nodevm_count
  name                  = "k8s-node-${count.index}_host"
  location              = var.location
  resource_group_name   = azurerm_resource_group.cluster_rg.name
  network_interface_ids = ["${azurerm_network_interface.node_net_int[count.index].id}"]
  vm_size               = var.nodevm_size
  depends_on            = [azurerm_virtual_machine.master_host]
  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    id        = data.azurerm_image.template.id
  }

  os_profile {
    computer_name  = "k8s-node-${count.index}"
    admin_username = "manage"
    admin_password = "Password1234!"
    custom_data    = "data.template_file.kub_nodes.rendered"
  }

  storage_os_disk {
    name              = "k8s-node-${count.index}_osdisk"
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
