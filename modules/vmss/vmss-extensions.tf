# VMSS Extensions Configuration
# This file manages extensions for the VMSS to enable monitoring

# Azure Monitor Agent Extension for VMSS
resource "azurerm_virtual_machine_scale_set_extension" "azure_monitor_agent" {
  name                         = "AzureMonitorLinuxAgent"
  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.vmss.id
  publisher                    = "Microsoft.Azure.Monitor"
  type                         = "AzureMonitorLinuxAgent"
  type_handler_version         = "1.25"
  auto_upgrade_minor_version   = true

  settings = jsonencode({
    "authentication" = {
      "managedIdentity" = {
        "identifier-name" = "system"
        "identifier-value" = ""
      }
    }
  })

  depends_on = [azurerm_linux_virtual_machine_scale_set.vmss]
}