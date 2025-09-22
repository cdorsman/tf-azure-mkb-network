# Dashboard Module
# This module creates Azure dashboards for monitoring

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

# Data source for current client configuration
data "azurerm_client_config" "current" {}

# Create Azure Dashboard for MKB Infrastructure Monitoring
resource "azurerm_dashboard" "monitoring_dashboard" {
  name                = var.dashboard_name
  resource_group_name = var.resource_group_name
  location            = var.location
  
  dashboard_properties = jsonencode({
    lenses = {
      "0" = {
        order = 0
        parts = {
          "0" = {
            position = {
              x = 0
              y = 0
              colSpan = 6
              rowSpan = 4
            }
            metadata = {
              inputs = [
                {
                  name = "resourceTypeMode"
                  isOptional = true
                },
                {
                  name = "ComponentId"
                  value = {
                    SubscriptionId = data.azurerm_client_config.current.subscription_id
                    ResourceGroup = var.resource_group_name
                    Name = var.vmss_name
                    ResourceType = "Microsoft.Compute/virtualMachineScaleSets"
                  }
                },
                {
                  name = "Scope"
                  value = {
                    resourceIds = [
                      "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Compute/virtualMachineScaleSets/${var.vmss_name}"
                    ]
                  }
                },
                {
                  name = "PartId"
                  value = "cpu-chart"
                },
                {
                  name = "Version"
                  value = "2.0"
                },
                {
                  name = "TimeRange"
                  value = "PT1H"
                },
                {
                  name = "Query"
                  value = "Perf | where ObjectName == \"Processor\" and CounterName == \"% Processor Time\" and InstanceName == \"_Total\" | summarize AggregatedValue = avg(CounterValue) by bin(TimeGenerated, 5m)"
                },
                {
                  name = "ControlType"
                  value = "FrameControlChart"
                }
              ]
              type = "Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart"
              settings = {
                content = {
                  Query = "Perf | where ObjectName == \"Processor\" and CounterName == \"% Processor Time\" and InstanceName == \"_Total\" | summarize AggregatedValue = avg(CounterValue) by bin(TimeGenerated, 5m)\n"
                  ControlType = "FrameControlChart"
                  SpecificChart = "Line"
                  PartTitle = "CPU Usage (%)"
                  Dimensions = {
                    xAxis = {
                      name = "TimeGenerated"
                      type = "datetime"
                    }
                    yAxis = [
                      {
                        name = "AggregatedValue"
                        type = "real"
                      }
                    ]
                    splitBy = []
                    aggregation = "Sum"
                  }
                }
              }
            }
          }
          "1" = {
            position = {
              x = 6
              y = 0
              colSpan = 6
              rowSpan = 4
            }
            metadata = {
              inputs = [
                {
                  name = "resourceTypeMode"
                  isOptional = true
                },
                {
                  name = "ComponentId"
                  value = {
                    SubscriptionId = data.azurerm_client_config.current.subscription_id
                    ResourceGroup = var.resource_group_name
                    Name = var.vmss_name
                    ResourceType = "Microsoft.Compute/virtualMachineScaleSets"
                  }
                },
                {
                  name = "Query"
                  value = "Perf | where ObjectName == \"Memory\" and CounterName == \"Available MBytes\" | summarize AggregatedValue = avg(CounterValue) by bin(TimeGenerated, 5m)"
                }
              ]
              type = "Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart"
              settings = {
                content = {
                  Query = "Perf | where ObjectName == \"Memory\" and CounterName == \"Available MBytes\" | summarize AggregatedValue = avg(CounterValue) by bin(TimeGenerated, 5m)\n"
                  ControlType = "FrameControlChart"
                  SpecificChart = "Line"
                  PartTitle = "Available Memory (MB)"
                }
              }
            }
          }
          "2" = {
            position = {
              x = 0
              y = 4
              colSpan = 12
              rowSpan = 4
            }
            metadata = {
              inputs = [
                {
                  name = "Query"
                  value = "Perf | where ObjectName == \"Network Interface\" and CounterName == \"Bytes Total/sec\" | summarize AggregatedValue = avg(CounterValue) by bin(TimeGenerated, 5m)"
                }
              ]
              type = "Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart"
              settings = {
                content = {
                  Query = "Perf | where ObjectName == \"Network Interface\" and CounterName == \"Bytes Total/sec\" | summarize AggregatedValue = avg(CounterValue) by bin(TimeGenerated, 5m)\n"
                  ControlType = "FrameControlChart"
                  SpecificChart = "Line"
                  PartTitle = "Network Activity (Bytes/sec)"
                }
              }
            }
          }
        }
      }
    }
    metadata = {
      model = {
        timeRange = {
          value = {
            relative = {
              duration = 24
              timeUnit = 1
            }
          }
          type = "MsPortalFx.Composition.Configuration.ValueTypes.TimeRange"
        }
        filterLocale = {
          value = "en-us"
        }
        filters = {
          value = {
            MsPortalFx_TimeRange = {
              model = {
                format = "utc"
                granularity = "auto"
                relative = "24h"
              }
              displayCache = {
                name = "UTC Time"
                value = "Past 24 hours"
              }
              filteredPartIds = []
            }
          }
        }
      }
    }
  })

  tags = var.tags
}