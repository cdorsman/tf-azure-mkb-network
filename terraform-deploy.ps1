# Enhanced Terraform Deployment Script with Better Visibility
# This script provides clear module execution tracking with configurable parallelism

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("plan", "apply", "destroy", "validate")]
    [string]$Action = "plan",
    
    [Parameter(Mandatory=$false)]
    [ValidateRange(1, 10)]
    [int]$Parallelism = 2,
    
    [Parameter(Mandatory=$false)]
    [switch]$AutoApprove,
    
    [Parameter(Mandatory=$false)]
    [switch]$VerboseLogging,
    
    [Parameter(Mandatory=$false)]
    [string]$Environment = "development"
)

# Colors for better output
$Green = [System.ConsoleColor]::Green
$Yellow = [System.ConsoleColor]::Yellow
$Red = [System.ConsoleColor]::Red
$Cyan = [System.ConsoleColor]::Cyan
$Magenta = [System.ConsoleColor]::Magenta

function Write-ColorOutput {
    param([string]$Message, [System.ConsoleColor]$Color = [System.ConsoleColor]::White)
    Write-Host $Message -ForegroundColor $Color
}

function Show-Header {
    param([string]$Title)
    Write-Host ""
    Write-ColorOutput "===============================================" $Magenta
    Write-ColorOutput " $Title" $Magenta
    Write-ColorOutput "===============================================" $Magenta
    Write-Host ""
}

function Show-ModuleProgress {
    param([string]$ModuleName, [string]$Status)
    $timestamp = Get-Date -Format "HH:mm:ss"
    Write-ColorOutput "[$timestamp] [MODULE] $ModuleName - $Status" $Cyan
}

# Main execution
try {
    Show-Header "[DEPLOY] Terraform Deployment Script"
    
    Write-ColorOutput "[CONFIG] Configuration:" $Yellow
    Write-Host "   • Action: $Action"
    Write-Host "   • Parallelism: $Parallelism"
    Write-Host "   • Environment: $Environment"
    Write-Host "   • Auto Approve: $($AutoApprove.IsPresent)"
    Write-Host ""

    # Set logging if verbose
    if ($VerboseLogging) {
        $env:TF_LOG = "INFO"
        $logFile = "terraform-$Action-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
        $env:TF_LOG_PATH = $logFile
        Write-ColorOutput "[LOG] Verbose logging enabled: $logFile" $Yellow
    }

    # Initialize if needed
    if (-not (Test-Path ".terraform")) {
        Show-Header "[INIT] Terraform Initialization"
        Write-ColorOutput "Initializing Terraform..." $Yellow
        terraform init -backend=false
        if ($LASTEXITCODE -ne 0) { throw "Terraform init failed" }
    }

    # Validate configuration
    Show-Header "[VALIDATE] Terraform Validation"
    Write-ColorOutput "Validating Terraform configuration..." $Yellow
    terraform validate
    if ($LASTEXITCODE -ne 0) { throw "Terraform validation failed" }
    Write-ColorOutput "[SUCCESS] Configuration is valid!" $Green

    # Execute the requested action
    switch ($Action) {
        "plan" {
            Show-Header "[PLAN] Terraform Plan"
            Write-ColorOutput "Creating execution plan with parallelism=$Parallelism..." $Yellow
            terraform plan -parallelism $Parallelism -detailed-exitcode -out=tfplan
            
            if ($LASTEXITCODE -eq 0) {
                Write-ColorOutput "[SUCCESS] No changes needed!" $Green
            } elseif ($LASTEXITCODE -eq 2) {
                Write-ColorOutput "[INFO] Changes detected and planned!" $Yellow
            } else {
                throw "Terraform plan failed"
            }
        }
        
        "apply" {
            # First create a plan
            Show-Header "[PLAN] Terraform Plan (Pre-Apply)"
            Write-ColorOutput "Creating execution plan..." $Yellow
            terraform plan -parallelism $Parallelism -detailed-exitcode -out=tfplan
            
            if ($LASTEXITCODE -eq 0) {
                Write-ColorOutput "[SUCCESS] No changes needed!" $Green
                return
            } elseif ($LASTEXITCODE -ne 2) {
                throw "Terraform plan failed"
            }

            # Apply the plan
            Show-Header "[APPLY] Terraform Apply"
            Write-ColorOutput "[DEPLOY] Applying changes with parallelism=$Parallelism for better visibility..." $Yellow
            Write-ColorOutput "[INFO] Watch the module execution order below:" $Cyan
            Write-Host ""
            
            $applyCommand = "terraform apply -parallelism $Parallelism"
            if ($AutoApprove) {
                $applyCommand += " -auto-approve"
            }
            $applyCommand += " tfplan"
            
            Invoke-Expression $applyCommand
            if ($LASTEXITCODE -ne 0) { throw "Terraform apply failed" }
            
            Show-Header "[OUTPUT] Deployment Outputs"
            terraform output
        }
        
        "destroy" {
            Show-Header "[DESTROY] Terraform Destroy"
            Write-ColorOutput "[WARNING] This will destroy all resources!" $Red
            
            if (-not $AutoApprove) {
                $confirm = Read-Host "Are you sure you want to destroy all resources? (yes/no)"
                if ($confirm -ne "yes") {
                    Write-ColorOutput "[CANCELLED] Destroy cancelled by user" $Yellow
                    return
                }
            }
            
            Write-ColorOutput "[DESTROY] Destroying resources with parallelism=$Parallelism..." $Red
            $destroyCommand = "terraform destroy -parallelism $Parallelism"
            if ($AutoApprove) {
                $destroyCommand += " -auto-approve"
            }
            
            Invoke-Expression $destroyCommand
            if ($LASTEXITCODE -ne 0) { throw "Terraform destroy failed" }
        }
        
        "validate" {
            Show-Header "[VALIDATE] Extended Validation"
            
            Write-ColorOutput "Checking Terraform formatting..." $Yellow
            terraform fmt -check -recursive
            if ($LASTEXITCODE -ne 0) {
                Write-ColorOutput "[WARNING] Formatting issues found. Run 'terraform fmt -recursive' to fix." $Yellow
            } else {
                Write-ColorOutput "[SUCCESS] Formatting is correct!" $Green
            }
            
            Write-ColorOutput "Validating configuration..." $Yellow
            terraform validate
            if ($LASTEXITCODE -ne 0) { throw "Terraform validation failed" }
            Write-ColorOutput "[SUCCESS] Configuration is valid!" $Green
        }
    }

    Show-Header "[COMPLETE] Terraform $Action Completed Successfully!"
    
    if ($VerboseLogging -and $env:TF_LOG_PATH) {
        Write-ColorOutput "[LOG] Detailed logs available at: $env:TF_LOG_PATH" $Cyan
    }

} catch {
    Write-ColorOutput "[ERROR] Error: $($_.Exception.Message)" $Red
    exit 1
} finally {
    # Clean up environment variables
    if ($env:TF_LOG) { Remove-Item Env:TF_LOG -ErrorAction SilentlyContinue }
    if ($env:TF_LOG_PATH) { Remove-Item Env:TF_LOG_PATH -ErrorAction SilentlyContinue }
}