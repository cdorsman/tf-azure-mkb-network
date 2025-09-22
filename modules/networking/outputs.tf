output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.mkb_vnet.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.mkb_vnet.name
}

output "web_subnet_id" {
  description = "ID of the web subnet"
  value       = azurerm_subnet.web_subnet.id
}

output "web_subnet_name" {
  description = "Name of the web subnet"
  value       = azurerm_subnet.web_subnet.name
}

output "app_subnet_id" {
  description = "ID of the app subnet"
  value       = azurerm_subnet.app_subnet.id
}

output "app_subnet_name" {
  description = "Name of the app subnet"
  value       = azurerm_subnet.app_subnet.name
}

output "db_subnet_id" {
  description = "ID of the database subnet"
  value       = azurerm_subnet.db_subnet.id
}

output "db_subnet_name" {
  description = "Name of the database subnet"
  value       = azurerm_subnet.db_subnet.name
}

output "bastion_subnet_id" {
  description = "ID of the bastion subnet"
  value       = azurerm_subnet.bastion_subnet.id
}

output "bastion_subnet_name" {
  description = "Name of the bastion subnet"
  value       = azurerm_subnet.bastion_subnet.name
}