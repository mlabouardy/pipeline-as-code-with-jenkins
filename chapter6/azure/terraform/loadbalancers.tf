resource "azurerm_public_ip" "jenkins_lb_public_ip" {
 name                         = "jenkins-lb-public-ip"
 location                     = var.location
 resource_group_name          = data.azurerm_resource_group.management.name
 allocation_method            = "Static"
}

resource "azurerm_lb" "jenkins_lb" {
 name                = "jenkins-lb"
 location            = var.location
 resource_group_name = data.azurerm_resource_group.management.name

 frontend_ip_configuration {
   name                 = "publicIPAddress"
   public_ip_address_id = azurerm_public_ip.jenkins_lb_public_ip.id
 }
}

resource "azurerm_lb_backend_address_pool" "jenkins_backend" {
 resource_group_name = data.azurerm_resource_group.management.name
 loadbalancer_id     = azurerm_lb.jenkins_lb.id
 name                = "jenkins-backend"
}

resource "azurerm_lb_probe" "jenkins_lb_probe" {
  resource_group_name = data.azurerm_resource_group.management.name
  loadbalancer_id     = azurerm_lb.jenkins_lb.id
  name                = "jenkins-lb-probe"
  protocol            = "Http"
  request_path        = "/"
  port                = 8080
}

resource "azurerm_lb_rule" "jenkins_lb_rule" {
  name = "jenkins-lb-rule"
  resource_group_name = data.azurerm_resource_group.management.name
  protocol = "tcp"
  enable_floating_ip = false
  probe_id = azurerm_lb_probe.jenkins_lb_probe.id
  loadbalancer_id = azurerm_lb.jenkins_lb.id
  backend_address_pool_id = azurerm_lb_backend_address_pool.jenkins_backend.id
  frontend_ip_configuration_name = "publicIPAddress"
  frontend_port = 80
  backend_port = 8080
}