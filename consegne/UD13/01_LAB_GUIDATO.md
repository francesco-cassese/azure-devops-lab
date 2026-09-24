# UD13 — Consegna LAB guidato

## Terraform

| Campo | Valore |
|---|---|
| `network.tf` | Ho copiato il file in `infra/terraform` e l'ho letto |
| plan | 4 to add, 0 to change, 0 to destroy |
| apply | `Apply complete! Resources: 4 added, 0 changed, 0 destroyed.` |
| VNet verificata | Sì, con Azure CLI: `vnet-ud13`, `10.13.0.0/16` |
| subnet verificata | Sì, con Azure CLI: `snet-app`, `10.13.1.0/24` |
| destroy | `Destroy complete! Resources: 4 destroyed.` |
| RG Terraform eliminato | Sì, `az group exists --name rg-ud12-tf` risponde `false` |

## Delivery persistente

| Campo | Valore |
|---|---|
| Resource Group | `rg-ud13-15-delivery` |
| service connection | `sc-azure-ud13-15` |
| WIF | Sì, Workload identity federation |
| scope | Sottoscrizione del corso, limitata al Resource Group `rg-ud13-15-delivery` |
| accesso globale a tutte le pipeline | NO |

## Pipeline

| Campo | Valore |
|---|---|
| YAML | `pipelines/azure-pipelines-iac.yml` |
| agent pool | `pool-ud09-wsl` |
| Validate | Riuscito |
| Deploy | Riuscito |
| What-If | `Resource changes: 1 to create.` |
| deployment | `ud13-delivery-2`, Succeeded |
| ACR | `acrud1315ayow4e4bcpd7c`, login server `acrud1315ayow4e4bcpd7c.azurecr.io` |
| SKU | Basic |
| admin user | False |

## Fine UD13

- risorse delivery conservate: sì
