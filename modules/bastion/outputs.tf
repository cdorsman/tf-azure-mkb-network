output "bastion_id" {
  description = "ID of the Azure Bastion"
  value       = azurerm_bastion_host.bastion.id
}

output "bastion_name" {
  description = "Name of the Azure Bastion"
  value       = azurerm_bastion_host.bastion.name
}

output "bastion_public_ip" {
  description = "Public IP address of the Azure Bastion"
  value       = azurerm_public_ip.bastion_public_ip.ip_address
}

output "bastion_fqdn" {
  description = "FQDN of the Azure Bastion"
  value       = azurerm_public_ip.bastion_public_ip.fqdn
}