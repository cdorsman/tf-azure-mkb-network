# MKB Azure Network Infrastructure

Dit Terraform project implementeert een complete netwerk- en serverinfrastructuur in Azure voor een MKB-organisatie, inclusief een Virtual Network met subnetten en een schaalbare webserveromgeving.

## Overzicht

Het project creëert de volgende Azure resources:

### 1. Netwerkinfrastructuur
- **Resource Group**: RG-MKB-Netwerk in West-Europa
- **Virtual Network**: 10.0.0.0/16 adresbereik
- **Subnetten**:
  - WebSubnet: 10.0.1.0/24
  - AppSubnet: 10.0.2.0/24
  - DBSubnet: 10.0.3.0/24
  - AzureBastionSubnet: 10.0.4.0/24

### 2. Beveiliging
- **Network Security Groups** met regels voor:
  - HTTP (80) en HTTPS (443) verkeer naar WebSubnet
  - MySQL (3306) verkeer van AppSubnet naar DBSubnet
  - SSH toegang voor beheer

### 3. Compute Resources
- **Virtual Machine Scale Set** met:
  - Ubuntu Server 22.04 LTS
  - Automatische schaling (1-3 instanties)
  - CPU-gebaseerde schaling (70% omhoog, 30% omlaag)
  - NGINX webserver voorgeïnstalleerd
  - Load balancer met publiek IP

### 4. Connectiviteit
- **Azure Bastion** voor veilige SSH toegang
- **Load Balancer** voor webverkeer distributie

## Modulaire Structuur

Het project is opgedeeld in de volgende modules:

```
modules/
├── resource-group/    # Azure Resource Group
├── networking/        # VNet en subnetten
├── security/         # Network Security Groups
├── vmss/             # Virtual Machine Scale Set
└── bastion/          # Azure Bastion (optioneel)
```

## Vereisten

1. **Azure CLI** geïnstalleerd en ingelogd
2. **Terraform** >= 1.0 geïnstalleerd
3. **SSH key pair** gegenereerd

## Installatie en Gebruik

### Stap 1: SSH Key Genereren
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/mkb_key
```

### Stap 2: Configuratie
```bash
# Kopieer de example file
cp terraform.tfvars.example terraform.tfvars

# Bewerk terraform.tfvars en voeg je SSH public key toe
notepad terraform.tfvars
```

### Stap 3: Terraform Initialiseren
```bash
terraform init
```

### Stap 4: Plan Bekijken
```bash
terraform plan
```

### Stap 5: Infrastructuur Deployen
```bash
terraform apply
```

### Stap 6: Outputs Bekijken
```bash
terraform output
```

## Testing

### Webserver Testen
Na deployment kun je de webserver testen via:
```bash
# Verkrijg de public IP
terraform output web_url
```

### Autoscaling Testen
SSH naar een VM via Azure Bastion en voer het stress test script uit:
```bash
# Via Azure Portal -> Bastion, of via Azure CLI
./stress_test.sh
```

### Connectiviteit Testen
Gebruik Azure Bastion om SSH verbindingen te maken tussen de subnetten en test de connectiviteit.

## Configuratie Opties

### terraform.tfvars Variabelen
```hcl
resource_group_name    = "RG-MKB-Netwerk"
location              = "West Europe"
vnet_name             = "mkb-vnet"
admin_ssh_public_key  = "ssh-rsa AAAAB3N..."
enable_bastion        = true
```

### VMSS Autoscaling Parameters
- **Min instances**: 1
- **Max instances**: 3
- **Scale out**: CPU > 70% gedurende 5 minuten
- **Scale in**: CPU < 30% gedurende 5 minuten

## Kosten Optimalisatie

- Gebruik `Standard_B1s` VM's voor kosteneffectiviteit
- Schakel Azure Bastion uit (`enable_bastion = false`) als het niet nodig is
- Monitor resource gebruik via Azure Cost Management

## Beveiliging

- SSH keys in plaats van wachtwoorden
- Network Security Groups beperken verkeer
- Azure Bastion voor veilige toegang
- Geen directe internet toegang tot App/DB subnetten

## Troubleshooting

### Veelvoorkomende Problemen
1. **SSH Key Error**: Zorg dat de SSH public key correct geformatteerd is
2. **Resource Conflicts**: Controleer of resource namen uniek zijn
3. **Quota Limits**: Controleer Azure subscription limits

### Logs Bekijken
```bash
# Terraform logs
export TF_LOG=DEBUG
terraform apply

# Azure Activity Log
az monitor activity-log list --resource-group RG-MKB-Netwerk
```

## GitHub Actions CI/CD

Dit project bevat een complete CI/CD pipeline met GitHub Actions voor geautomatiseerde deployments.

### 🔄 Workflows

1. **terraform-ci-cd.yml** - Hoofdpipeline
   - Validatie en security scanning
   - Automatische deployment naar development
   - Handmatige approval voor production

2. **destroy.yml** - Infrastructuur vernietiging
   - Veilige vernietiging van environments
   - Dubbele bevestiging vereist

3. **setup-backend.yml** - Backend configuratie
   - Eenmalige setup van Terraform state storage

### 🔐 Vereiste Secrets

Configureer de volgende secrets in GitHub (Settings → Secrets):

```
AZURE_CLIENT_ID         # Service Principal Client ID
AZURE_CLIENT_SECRET     # Service Principal Secret
AZURE_SUBSCRIPTION_ID   # Azure Subscription ID
AZURE_TENANT_ID         # Azure Tenant ID
TF_STATE_RESOURCE_GROUP # Terraform state resource group
TF_STATE_STORAGE_ACCOUNT # Terraform state storage account
TF_STATE_CONTAINER      # Terraform state container
SSH_PUBLIC_KEY          # SSH public key voor VMs
```

### 🌍 Environments

- **Development**: Auto-deploy op `develop` branch
- **Production**: Manual approval op `main` branch

### 🛡️ Security Features

- **Branch protection** met required reviews
- **Security scanning** met Checkov en TFLint
- **Environment protection** met manual approvals
- **Terraform plan** review in PRs

### 📋 Setup Workflow

1. Fork/clone repository
2. Configureer Azure Service Principal
3. Setup GitHub secrets
4. Trigger backend setup workflow
5. Push naar develop branch voor testing

Zie `.github/SECURITY.md` voor gedetailleerde setup instructies.

## Cleanup

### Via Terraform
```bash
terraform destroy
```

### Via GitHub Actions
Gebruik de "Destroy Infrastructure" workflow in de Actions tab.

## Support

Voor vragen of problemen, raadpleeg de Azure documentatie of maak een issue aan in dit repository.