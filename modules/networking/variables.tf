variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "mkb-vnet"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "web_subnet_name" {
  description = "Name of the web subnet"
  type        = string
  default     = "WebSubnet"
}

variable "web_subnet_address_prefixes" {
  description = "Address prefixes for the web subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "app_subnet_name" {
  description = "Name of the app subnet"
  type        = string
  default     = "AppSubnet"
}

variable "app_subnet_address_prefixes" {
  description = "Address prefixes for the app subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "db_subnet_name" {
  description = "Name of the database subnet"
  type        = string
  default     = "DBSubnet"
}

variable "db_subnet_address_prefixes" {
  description = "Address prefixes for the database subnet"
  type        = list(string)
  default     = ["10.0.3.0/24"]
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}