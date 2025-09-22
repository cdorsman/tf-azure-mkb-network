# Production Environment Configuration
# This file contains all Terraform definitions for deploying the MKB production infrastructure

terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
  }

  # Local backend - state file will be stored locally as terraform.tfstate
  # For production, consider using remote backend for team collaboration
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Data source for current client configuration
data "azurerm_client_config" "current" {}

# Production environment variables - all values defined inline
locals {
  # Environment configuration
  environment         = "production"
  resource_group_name = "RG-MKB-Netwerk"
  location            = "West Europe"
  vnet_name           = "mkb-vnet-prod"

  # VM Scale Set configuration
  vm_sku            = "Standard_B2s" # Production VM size
  initial_instances = 2              # Start with 2 instances
  min_instances     = 2              # Minimum for HA
  max_instances     = 5              # Maximum for production load

  # Features
  enable_bastion = true

  # Monitoring configuration
  alert_email = "admin@mkb-company.com" # Replace with your email

  # Production tags
  common_tags = {
    Environment        = "Production"
    Project            = "MKB-Network"
    CreatedBy          = "Terraform"
    CreatedDate        = "2025-09-22"
    Owner              = "IT-Department"
    CostCenter         = "Infrastructure"
    Backup             = "Required"
    Monitoring         = "Enhanced"
    MaintenanceWindow  = "Sunday-02:00-04:00"
    SLA                = "99.9%"
    DataClassification = "Internal"
  }
}

# Create Resource Group
module "resource_group" {
  source = "../modules/resource-group"

  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.common_tags
}

# Create Networking Infrastructure
module "networking" {
  source = "../modules/networking"

  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  vnet_name           = local.vnet_name

  # Production network configuration
  vnet_address_space          = ["10.0.0.0/16"]
  web_subnet_name             = "WebSubnet"
  web_subnet_address_prefixes = ["10.0.1.0/24"]
  app_subnet_name             = "AppSubnet"
  app_subnet_address_prefixes = ["10.0.2.0/24"]
  db_subnet_name              = "DBSubnet"
  db_subnet_address_prefixes  = ["10.0.3.0/24"]

  tags = local.common_tags

  depends_on = [module.resource_group]
}

# Create Security Groups
module "security" {
  source = "../modules/security"

  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location

  # Subnet references
  web_subnet_id = module.networking.web_subnet_id
  app_subnet_id = module.networking.app_subnet_id
  db_subnet_id  = module.networking.db_subnet_id

  # Production security group names
  web_nsg_name = "web-nsg-prod"
  app_nsg_name = "app-nsg-prod"
  db_nsg_name  = "db-nsg-prod"

  # Subnet address prefixes for security rules
  web_subnet_address_prefix = "10.0.1.0/24"
  app_subnet_address_prefix = "10.0.2.0/24"

  tags = local.common_tags

  depends_on = [module.networking]
}

# Create SSH Keys and Stress Testing Infrastructure
module "stress_test" {
  source = "../modules/stress-test"

  load_balancer_ip = module.vmss.load_balancer_public_ip
  admin_username   = "azureuser"

  tags = local.common_tags

  depends_on = [module.vmss]
}

# Create Virtual Machine Scale Set
module "vmss" {
  source = "../modules/vmss"

  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  subnet_id           = module.networking.web_subnet_id

  # Production VMSS configuration
  vmss_name          = "mkb-vmss-prod"
  public_ip_name     = "mkb-vmss-public-ip-prod"
  load_balancer_name = "mkb-vmss-lb-prod"
  vm_sku             = local.vm_sku
  initial_instances  = local.initial_instances
  min_instances      = local.min_instances
  max_instances      = local.max_instances

  # Autoscaling thresholds for production
  scale_out_cpu_threshold = 70
  scale_in_cpu_threshold  = 30

  # SSH configuration from stress-test module
  admin_username = "azureuser"
  ssh_public_key = module.stress_test.ssh_public_key_content

  tags = local.common_tags

  depends_on = [module.security]
}

# Create Monitoring Infrastructure
module "monitoring" {
  source = "../modules/monitoring"

  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  vmss_id             = module.vmss.vmss_id
  alert_email         = local.alert_email

  # Production monitoring configuration
  log_analytics_workspace_name = "LogWorkspace-Prod"
  action_group_name            = "mkb-alert-group-prod"
  application_insights_name    = "mkb-app-insights-prod"
  retention_in_days            = 90 # Longer retention for production

  tags = local.common_tags

  depends_on = [module.vmss]
}

# Create Monitoring Dashboard
module "dashboard" {
  source = "../modules/dashboard"

  resource_group_name        = module.resource_group.resource_group_name
  location                   = module.resource_group.resource_group_location
  vmss_name                  = module.vmss.vmss_name
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
  application_insights_id    = module.monitoring.application_insights_id

  # Production dashboard configuration
  dashboard_name = "MKB-Production-Monitoring-Dashboard"

  tags = local.common_tags

  depends_on = [module.monitoring]
}

# Create Azure Bastion (conditional)
module "bastion" {
  count  = local.enable_bastion ? 1 : 0
  source = "../modules/bastion"

  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  bastion_subnet_id   = module.networking.bastion_subnet_id

  # Production bastion configuration
  bastion_name           = "mkb-bastion-prod"
  bastion_public_ip_name = "mkb-bastion-public-ip-prod"

  tags = local.common_tags

  depends_on = [module.networking]
}

# Production Environment Outputs
output "production_deployment_summary" {
  description = "Complete summary of the production deployment"
  value = {
    environment             = local.environment
    resource_group_name     = module.resource_group.resource_group_name
    location                = module.resource_group.resource_group_location
    vnet_name               = module.networking.vnet_name
    vmss_name               = module.vmss.vmss_name
    web_application_url     = module.vmss.web_url
    load_balancer_ip        = module.vmss.load_balancer_public_ip
    bastion_enabled         = local.enable_bastion
    vm_sku                  = local.vm_sku
    min_instances           = local.min_instances
    max_instances           = local.max_instances
    current_instances       = local.initial_instances
    deployment_date         = local.common_tags.CreatedDate
    monitoring_enabled      = true
    log_analytics_workspace = module.monitoring.log_analytics_workspace_name
    dashboard_name          = module.dashboard.dashboard_name
  }
}

output "production_connection_info" {
  description = "Connection information for production environment"
  value = {
    web_application_url = module.vmss.web_url
    ssh_access          = local.enable_bastion ? "Use Azure Portal Bastion" : module.stress_test.ssh_connection_command
    ssh_private_key     = module.stress_test.ssh_private_key_path
    load_balancer_ip    = module.vmss.load_balancer_public_ip
    resource_group      = module.resource_group.resource_group_name
    management_portal   = "https://portal.azure.com"
  }
}

output "production_resource_ids" {
  description = "Resource IDs for production environment"
  value = {
    resource_group_id = module.resource_group.resource_group_id
    vnet_id           = module.networking.vnet_id
    vmss_id           = module.vmss.vmss_id
    web_nsg_id        = module.security.web_nsg_id
    app_nsg_id        = module.security.app_nsg_id
    db_nsg_id         = module.security.db_nsg_id
    bastion_id        = local.enable_bastion ? module.bastion[0].bastion_id : null
  }
}

output "generated_ssh_keys" {
  description = "Information about the generated SSH keys"
  value = {
    private_key_path = module.stress_test.ssh_private_key_path
    public_key_path  = module.stress_test.ssh_public_key_path
    ssh_command      = module.stress_test.ssh_connection_command
  }
  sensitive = false
}

output "stress_test_info" {
  description = "Stress testing information and commands"
  value = {
    script_path         = module.stress_test.stress_test_script_path
    instructions_path   = module.stress_test.stress_test_instructions_path
    ssh_command         = module.stress_test.ssh_connection_command
    load_balancer_ip    = module.vmss.load_balancer_public_ip
    stress_test_command = "bash ${module.stress_test.stress_test_script_path}"
  }
}

output "monitoring_information" {
  description = "Monitoring and alerting information"
  value = {
    log_analytics_workspace_name = module.monitoring.log_analytics_workspace_name
    dashboard_url                = module.dashboard.dashboard_url
    alert_email                  = local.alert_email
    cpu_alert_threshold          = "80% for 10 minutes"
    network_alert_threshold      = "500 MB per hour"
    stress_test_script           = module.stress_test.stress_test_script_path
  }
}

output "azure_portal_links" {
  description = "Direct links to Azure Portal resources"
  value = {
    resource_group_url = "https://portal.azure.com/#@/resource/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${module.resource_group.resource_group_name}"
    vmss_url           = "https://portal.azure.com/#@/resource${module.vmss.vmss_id}"
    log_analytics_url  = "https://portal.azure.com/#@/resource${module.monitoring.log_analytics_workspace_id}"
    dashboard_url      = module.dashboard.dashboard_url
    alerts_url         = "https://portal.azure.com/#@/blade/Microsoft_Azure_Monitoring/AlertsMenuBlade/alertRulesList"
  }
}