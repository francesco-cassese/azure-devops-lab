# UD12 — Consegna LAB guidato

## Preparazione

| Campo | Valore |
|---|---|
| materiali UD12 | trovati in `~/workspace/corso-azure-devops/UD12/partecipanti` |
| repository personale | trovato, `~/workspace/azure-devops-lab` (repository Git) |
| directory `infra/bicep` | presente, contiene `main.bicep` |
| directory `infra/terraform` | presente, contiene `main.tf`, `outputs.tf`, `providers.tf`, `variables.tf`, `versions.tf` |
| directory consegne | presente, contiene i 4 modelli copiati: `00_DOMANDE_CONCETTI.md`, `01_LAB_GUIDATO.md`, `02_LAB_AUTONOMO.md`, `03_VERIFICA.md` |

## Azure

| Campo | Valore |
|---|---|
| subscription verificata | OK, ho controllato con `az account show` di essere sulla subscription giusta: "Azure subscription 1" |
| identità verificata | OK, francescocassese9@gmail.com |

## Bicep

| Campo | Valore |
|---|---|
| Bicep version | 0.47.16 |
| lint | pulito, non mostra errori |
| Resource Group | rg-ud12-bicep |
| Storage Account | stud12b90070480 |
| What-If change type | La risorsa prevista è uno Storage Account (`Microsoft.Storage/storageAccounts`), il tipo di modifica è "Create" perché non esiste ancora, con il nome `stud12b90070480`. Il primo tentativo è fallito perché la regione `westeurope` non accettava nuove risorse su questa subscription; corretto passando a `italynorth` |
| deployment | ud12-bicep-deploy |
| output `storageAccountName` | stud12b90070480 |
| output `blobEndpoint` | https://stud12b90070480.blob.core.windows.net/ |
| verifica CLI | Ho controllato con Azure CLI che la risorsa creata corrisponda a quanto dichiarato nel file Bicep. Lo Storage Account `stud12b90070480` è nella regione `italynorth`, con SKU `Standard_LRS`, TLS minimo `TLS1_2` e accesso pubblico ai Blob disattivato, come previsto |
| Resource Group Bicep eliminato | sì, con `az group delete`, il comando che elimina il Resource Group e tutto quello che contiene in un colpo solo |
| `az group exists` | `false` |

## Terraform

| Campo | Valore |
|---|---|
| Terraform version | v1.16.3 |
| provider AzureRM | v5.6.0 (vincolo `~> 5.4` in `versions.tf`, rispettato) |
| `terraform init` | OK, provider installato e creato `.terraform.lock.hcl` |
| `terraform fmt -check` | eseguito, senza errori |
| `terraform validate` | Success! |
| plan add | Il primo piano, con regione `westeurope`, prevedeva 2 risorse da creare, ma l'apply è fallito sullo Storage Account per lo stesso problema di regione già visto nel Bicep. Il Resource Group `rg-ud12-tf` si era comunque creato correttamente. Corretto passando alla regione `italynorth`: il nuovo piano prevede ancora 2 risorse da creare, lo Storage Account nuovo e il Resource Group ricreato |
| plan change | 0, in entrambi i piani |
| plan destroy | 0 nel primo piano. 1 nel piano corretto, perché il Resource Group deve essere eliminato e ricreato: la regione di un Resource Group già esistente non si può cambiare sul posto |
| apply | complete |
| output Resource Group | rg-ud12-tf |
| output Storage | stud12t90072691 |
| verifica CLI | Ho controllato con Azure CLI che le risorse create corrispondano a quanto dichiarato nel codice. Il Resource Group `rg-ud12-tf` risulta nella regione `italynorth`, con i tag giusti. Lo Storage Account `stud12t90072691` è anch'esso in `italynorth`, con lo SKU `Standard_LRS` come previsto |
| `terraform state list` | Sono comparse le due risorse gestite da Terraform, come atteso: `azurerm_resource_group.lab` e `azurerm_storage_account.lab` |

## Fine LAB guidato

- risorse Terraform mantenute per LAB autonomo: sì, non è stato eseguito `terraform destroy`; `rg-ud12-tf`.
