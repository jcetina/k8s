locals {
  location   = "westus2"
  node_count = 2
}

data "azurerm_resource_group" "rg" {
  name = "k8s"
}

resource "azurerm_virtual_network" "k8s-vnet" {
  name                = "k8s-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}


resource "azurerm_network_security_group" "nsg" {
  name                = "${var.vm_name}-nsg"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "ICMP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.k8s-subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet" "k8s-subnet" {
  name                 = "k8s-subnet"
  virtual_network_name = azurerm_virtual_network.k8s-vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
  address_prefixes     = ["10.0.0.0/24"]
}

module "k8s-cp" {
  count            = 1
  source           = "./modules/vm"
  location         = data.azurerm_resource_group.rg.location
  rg_name          = data.azurerm_resource_group.rg.name
  vm_name          = "k8s-cp-${count.index}"
  ssh_key          = file("ssh/id_rsa.pub")
  subnet_id        = azurerm_subnet.k8s-subnet.id
  create_public_ip = true
  zones            = ["1", "2", "3"]
  zone             = "1"
}

module "k8s-node" {
  count            = 1
  source           = "./modules/vm"
  location         = data.azurerm_resource_group.rg.location
  rg_name          = data.azurerm_resource_group.rg.name
  vm_name          = "k8s-node-${count.index}"
  ssh_key          = file("ssh/id_rsa.pub")
  subnet_id        = azurerm_subnet.k8s-subnet.id
  create_public_ip = false
  zones            = ["1", "2", "3"]
  zone             = "1"
}