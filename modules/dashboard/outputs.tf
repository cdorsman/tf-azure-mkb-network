output "dashboard_id" {
  description = "ID of the created dashboard"
  value       = azurerm_portal_dashboard.monitoring_dashboard.id
}

output "dashboard_name" {
  description = "Name of the created dashboard"
  value       = azurerm_portal_dashboard.monitoring_dashboard.name
}

output "dashboard_url" {
  description = "URL to access the dashboard in Azure Portal"
  value       = "https://portal.azure.com/#@/dashboard/arm${azurerm_portal_dashboard.monitoring_dashboard.id}"
}