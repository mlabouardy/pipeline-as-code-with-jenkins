data "azurerm_resource_group" "management" {
  name = var.resource_group
}

resource "azurerm_virtual_network" "management" {
  name                = "management"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.management.name
  address_space       = [var.base_cidr_block]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  dynamic "subnet" {
    for_each = [for s in var.subnets: {
      name   = s.name
      prefix = cidrsubnet(var.base_cidr_block, 8, s.number)
    }]

    content {
      name           = subnet.value.name
      address_prefix = subnet.value.prefix
    }
  }

  subnet {
    name           = "AzureBastionSubnet"
    address_prefix = cidrsubnet(var.base_cidr_block, 11, 224)
  }

  tags = {
    environment = "management"
  }
}