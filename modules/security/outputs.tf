output "web_nsg_id" {
  description = "ID of the web subnet NSG"
  value       = azurerm_network_security_group.web_nsg.id
}

output "app_nsg_id" {
  description = "ID of the app subnet NSG"
  value       = azurerm_network_security_group.app_nsg.id
}

output "db_nsg_id" {
  description = "ID of the database subnet NSG"
  value       = azurerm_network_security_group.db_nsg.id
}

output "web_nsg_name" {
  description = "Name of the web subnet NSG"
  value       = azurerm_network_security_group.web_nsg.name
}

output "app_nsg_name" {
  description = "Name of the app subnet NSG"
  value       = azurerm_network_security_group.app_nsg.name
}

output "db_nsg_name" {
  description = "Name of the database subnet NSG"
  value       = azurerm_network_security_group.db_nsg.name
}