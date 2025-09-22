# Resource Group Module
# This module creates the Azure Resource Group for the MKB Network infrastructure

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

# Create the resource group
resource "azurerm_resource_group" "mkb_rg" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}