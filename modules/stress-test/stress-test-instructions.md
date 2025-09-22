# Stress Testing Instructions

## Overview
This module provides SSH access and stress testing capabilities for the MKB Infrastructure monitoring system. It generates SSH keys and provides scripts to validate that Azure Monitor alerts are working correctly.

## Prerequisites
- Terraform >= 1.0
- SSH client (available on Linux/macOS/Windows with OpenSSH)
- Azure infrastructure deployed via `terraform apply`

## Quick Start

### 1. Deploy Infrastructure
```bash
# Deploy the complete infrastructure
terraform apply -var-file="terraform.tfvars"
```

### 2. Get Connection Details
```bash
# View SSH connection information
terraform output ssh_connection_command

# View all stress test outputs
terraform output -json stress_test_info
```

### 3. Run Stress Test
```bash
# Make script executable (Linux/macOS)
chmod +x $(terraform output -raw stress_test_script_path)

# Execute stress test
$(terraform output -raw stress_test_script_path)
```

## What the Stress Test Does

### CPU Stress Test
- **Duration**: 10 minutes (600 seconds)
- **Target**: >80% CPU usage across all cores
- **Tool**: stress-ng (automatically installed if missing)
- **Alert Trigger**: Should trigger "High CPU Usage" alert after ~10 minutes

### Expected Monitoring Behavior
1. **Azure Monitor Alert**: CPU usage >80% for 10+ minutes
2. **Email Notification**: Alert sent to configured email address
3. **Dashboard Update**: Real-time CPU metrics visible in Azure Dashboard
4. **Log Analytics**: Performance data logged for analysis

## Manual SSH Access

### Connection Command
```bash
# Use Terraform output for exact command
terraform output ssh_connection_command

# Or manually construct:
ssh -i /path/to/private/key mkbadmin@<load_balancer_ip>
```

### SSH Key Locations
- **Private Key**: `~/.ssh/mkb_infrastructure_key`
- **Public Key**: `~/.ssh/mkb_infrastructure_key.pub`

## Monitoring Validation

### Check Alert Status
1. **Azure Portal**: Monitor > Alerts > Alert Rules
2. **Email**: Check for alert notifications
3. **Dashboard**: View real-time metrics

### Expected Alerts
- **High CPU Usage**: Triggered when CPU >80% for 10+ minutes
- **High Network Usage**: Triggered when network >500MB/hour

### Troubleshooting

#### SSH Connection Issues
```bash
# Test SSH connectivity
ssh -i ~/.ssh/mkb_infrastructure_key -o ConnectTimeout=10 mkbadmin@<lb_ip> "echo 'Connected'"

# Check VM status
az vmss list-instances --resource-group rg-mkb-infrastructure --name vmss-mkb --query "[].{Name:name,State:provisioningState}"
```

#### Alert Not Triggering
1. **Check Alert Rules**: Ensure rules are enabled in Azure Monitor
2. **Verify Metrics**: Confirm Log Analytics is receiving data
3. **Review Timeframes**: Alerts may take 5-15 minutes to trigger
4. **Email Configuration**: Verify action group email settings

#### Performance Issues
```bash
# Check system resources on VM
ssh -i ~/.ssh/mkb_infrastructure_key mkbadmin@<lb_ip> "top -n 1"

# View system load
ssh -i ~/.ssh/mkb_infrastructure_key mkbadmin@<lb_ip> "uptime"
```

## Monitoring Queries

### Log Analytics KQL Queries
```kql
// CPU Usage over time
Perf
| where ObjectName == "Processor" and CounterName == "% Processor Time"
| where TimeGenerated > ago(1h)
| summarize avg(CounterValue) by bin(TimeGenerated, 5m)
| render timechart

// Memory Usage
Perf
| where ObjectName == "Memory" and CounterName == "Available MBytes"
| where TimeGenerated > ago(1h)
| summarize avg(CounterValue) by bin(TimeGenerated, 5m)
| render timechart
```

## Cleanup

### Remove SSH Keys
```bash
# Remove generated SSH keys
rm -f ~/.ssh/mkb_infrastructure_key*
```

### Destroy Infrastructure
```bash
# Destroy all resources
terraform destroy -var-file="terraform.tfvars"
```

## Security Notes

- SSH keys are generated locally and stored in `~/.ssh/`
- Private keys have 600 permissions (owner read/write only)
- SSH access is only available through the load balancer
- NSG rules restrict SSH to port 22 from your IP range

## Support

For issues with:
- **Infrastructure**: Check Terraform plan and apply outputs
- **SSH Access**: Verify NSG rules and VM status
- **Monitoring**: Check Azure Monitor alert rules and action groups
- **Stress Testing**: Ensure stress-ng is installed and working on target VMs