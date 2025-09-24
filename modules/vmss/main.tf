# VMSS Module
# This module creates a Virtual Machine Scale Set with autoscaling and NGINX installation

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

# Create Public IP for Load Balancer
resource "azurerm_public_ip" "vmss_public_ip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

# Create Load Balancer
resource "azurerm_lb" "vmss_lb" {
  name                = var.load_balancer_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.vmss_public_ip.id
  }

  tags = var.tags
}

# Create Backend Pool
resource "azurerm_lb_backend_address_pool" "vmss_backend_pool" {
  loadbalancer_id = azurerm_lb.vmss_lb.id
  name            = "BackEndAddressPool"
}

# Create Health Probe
resource "azurerm_lb_probe" "vmss_probe" {
  loadbalancer_id = azurerm_lb.vmss_lb.id
  name            = "http-probe"
  port            = 80
  protocol        = "Http"
  request_path    = "/"
}

# Create Load Balancer Rule
resource "azurerm_lb_rule" "vmss_lb_rule" {
  loadbalancer_id                = azurerm_lb.vmss_lb.id
  name                           = "HTTPRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.vmss_backend_pool.id]
  probe_id                       = azurerm_lb_probe.vmss_probe.id
}

# Create Virtual Machine Scale Set
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = var.vmss_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.vm_sku
  instances           = var.initial_instances

  # Security enhancements
  disable_password_authentication = true

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "internal"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = var.subnet_id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.vmss_backend_pool.id]
    }
  }

  admin_username = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  # Enable system-assigned managed identity
  identity {
    type = "SystemAssigned"
  }

  # Install NGINX via custom script extension
  custom_data = base64encode(local.nginx_install_script)

  # Enable boot diagnostics
  boot_diagnostics {
    storage_account_uri = null
  }

  tags = var.tags
}

# Custom script for NGINX installation
locals {
  nginx_install_script = <<EOF
#!/bin/bash

# Main initialization script for MKB VMSS
set -e

echo "Starting MKB VMSS initialization..."

# Install NGINX
echo "=== Installing NGINX ==="
${file("${path.module}/scripts/install-nginx.sh")}

# Create custom HTML page
echo "=== Creating custom HTML page ==="
${file("${path.module}/scripts/create-html.sh")}

# Create stress test script
echo "=== Creating stress test script ==="
${file("${path.module}/scripts/create-stress-script.sh")} ${var.admin_username}

echo "MKB VMSS initialization completed successfully"
EOF
}

# Create Monitor Autoscale Setting
resource "azurerm_monitor_autoscale_setting" "vmss_autoscale" {
  name                = "${var.vmss_name}-autoscale"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.vmss.id

  profile {
    name = "defaultProfile"

    capacity {
      default = var.initial_instances
      minimum = var.min_instances
      maximum = var.max_instances
    }

    # Scale out rule (when CPU > 70%)
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = var.scale_out_cpu_threshold
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    # Scale in rule (when CPU < 30%)
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = var.scale_in_cpu_threshold
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }

  tags = var.tags
}