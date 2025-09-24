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

variable "bastion_subnet_id" {
  description = "ID of the bastion subnet"
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

variable "allowed_ssh_source_ranges" {
  description = "List of IP ranges allowed for SSH access (use specific ranges instead of * for security)"
  type        = list(string)
  default     = ["10.0.0.0/16"] # Only allow SSH from within the VNet by default
}

variable "allowed_http_source_ranges" {
  description = "List of IP ranges allowed for HTTP/HTTPS access"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Can be restricted to specific ranges for better security
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}