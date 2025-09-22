variable "dashboard_name" {
  description = "Name of the Azure dashboard"
  type        = string
  default     = "MKB-Monitoring-Dashboard"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "vmss_name" {
  description = "Name of the VMSS to monitor"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  type        = string
}

variable "application_insights_id" {
  description = "ID of Application Insights"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}