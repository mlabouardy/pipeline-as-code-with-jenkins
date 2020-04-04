data "azurerm_image" "jenkins_worker_image" {
  name                = var.jenkins_worker_image
  resource_group_name = data.azurerm_resource_group.management.name
}

data "template_file" "jenkins_worker_startup_script" {
  template = "${file("scripts/join-cluster.tpl")}"

  vars = {
    jenkins_url            = "http://${azurerm_public_ip.jenkins_lb_public_ip.ip_address}:8080"
    jenkins_username       = var.jenkins_username
    jenkins_password       = var.jenkins_password
    jenkins_credentials_id = var.jenkins_credentials_id
  }
}

resource "azurerm_virtual_machine_scale_set" "jenkins_workers_set" {
  name                = "jenkins-workers-set"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.management.name
  upgrade_policy_mode = "Manual"

  sku {
    name     = var.jenkins_vm_size
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    id = data.azurerm_image.jenkins_worker_image.id
  }

  storage_profile_os_disk {
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name_prefix = "jenkins-worker"
    admin_username = var.config["vm_username"]
    custom_data = data.template_file.jenkins_worker_startup_script.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.config["vm_username"]}/.ssh/authorized_keys"
      key_data = file(var.public_ssh_key)
    }
  }

  network_profile {
    name    = "private-network"
    primary = true
    network_security_group_id = azurerm_network_security_group.jenkins_worker_security_group.id
    ip_configuration {
      name = "private-ip-configuration"
      primary = true
      subnet_id = data.azurerm_subnet.private_subnet.id
    }
  }
}

resource "azurerm_monitor_autoscale_setting" "jenkins_workers_autoscale" {
  name                = "jenkins-workers-autoscale"
  resource_group_name = data.azurerm_resource_group.management.name
  location            = var.location
  target_resource_id  = azurerm_virtual_machine_scale_set.jenkins_workers_set.id

  profile {
    name = "jenkins-autoscale"

    capacity {
      default = 2
      minimum = 2
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_virtual_machine_scale_set.jenkins_workers_set.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 80
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_virtual_machine_scale_set.jenkins_workers_set.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 20
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}