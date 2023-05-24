locals {
  location   = "westus2"
  node_count = 2
}

data "azurerm_resource_group" "rg" {
  name     = "k8s"
  location = local.location
}

resource "azurerm_virtual_network" "k8s-vnet" {
  name                = "k8s-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "k8s-subnet" {
  name                 = "k8s-subnet"
  virtual_network_name = azurerm_virtual_network.k8s-vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
  address_prefixes     = ["10.0.0.0/24"]
}
