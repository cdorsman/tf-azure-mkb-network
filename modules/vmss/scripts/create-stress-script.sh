# Create Stress Test Script
# This script creates the stress testing script for monitoring validation

set -e

USER_HOME="/home/$1"
USERNAME="$1"

echo "Creating stress test script for user: $USERNAME"

# Create stress test script
cat > "$USER_HOME/stress_test.sh" << 'STRESS'
#!/bin/bash

# Stress Test Script for MKB Infrastructure Monitoring
# This script generates CPU load to test Azure Monitor alerts

echo "=================================================="
echo "MKB Infrastructure - Stress Test Script"
echo "=================================================="
echo "Starting CPU stress test for monitoring alerts..."
echo "This will trigger the CPU alert after 10 minutes of >80% usage"
echo "Press Ctrl+C to stop the test early"
echo ""

# Check if stress-ng is installed
if ! command -v stress-ng &> /dev/null; then
    echo "ERROR: stress-ng is not installed. Installing now..."
    sudo apt-get update && sudo apt-get install -y stress-ng
fi

# Show system info
echo "System Information:"
echo "- Hostname: $(hostname)"
echo "- CPU cores: $(nproc)"
echo "- Memory: $(free -h | awk '/^Mem:/ {print $2}')"
echo "- Load average: $(uptime | awk -F'load average:' '{print $2}')"
echo ""

# Start stress test
echo "Starting stress test..."
echo "Duration: 10 minutes (600 seconds)"
echo "Target: All CPU cores at 100% usage"
echo ""

stress-ng --cpu 0 --timeout 600s --metrics-brief

echo ""
echo "Stress test completed."
echo "Check Azure Monitor for CPU usage alerts."
STRESS

# Set permissions
chmod +x "$USER_HOME/stress_test.sh"
chown "$USERNAME:$USERNAME" "$USER_HOME/stress_test.sh"

echo "Stress test script created at: $USER_HOME/stress_test.sh"