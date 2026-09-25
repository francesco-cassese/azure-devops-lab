# UD15 — Consegna LAB guidato

## Controlli iniziali

| Campo | Valore |
|---|---|
| ACR | `acrud1315...`, `italynorth`, Admin user `False` |
| `LegacyRegistryPermissions` | Sì |
| `sc-azure-ud13-15` | Esiste, Azure Resource Manager, Workload Identity federation |
| `AcrPush` | Assegnato al Service Principal di `sc-azure-ud13-15` sull'ACR |
| Storage state | Creato: `Standard_LRS`, `italynorth`, nome `sttf15` più 16 caratteri dell'ID sottoscrizione |
| container state | `tfstate`, accesso pubblico spento |
| `Storage Blob Data Contributor` | Assegnato a `sc-azure-ud13-15` sul solo container `tfstate` |
| managed identity | `id-ud15-acrpull`, creata in `italynorth` |
| `AcrPull` | Assegnato a `id-ud15-acrpull` sull'ACR |
| Agent | `pool-ud09-wsl` Online. Terraform 1.16.3, Azure CLI 2.90.0, Python 3.12.3, Docker 29.8.0, curl 8.5.0. `Microsoft.App` Registered |

## Terraform

| Campo | Valore |
|---|---|
| init | `terraform init -backend=false` riuscito: provider `azurerm` v5.4.0 e creato `.terraform.lock.hcl` |
| validate | `Success! The configuration is valid.` |
| plan iniziale | `Plan: 2 to add, 0 to change, 0 to destroy.` |
| apply | `Apply complete! Resources: 2 added, 0 changed, 0 destroyed.` |
| state remoto | `ud15.tfstate` presente |

## Pipeline

| Campo | Valore |
|---|---|
| Build ID | 19 |
| IaC | verde, 45s |
| Test | verde, 2s |
| BuildPush | verde, 1m 50s |
| Deploy | verde, 2m 8s |
| Smoke | verde, 36s |

## Deployment

| Campo | Valore |
|---|---|
| image tag | `catalog-backend:19`, il più recente in ACR |
| FQDN | `catalog-api-ud15.graysea-bf276583.italynorth.azurecontainerapps.io` |
| APP_VERSION | `19`, uguale al Build ID |
| revision | `catalog-api-ud15--8fkenyi`, attiva, Healthy, 1 replica |
| health | `status: ok`, `service: catalog-backend`, `version: 19` |
