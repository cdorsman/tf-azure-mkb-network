# Security Module
# This module creates Network Security Groups and rules for the MKB infrastructure

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

# Network Security Group for Web Subnet
resource "azurerm_network_security_group" "web_nsg" {
  name                = var.web_nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  # Allow HTTP traffic
  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow HTTPS traffic
  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow SSH for management
  security_rule {
    name                       = "AllowSSH"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Network Security Group for App Subnet
resource "azurerm_network_security_group" "app_nsg" {
  name                = var.app_nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  # Allow traffic from Web Subnet
  security_rule {
    name                       = "AllowFromWebSubnet"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.web_subnet_address_prefix
    destination_address_prefix = "*"
  }

  # Allow SSH for management
  security_rule {
    name                       = "AllowSSH"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Network Security Group for DB Subnet
resource "azurerm_network_security_group" "db_nsg" {
  name                = var.db_nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  # Allow MySQL traffic only from App Subnet
  security_rule {
    name                       = "AllowMySQLFromAppSubnet"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = var.app_subnet_address_prefix
    destination_address_prefix = "*"
  }

  # Deny all other inbound traffic
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Associate NSG with Web Subnet
resource "azurerm_subnet_network_security_group_association" "web_nsg_association" {
  subnet_id                 = var.web_subnet_id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}

# Associate NSG with App Subnet
resource "azurerm_subnet_network_security_group_association" "app_nsg_association" {
  subnet_id                 = var.app_subnet_id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}

# Associate NSG with DB Subnet
resource "azurerm_subnet_network_security_group_association" "db_nsg_association" {
  subnet_id                 = var.db_subnet_id
  network_security_group_id = azurerm_network_security_group.db_nsg.id
}