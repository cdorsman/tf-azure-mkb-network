variable "load_balancer_ip" {
  description = "Public IP address of the load balancer"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the VMs"
  type        = string
  default     = "azureuser"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}