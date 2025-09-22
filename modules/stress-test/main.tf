# Stress Test Module
# This module handles stress testing capabilities using provided SSH keys

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

# Save the private key to local file (for SSH access)
resource "local_file" "stress_test_private_key" {
  content         = var.ssh_private_key
  filename        = "${path.root}/stress-test-private-key.pem"
  file_permission = "0600"
}

# Save the public key to local file (for reference)
resource "local_file" "stress_test_public_key" {
  content         = var.ssh_public_key
  filename        = "${path.root}/stress-test-public-key.pub"
  file_permission = "0644"
}

# Create stress test script as a local file
resource "local_file" "stress_test_script" {
  content = templatefile("${path.module}/stress-test-script.sh", {
    load_balancer_ip = var.load_balancer_ip
    private_key_path = local_file.stress_test_private_key.filename
    admin_username   = var.admin_username
  })
  filename        = "${path.root}/run-stress-test.sh"
  file_permission = "0755"
}

# Create instructions file
resource "local_file" "stress_test_instructions" {
  content = templatefile("${path.module}/stress-test-instructions.md", {
    load_balancer_ip = var.load_balancer_ip
    private_key_path = local_file.stress_test_private_key.filename
    admin_username   = var.admin_username
    script_path      = local_file.stress_test_script.filename
  })
  filename        = "${path.root}/STRESS-TEST-INSTRUCTIONS.md"
  file_permission = "0644"
}