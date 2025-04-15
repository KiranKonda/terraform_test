provider "azurerm" {
  features {}
}

# Existing resource group (for import/update)
data "azurerm_resource_group" "existing" {
  name = var.rg_name
}

resource "azurerm_resource_group" "this" {
  name     = data.azurerm_resource_group.existing.name
  location = data.azurerm_resource_group.existing.location
  tags = {
    Creator = var.student_email
  }
}

resource "azurerm_storage_account" "this" {
  name                     = var.storageaccount_name
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    Creator = var.student_email
  }
}

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.0.0/16"]
  tags = {
    Creator = var.student_email
  }
}

resource "azurerm_subnet" "subnet1" {
  name                 = var.subnet1_name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = var.subnet2_name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.2.0/24"]
}
