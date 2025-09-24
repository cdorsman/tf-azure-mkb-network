# Variable definitions for the main configuration

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "RG-MKB-Netwerk"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "West US 2"
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
  default     = "mkb-vnet"
}

variable "enable_bastion" {
  description = "Whether to create Azure Bastion for secure connectivity"
  type        = bool
  default     = true
}

variable "alert_email" {
  description = "Email address for receiving monitoring alerts"
  type        = string
  default     = "admin@mkb.nl"
}
