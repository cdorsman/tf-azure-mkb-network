# Azure Bastion Module
# This module creates Azure Bastion for secure connectivity testing between subnets

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

# Create Public IP for Azure Bastion
resource "azurerm_public_ip" "bastion_public_ip" {
  name                = var.bastion_public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

# Create Azure Bastion Host
resource "azurerm_bastion_host" "bastion" {
  name                   = var.bastion_name
  location               = var.location
  resource_group_name    = var.resource_group_name
  sku                    = "Standard"
  tunneling_enabled      = true
  ip_connect_enabled     = true
  shareable_link_enabled = false

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.bastion_subnet_id
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }

  tags = var.tags
}