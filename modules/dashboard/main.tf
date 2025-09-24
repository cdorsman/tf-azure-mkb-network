# Dashboard Module - Simplified Version for Azure Portal Compatibility
# This creates a simple dashboard that should work with the latest Azure Portal

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

# Create a Simple Azure Dashboard - back to original working structure
resource "azurerm_portal_dashboard" "monitoring_dashboard" {
  name                = var.dashboard_name
  resource_group_name = var.resource_group_name
  location            = var.location

  dashboard_properties = jsonencode({
    lenses = {
      "0" = {
        order = 0
        parts = {
          # CPU Usage Tile
          "0" = {
            position = {
              x       = 0
              y       = 0
              colSpan = 6
              rowSpan = 4
            }
            metadata = {
              inputs = [
                {
                  name = "queryInputs"
                  value = {
                    timespan = {
                      duration = "PT1H"
                    }
                    id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Compute/virtualMachineScaleSets/${var.vmss_name}"
                    chartType = 0
                    metrics = [
                      {
                        name            = "Percentage CPU"
                        resourceId      = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Compute/virtualMachineScaleSets/${var.vmss_name}"
                        aggregationType = "Average"
                        namespace       = "Microsoft.Compute/virtualMachineScaleSets"
                        metricVisualization = {
                          displayName = "CPU Percentage"
                        }
                      }
                    ]
                  }
                }
              ]
              settings = {}
              type = "Extension/Microsoft_Azure_Monitoring/PartType/MetricsChartPart"
            }
          },
          # Network In Tile
          "1" = {
            position = {
              x       = 6
              y       = 0
              colSpan = 6
              rowSpan = 4
            }
            metadata = {
              inputs = [
                {
                  name = "queryInputs"
                  value = {
                    timespan = {
                      duration = "PT1H"
                    }
                    id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Compute/virtualMachineScaleSets/${var.vmss_name}"
                    chartType = 0
                    metrics = [
                      {
                        name            = "Network In"
                        resourceId      = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Compute/virtualMachineScaleSets/${var.vmss_name}"
                        aggregationType = "Average"
                        namespace       = "Microsoft.Compute/virtualMachineScaleSets"
                        metricVisualization = {
                          displayName = "Network In"
                        }
                      }
                    ]
                  }
                }
              ]
              settings = {}
              type = "Extension/Microsoft_Azure_Monitoring/PartType/MetricsChartPart"
            }
          },
          # Network Out Tile  
          "2" = {
            position = {
              x       = 0
              y       = 4
              colSpan = 6
              rowSpan = 4
            }
            metadata = {
              inputs = [
                {
                  name = "queryInputs"
                  value = {
                    timespan = {
                      duration = "PT1H"
                    }
                    id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Compute/virtualMachineScaleSets/${var.vmss_name}"
                    chartType = 0
                    metrics = [
                      {
                        name            = "Network Out"
                        resourceId      = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Compute/virtualMachineScaleSets/${var.vmss_name}"
                        aggregationType = "Average"
                        namespace       = "Microsoft.Compute/virtualMachineScaleSets"
                        metricVisualization = {
                          displayName = "Network Out"
                        }
                      }
                    ]
                  }
                }
              ]
              settings = {}
              type = "Extension/Microsoft_Azure_Monitoring/PartType/MetricsChartPart"
            }
          },
          # VM Availability Tile
          "3" = {
            position = {
              x       = 6
              y       = 4
              colSpan = 6
              rowSpan = 4
            }
            metadata = {
              inputs = [
                {
                  name = "queryInputs"
                  value = {
                    timespan = {
                      duration = "PT1H"
                    }
                    id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Compute/virtualMachineScaleSets/${var.vmss_name}"
                    chartType = 0
                    metrics = [
                      {
                        name            = "VmAvailabilityMetric"
                        resourceId      = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Compute/virtualMachineScaleSets/${var.vmss_name}"
                        aggregationType = "Average"
                        namespace       = "Microsoft.Compute/virtualMachineScaleSets"
                        metricVisualization = {
                          displayName = "VM Availability"
                        }
                      }
                    ]
                  }
                }
              ]
              settings = {}
              type = "Extension/Microsoft_Azure_Monitoring/PartType/MetricsChartPart"
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
              duration = 1
              timeUnit = 1
            }
          }
          type = "MsPortalFx.Composition.Configuration.ValueTypes.TimeRange"
        }
        filterLocale = {
          value = "en-us"
        }
        filters = {
          value = {}
        }
      }
    }
  })

  tags = var.tags
}