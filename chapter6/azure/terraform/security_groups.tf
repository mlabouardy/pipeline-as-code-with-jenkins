resource "azurerm_network_security_group" "jenkins_security_group" {
  name 			= "jenkins-sg"
  location 		= var.location
  resource_group_name 	= data.azurerm_resource_group.management.name

  security_rule {
	name 			= "AllowSSH"
	priority 		= 100
	direction 		= "Inbound"
	access 		        = "Allow"
	protocol 		= "Tcp"
	source_port_range       = "*"
    destination_port_range     	= "22"
    source_address_prefix      	= "*"
    destination_address_prefix 	= "*"
  }

  security_rule {
	name 			= "AllowHTTP"
	priority		= 200
	direction		= "Inbound"
	access 			= "Allow"
	protocol 		= "Tcp"
	source_port_range       = "*"
    destination_port_range     	= "8080"
    source_address_prefix      	= "Internet"
    destination_address_prefix 	= "*"
  }
}

resource "azurerm_network_security_group" "jenkins_worker_security_group" {
  name 			= "jenkins-worker-sg"
  location 		= var.location
  resource_group_name 	= data.azurerm_resource_group.management.name

  security_rule {
	name 			= "AllowSSH"
	priority 		= 100
	direction 		= "Inbound"
	access 		        = "Allow"
	protocol 		= "Tcp"
	source_port_range       = "*"
    destination_port_range     	= "22"
    source_address_prefix      	= "*"
    destination_address_prefix 	= "*"
  }
}