variable "web_nsg_name" {
  description = "Name of the web subnet NSG"
  type        = string
  default     = "web-nsg"
}

variable "app_nsg_name" {
  description = "Name of the app subnet NSG"
  type        = string
  default     = "app-nsg"
}

variable "db_nsg_name" {
  description = "Name of the database subnet NSG"
  type        = string
  default     = "db-nsg"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "web_subnet_id" {
  description = "ID of the web subnet"
  type        = string
}

variable "app_subnet_id" {
  description = "ID of the app subnet"
  type        = string
}

variable "db_subnet_id" {
  description = "ID of the database subnet"
  type        = string
}

variable "web_subnet_address_prefix" {
  description = "Address prefix of the web subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "app_subnet_address_prefix" {
  description = "Address prefix of the app subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}