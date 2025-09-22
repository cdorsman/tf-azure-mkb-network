#!/bin/bash

# Stress Test Automation Script
# This script connects to the VMSS and runs stress tests to trigger monitoring alerts

set -e

echo "🔥 Starting MKB Infrastructure Stress Test"
echo "=========================================="

LOAD_BALANCER_IP="${load_balancer_ip}"
PRIVATE_KEY_PATH="${private_key_path}"
ADMIN_USERNAME="${admin_username}"

echo "Load Balancer IP: $LOAD_BALANCER_IP"
echo "SSH Key: $PRIVATE_KEY_PATH"
echo "Username: $ADMIN_USERNAME"
echo ""

# Check if SSH key exists
if [ ! -f "$PRIVATE_KEY_PATH" ]; then
    echo "❌ SSH private key not found at: $PRIVATE_KEY_PATH"
    echo "Please run 'terraform apply' first to generate SSH keys."
    exit 1
fi

echo "✅ SSH key found"
echo "🔍 Testing SSH connection..."

# Test SSH connection
if ! ssh -i "$PRIVATE_KEY_PATH" -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$ADMIN_USERNAME@$LOAD_BALANCER_IP" "echo 'SSH connection successful'" 2>/dev/null; then
    echo "❌ SSH connection failed!"
    echo "Please check:"
    echo "- Load balancer IP is correct: $LOAD_BALANCER_IP"
    echo "- VM instances are running"
    echo "- NSG allows SSH traffic"
    exit 1
fi

echo "✅ SSH connection successful"
echo ""

echo "🚀 Starting CPU stress test..."
echo "This will:"
echo "- Run stress-ng for 10 minutes (600 seconds)"
echo "- Use all available CPU cores"
echo "- Trigger CPU alert after ~10 minutes of >80% usage"
echo ""

# Run stress test on remote VM
ssh -i "$PRIVATE_KEY_PATH" -o StrictHostKeyChecking=no "$ADMIN_USERNAME@$LOAD_BALANCER_IP" << 'EOF'
echo "📊 Current system info:"
echo "CPU cores: $(nproc)"
echo "Memory: $(free -h | grep '^Mem:' | awk '{print $2}')"
echo "Load average: $(uptime | awk -F'load average:' '{print $2}')"
echo ""

echo "🔥 Starting stress test..."
echo "⏰ Duration: 10 minutes (600 seconds)"
echo "🎯 Target: >80% CPU usage to trigger monitoring alert"
echo ""

# Check if stress-ng is available
if ! command -v stress-ng &> /dev/null; then
    echo "Installing stress-ng..."
    sudo apt-get update -y && sudo apt-get install -y stress-ng
fi

# Run stress test
echo "Starting CPU stress test NOW..."
stress-ng --cpu 0 --timeout 600s --metrics-brief

echo ""
echo "✅ Stress test completed!"
echo "📧 Check your email for monitoring alerts"
echo "📊 View the Azure Monitor dashboard for real-time metrics"
EOF

echo ""
echo "🎉 Stress test completed successfully!"
echo "📧 Monitor alerts should be triggered if CPU >80% for 10+ minutes"
echo "📊 Check Azure Monitor dashboard for real-time metrics"
echo "🔗 Access dashboard via Terraform outputs: terraform output azure_portal_links"