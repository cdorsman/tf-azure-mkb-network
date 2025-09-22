variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "load_balancer_ip" {
  description = "Public IP address of the load balancer"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the VMs"
  type        = string
  default     = "azureuser"
}

variable "ssh_private_key" {
  description = "SSH private key content for VM access"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public key content for VM access"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}