variable "bastion_name" {
  description = "Name of the Azure Bastion"
  type        = string
  default     = "mkb-bastion"
}

variable "bastion_public_ip_name" {
  description = "Name of the public IP for Azure Bastion"
  type        = string
  default     = "mkb-bastion-public-ip"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "bastion_subnet_id" {
  description = "ID of the AzureBastionSubnet"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}