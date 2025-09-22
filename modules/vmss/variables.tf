variable "vmss_name" {
  description = "Name of the Virtual Machine Scale Set"
  type        = string
  default     = "mkb-vmss"
}

variable "public_ip_name" {
  description = "Name of the public IP for the load balancer"
  type        = string
  default     = "mkb-vmss-public-ip"
}

variable "load_balancer_name" {
  description = "Name of the load balancer"
  type        = string
  default     = "mkb-vmss-lb"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where VMSS will be deployed"
  type        = string
}

variable "vm_sku" {
  description = "SKU for the virtual machines"
  type        = string
  default     = "Standard_B1s"
}

variable "initial_instances" {
  description = "Initial number of instances"
  type        = number
  default     = 1
}

variable "min_instances" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "max_instances" {
  description = "Maximum number of instances"
  type        = number
  default     = 3
}

variable "scale_out_cpu_threshold" {
  description = "CPU threshold for scaling out"
  type        = number
  default     = 70
}

variable "scale_in_cpu_threshold" {
  description = "CPU threshold for scaling in"
  type        = number
  default     = 30
}

variable "admin_username" {
  description = "Admin username for the VMs"
  type        = string
  default     = "azureuser"
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