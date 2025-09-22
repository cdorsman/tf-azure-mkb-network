# Networking Module
# This module creates the Virtual Network and subnets for the MKB infrastructure

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

# Create Virtual Network
resource "azurerm_virtual_network" "mkb_vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Create Web Subnet
resource "azurerm_subnet" "web_subnet" {
  name                 = var.web_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.mkb_vnet.name
  address_prefixes     = var.web_subnet_address_prefixes
}

# Create App Subnet
resource "azurerm_subnet" "app_subnet" {
  name                 = var.app_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.mkb_vnet.name
  address_prefixes     = var.app_subnet_address_prefixes
}

# Create DB Subnet
resource "azurerm_subnet" "db_subnet" {
  name                 = var.db_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.mkb_vnet.name
  address_prefixes     = var.db_subnet_address_prefixes
}

# Create Bastion Subnet (required for Azure Bastion)
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.mkb_vnet.name
  address_prefixes     = ["10.0.4.0/24"]
}