# Variable definitions for the main configuration

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "RG-MKB-Netwerk"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "West Europe"
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
  default     = "mkb-vnet"
}

variable "admin_ssh_public_key" {
  description = "SSH public key for VM admin user"
  type        = string
  validation {
    condition     = can(regex("^ssh-", var.admin_ssh_public_key))
    error_message = "The admin_ssh_public_key must be a valid SSH public key starting with 'ssh-'."
  }
}

variable "enable_bastion" {
  description = "Whether to create Azure Bastion for secure connectivity"
  type        = bool
  default     = true
}