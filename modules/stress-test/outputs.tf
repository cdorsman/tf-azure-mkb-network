output "ssh_private_key_path" {
  description = "Path to the SSH private key for stress testing"
  value       = local_file.stress_test_private_key.filename
}

output "ssh_public_key_path" {
  description = "Path to the SSH public key"
  value       = local_file.stress_test_public_key.filename
}

output "ssh_connection_command" {
  description = "SSH command to connect to VMs for stress testing"
  value       = "ssh -i ${local_file.stress_test_private_key.filename} ${var.admin_username}@${var.load_balancer_ip}"
}

output "stress_test_script_path" {
  description = "Path to the generated stress test script"
  value       = local_file.stress_test_script.filename
}

output "stress_test_instructions_path" {
  description = "Path to the stress test instructions file"
  value       = local_file.stress_test_instructions.filename
}