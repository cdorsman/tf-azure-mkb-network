variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "RG-MKB-Netwerk"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "West Europe"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "Production"
    Project     = "MKB-Network"
    CreatedBy   = "Terraform"
  }
}