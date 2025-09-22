# Main Terraform Configuration for MKB Network Infrastructure
# This configuration orchestrates all modules to create a complete Azure infrastructure

terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Common tags for all resources
locals {
  common_tags = {
    Environment = "Production"
    Project     = "MKB-Network"
    CreatedBy   = "Terraform"
    CreatedDate = timestamp()
  }
}

# Create Resource Group
module "resource_group" {
  source = "./modules/resource-group"

  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = local.common_tags
}

# Create Networking Infrastructure
module "networking" {
  source = "./modules/networking"

  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  vnet_name           = var.vnet_name
  tags                = local.common_tags

  depends_on = [module.resource_group]
}

# Create Security Groups
module "security" {
  source = "./modules/security"

  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  web_subnet_id       = module.networking.web_subnet_id
  app_subnet_id       = module.networking.app_subnet_id
  db_subnet_id        = module.networking.db_subnet_id
  tags                = local.common_tags

  depends_on = [module.networking]
}

# Create Virtual Machine Scale Set
module "vmss" {
  source = "./modules/vmss"

  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  subnet_id            = module.networking.web_subnet_id
  admin_ssh_public_key = var.admin_ssh_public_key
  tags                 = local.common_tags

  depends_on = [module.security]
}

# Create Azure Bastion (optional - can be enabled/disabled)
module "bastion" {
  count  = var.enable_bastion ? 1 : 0
  source = "./modules/bastion"

  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  bastion_subnet_id   = module.networking.bastion_subnet_id
  tags                = local.common_tags

  depends_on = [module.networking]
}