# GitHub Actions Secrets Configuration Guide

This document describes how to configure the required secrets and variables for the GitHub Actions workflows.

## Required Secrets

### Azure Service Principal
Create an Azure Service Principal and add these secrets to your GitHub repository:

```bash
# Create a service principal
az ad sp create-for-rbac --name "github-actions-terraform" \
  --role="Contributor" \
  --scopes="/subscriptions/YOUR_SUBSCRIPTION_ID"
```

Add the following secrets in GitHub (Settings → Secrets and variables → Actions):

- `AZURE_CLIENT_ID` - Application (client) ID
- `AZURE_CLIENT_SECRET` - Client secret
- `AZURE_SUBSCRIPTION_ID` - Subscription ID  
- `AZURE_TENANT_ID` - Directory (tenant) ID

### Terraform State Backend
- `TF_STATE_RESOURCE_GROUP` - Resource group for Terraform state (e.g., "rg-terraform-state")
- `TF_STATE_STORAGE_ACCOUNT` - Storage account name (e.g., "terraformstateXXXXX")
- `TF_STATE_CONTAINER` - Container name (e.g., "tfstate")

### SSH Keys
- `SSH_PUBLIC_KEY` - SSH public key for VM access

## Environment Configuration

### Development Environment
- Auto-deploys on push to `develop` branch
- Uses `dev/terraform.tfstate` state file
- Resource group: `RG-MKB-Netwerk-Dev`

### Production Environment  
- Requires manual approval
- Deploys on push to `main` branch
- Uses `prod/terraform.tfstate` state file
- Resource group: `RG-MKB-Netwerk`

## Security Features

### Branch Protection
Configure branch protection rules:
- Require pull request reviews
- Require status checks to pass
- Require branches to be up to date
- Restrict pushes to specific branches

### Environment Protection
Configure environment protection rules in GitHub:
- Required reviewers for production
- Wait timer for production deployments
- Deployment branches restrictions

### Security Scanning
- **Checkov** - Terraform security scanning
- **TFLint** - Terraform linting
- **SARIF uploads** - Security findings in GitHub Security tab

## Workflow Files

- `terraform-ci-cd.yml` - Main CI/CD pipeline
- `destroy.yml` - Infrastructure destruction workflow
- `setup-backend.yml` - Terraform backend setup

## Setup Instructions

1. **Fork/Clone the repository**
2. **Setup Azure Service Principal** (see above)
3. **Configure GitHub Secrets** (see required secrets)
4. **Run backend setup workflow** (manually trigger)
5. **Push to develop branch** to test
6. **Create PR to main** for production deployment