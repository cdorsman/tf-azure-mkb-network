output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.log_workspace.id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.log_workspace.name
}

output "log_analytics_workspace_key" {
  description = "Primary shared key of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.log_workspace.primary_shared_key
  sensitive   = true
}

output "application_insights_id" {
  description = "ID of Application Insights"
  value       = azurerm_application_insights.app_insights.id
}

output "application_insights_instrumentation_key" {
  description = "Application Insights instrumentation key"
  value       = azurerm_application_insights.app_insights.instrumentation_key
  sensitive   = true
}

output "action_group_id" {
  description = "ID of the action group"
  value       = azurerm_monitor_action_group.main.id
}

output "cpu_alert_id" {
  description = "ID of the CPU alert rule"
  value       = azurerm_monitor_metric_alert.cpu_alert.id
}

output "network_alert_id" {
  description = "ID of the network alert rule"
  value       = azurerm_monitor_metric_alert.network_alert.id
}

output "data_collection_rule_id" {
  description = "ID of the data collection rule"
  value       = azurerm_monitor_data_collection_rule.vmss_dcr.id
}