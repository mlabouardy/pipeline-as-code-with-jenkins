resource "azurerm_public_ip" "bastion_public_ip" {
  name                = "bastion-public-ip"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.management.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

data "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  virtual_network_name = azurerm_virtual_network.management.name
  resource_group_name  = data.azurerm_resource_group.management.name

  depends_on = [azurerm_virtual_network.management]
}

resource "azurerm_bastion_host" "bastion" {
  name                = "bastion"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.management.name

  depends_on = [azurerm_virtual_network.management]
  
  ip_configuration {
    name                 = "bastion-configuration"
    subnet_id            = data.azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }
}