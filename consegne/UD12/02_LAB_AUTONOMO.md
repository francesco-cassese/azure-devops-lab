# UD12 — Consegna LAB autonomo

## Baseline

| Campo | Valore |
|---|---|
| `terraform plan` | La prima volta non avevo ricaricato nel terminale `TF_VAR_location` a `italynorth` nella shell nuova, quindi il piano voleva ricreare sia il Resource Group che lo Storage Account per spostarli su `westeurope`, che è il valore di default del file. Ho ricaricato la variabile e ho rilanciato il comando |
| stato atteso | `No changes.`, perché nessuno ha modificato le risorse manualmente dopo il lab guidato |
| stato osservato | `No changes. Your infrastructure matches the configuration.`, confermato dopo la correzione: codice, state e Azure sono coerenti |

## Modifica

| Campo | Valore |
|---|---|
| tag aggiunto | `Environment = "Training"`. La prima volta l'ho scritto nel posto sbagliato, nel blocco tag del Resource Group invece che in quello dello Storage Account, e infatti il piano mi mostrava solo il Resource Group da aggiornare, poi dopo l'apply `az storage account show` non lo trovava. L'ho spostato nel blocco giusto e rifatto plan e apply |
| plan add | 0 |
| plan change | 2 dopo la correzione, uno perché il Resource Group perde il tag e uno perché lo Storage Account lo prende. La prima volta, col tag nel posto sbagliato, il piano ne mostrava solo 1 |
| plan destroy | 0 |
| motivazione change e non recreate | Perché il tag non è una caratteristica essenziale della risorsa, è solo un'informazione in più attaccata sopra, quindi Terraform la aggiorna senza toccare la risorsa vera e propria |

## Apply e verifica

| Campo | Valore |
|---|---|
| apply | andato bene dopo la correzione, `0 added, 2 changed, 0 destroyed` |
| tag verificato con Azure CLI | controllato con `az storage account show --query tags`, il tag `Environment: "Training"` c'è insieme agli altri tre |

## Errore controllato

| Campo | Valore |
|---|---|
| riferimento errato | `location = azurerm_resource_group.training.location` |
| messaggio `terraform validate` | `Error: Reference to undeclared resource` |
| causa | `A managed resource "azurerm_resource_group" "training" has not been declared in the root module`, cioè quella risorsa non esiste da nessuna parte nel file, l'ho scritta sbagliata io |
| correzione | ripristinato `location = azurerm_resource_group.lab.location` |
| validate finale | `Success! The configuration is valid.` |

## Git

| Campo | Valore |
|---|---|
| `.gitignore` verificato | ha già `.terraform/`, `*.tfstate`, `*.tfstate.*`, `*.tfplan`, li avevo aggiunti durante il lab guidato |
| state non committato | controllato con `git status`, nessuno stato o piano tra i file, solo `main.tf` in staging |
| lock file | `.terraform.lock.hcl` era già committato a parte, prima di iniziare questo lab |
| commit | ho staged solo `main.tf`, controllato il diff prima di confermare, `Move Environment tag to the Storage Account resource` |
| push/PR | pushato direttamente su `main`|

## Cleanup Terraform

| Campo | Valore |
|---|---|
| `terraform plan -destroy` | `Plan: 0 to add, 0 to change, 2 to destroy` |
| risorse previste | solo `azurerm_resource_group.lab` e `azurerm_storage_account.lab`, niente di più |
| `terraform destroy` | Destroy complete! Resources: 2 destroyed. |
| `az group exists` | false |
| `terraform state list` finale | vuota |

## Elementi conservati per UD13–UD15

| Campo | Valore |
|---|---|
| Bicep | installato in WSL2 (`az bicep`, v0.47.16) |
| Terraform | installato in WSL2 (v1.16.3, repository ufficiale HashiCorp)|
| file IaC | `infra/bicep/main.bicep` e i cinque file `infra/terraform/*.tf`, tutti committati nel repository|
| agent configurato | controllato dal portale, `Organization settings → Agent pools → pool-ud09-wsl → Agents`: `wsl-ud09-francesco` risulta **Offline** ma ancora presente.
