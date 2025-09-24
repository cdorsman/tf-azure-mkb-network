# NGINX Installation Script
# This script installs and configures NGINX on Ubuntu

set -e

echo "Starting NGINX installation..."

# Update package list
sudo apt-get update -y

# Install NGINX
sudo apt-get install -y nginx

# Install stress-ng for testing
sudo apt-get install -y stress-ng

# Install Azure Monitor Agent dependencies
sudo apt-get install -y curl wget

# Start and enable NGINX
sudo systemctl start nginx
sudo systemctl enable nginx

# Configure firewall (if enabled)
sudo ufw allow 'Nginx Full' 2>/dev/null || true
sudo ufw allow OpenSSH 2>/dev/null || true

echo "NGINX installation completed successfully"