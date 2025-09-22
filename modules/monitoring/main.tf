# Monitoring Module
# This module creates Azure Monitor and Log Analytics for infrastructure monitoring

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

# Create Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "log_workspace" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.retention_in_days

  tags = var.tags
}

# Create Action Group for Alerts
resource "azurerm_monitor_action_group" "main" {
  name                = var.action_group_name
  resource_group_name = var.resource_group_name
  short_name          = var.action_group_short_name

  email_receiver {
    name          = "admin-email"
    email_address = var.alert_email
  }

  tags = var.tags
}

# CPU Alert Rule for VMSS
resource "azurerm_monitor_metric_alert" "cpu_alert" {
  name                = "vmss-cpu-alert"
  resource_group_name = var.resource_group_name
  scopes              = [var.vmss_id]
  description         = "Alert when CPU usage exceeds 80% for 10 minutes"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT10M"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = var.tags
}

# Network Bandwidth Alert Rule for VMSS
resource "azurerm_monitor_metric_alert" "network_alert" {
  name                = "vmss-network-alert"
  resource_group_name = var.resource_group_name
  scopes              = [var.vmss_id]
  description         = "Alert when network bandwidth usage exceeds 500 MB per hour"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT1H"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name      = "Network In Total"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 524288000 # 500 MB in bytes
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = var.tags
}

# Data Collection Rule for VM Insights
resource "azurerm_monitor_data_collection_rule" "vmss_dcr" {
  name                = "vmss-performance-dcr"
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = "Data collection rule for VMSS performance monitoring"

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.log_workspace.id
      name                  = "log-workspace"
    }
  }

  data_flow {
    streams      = ["Microsoft-Perf", "Microsoft-InsightsMetrics"]
    destinations = ["log-workspace"]
  }

  data_sources {
    performance_counter {
      streams                       = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = 60
      counter_specifiers = [
        "\\Processor(_Total)\\% Processor Time",
        "\\Memory\\Available MBytes",
        "\\Network Interface(*)\\Bytes Total/sec"
      ]
      name = "perfCounterDataSource"
    }
  }

  tags = var.tags
}

# Associate DCR with VMSS
resource "azurerm_monitor_data_collection_rule_association" "vmss_dcr_association" {
  name                    = "vmss-dcr-association"
  target_resource_id      = var.vmss_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.vmss_dcr.id
  description             = "Association between VMSS and performance monitoring DCR"
}

# Application Insights for web application monitoring
resource "azurerm_application_insights" "app_insights" {
  name                = var.application_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.log_workspace.id
  application_type    = "web"

  tags = var.tags
}