data "azurerm_image" "jenkins_master_image" {
  name                = var.jenkins_master_image
  resource_group_name = data.azurerm_resource_group.management.name
}

data "azurerm_subnet" "private_subnet" {
  name                 = var.subnets[2].name
  virtual_network_name = azurerm_virtual_network.management.name
  resource_group_name  = data.azurerm_resource_group.management.name

  depends_on = [azurerm_virtual_network.management]
}

resource "azurerm_network_interface" "jenkins_network_interface" {
  name                = "jenkins_network_interface"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.management.name
  network_security_group_id = azurerm_network_security_group.jenkins_security_group.id

  depends_on = [azurerm_virtual_network.management]

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.private_subnet.id
    private_ip_address_allocation = "Dynamic"
    load_balancer_backend_address_pools_ids = [azurerm_lb_backend_address_pool.jenkins_backend.id]
  }
}

resource "azurerm_virtual_machine" "jenkins_master" {
  name                = "jenkins-master"
  resource_group_name = data.azurerm_resource_group.management.name
  location            = var.location
  vm_size             = var.jenkins_vm_size

  network_interface_ids = [
    azurerm_network_interface.jenkins_network_interface.id,
  ]

  os_profile {
    computer_name  = var.config["os_name"]
    admin_username = var.config["vm_username"]
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.config["vm_username"]}/.ssh/authorized_keys"
      key_data = file(var.public_ssh_key)
    }
  }

  storage_os_disk {
    name = "main"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
    disk_size_gb      = "30"
  }

  storage_image_reference {
    id = data.azurerm_image.jenkins_master_image.id
  }

  delete_os_disk_on_termination = true
}