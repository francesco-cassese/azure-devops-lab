# UD13 — Consegna LAB autonomo

| Campo | Valore |
|---|---|
| branch | `fix/ud13-pipeline-path` |
| path errato | `infra/bicep/delivery-NON-ESISTE.bicep` |
| stage | `Validate` (`Validate IaC`) |
| job | `ValidateIaC` (`Validate Terraform and Bicep`) |
| step | `Bicep lint` |
| messaggio | `ERROR: An error occurred reading file. Could not find file '.../infra/bicep/delivery-NON-ESISTE.bicep'.` |
| classe del problema | filesystem/path del repository |
| correzione | Ripristinato `infra/bicep/delivery.bicep` nel file pipeline |
| run finale | Validate riuscito, Deploy riuscito |
| PR/merge | PR verso `main`, diff verificato, merge completato |

## Dove è girato il Job

| Variabile | Valore |
|---|---|
| `Agent.Name` | `wsl-ud09-francesco` |
| `Agent.OS` | `Linux` |
| `Build.SourcesDirectory` | `.../azdo-agent/_work/1/s` |

Il job è girato sul mio WSL2 e ha scaricato il repository in quella cartella. Il lint ha cercato lì il file `delivery-NON-ESISTE.bicep`, che non esiste perché il file vero si chiama `delivery.bicep`. Per questo è fallito solo il passo `Bicep lint`, mentre Agent, checkout e Terraform erano andati bene: l'errore era nel percorso e non in Azure.
