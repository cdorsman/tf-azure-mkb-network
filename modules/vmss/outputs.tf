output "vmss_id" {
  description = "ID of the Virtual Machine Scale Set"
  value       = azurerm_linux_virtual_machine_scale_set.vmss.id
}

output "vmss_name" {
  description = "Name of the Virtual Machine Scale Set"
  value       = azurerm_linux_virtual_machine_scale_set.vmss.name
}

output "load_balancer_public_ip" {
  description = "Public IP address of the load balancer"
  value       = azurerm_public_ip.vmss_public_ip.ip_address
}

output "load_balancer_fqdn" {
  description = "FQDN of the load balancer"
  value       = azurerm_public_ip.vmss_public_ip.fqdn
}

output "autoscale_setting_id" {
  description = "ID of the autoscale setting"
  value       = azurerm_monitor_autoscale_setting.vmss_autoscale.id
}

output "web_url" {
  description = "Web URL to access the application"
  value       = "http://${azurerm_public_ip.vmss_public_ip.ip_address}"
}