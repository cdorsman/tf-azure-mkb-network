# Output values from the main configuration

# Resource Group outputs
output "resource_group_name" {
  description = "Name of the created resource group"
  value       = module.resource_group.resource_group_name
}

output "resource_group_location" {
  description = "Location of the created resource group"
  value       = module.resource_group.resource_group_location
}

# Networking outputs
output "vnet_id" {
  description = "ID of the virtual network"
  value       = module.networking.vnet_id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = module.networking.vnet_name
}

output "web_subnet_id" {
  description = "ID of the web subnet"
  value       = module.networking.web_subnet_id
}

output "app_subnet_id" {
  description = "ID of the app subnet"
  value       = module.networking.app_subnet_id
}

output "db_subnet_id" {
  description = "ID of the database subnet"
  value       = module.networking.db_subnet_id
}

# Security outputs
output "web_nsg_id" {
  description = "ID of the web subnet NSG"
  value       = module.security.web_nsg_id
}

output "app_nsg_id" {
  description = "ID of the app subnet NSG"
  value       = module.security.app_nsg_id
}

output "db_nsg_id" {
  description = "ID of the database subnet NSG"
  value       = module.security.db_nsg_id
}

# VMSS outputs
output "vmss_id" {
  description = "ID of the Virtual Machine Scale Set"
  value       = module.vmss.vmss_id
}

output "vmss_name" {
  description = "Name of the Virtual Machine Scale Set"
  value       = module.vmss.vmss_name
}

output "load_balancer_public_ip" {
  description = "Public IP address of the load balancer"
  value       = module.vmss.load_balancer_public_ip
}

output "web_url" {
  description = "URL to access the web application"
  value       = module.vmss.web_url
}

# Bastion outputs (conditional)
output "bastion_id" {
  description = "ID of the Azure Bastion (if enabled)"
  value       = var.enable_bastion ? module.bastion[0].bastion_id : null
}

output "bastion_name" {
  description = "Name of the Azure Bastion (if enabled)"
  value       = var.enable_bastion ? module.bastion[0].bastion_name : null
}

output "bastion_public_ip" {
  description = "Public IP address of the Azure Bastion (if enabled)"
  value       = var.enable_bastion ? module.bastion[0].bastion_public_ip : null
}

# Summary output
output "deployment_summary" {
  description = "Summary of the deployed infrastructure"
  value = {
    resource_group  = module.resource_group.resource_group_name
    location        = module.resource_group.resource_group_location
    vnet_name       = module.networking.vnet_name
    vmss_name       = module.vmss.vmss_name
    web_url         = module.vmss.web_url
    bastion_enabled = var.enable_bastion
  }
}