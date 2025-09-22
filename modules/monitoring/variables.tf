variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  type        = string
  default     = "LogWorkspace"
}

variable "log_analytics_sku" {
  description = "SKU for Log Analytics workspace"
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "Retention period for logs in days"
  type        = number
  default     = 30
}

variable "action_group_name" {
  description = "Name of the action group for alerts"
  type        = string
  default     = "mkb-alert-group"
}

variable "action_group_short_name" {
  description = "Short name for the action group"
  type        = string
  default     = "mkbalert"
}

variable "alert_email" {
  description = "Email address for receiving alerts"
  type        = string
}

variable "application_insights_name" {
  description = "Name of Application Insights"
  type        = string
  default     = "mkb-app-insights"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "vmss_id" {
  description = "ID of the Virtual Machine Scale Set to monitor"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}