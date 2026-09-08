# Consegna UD02 — Laboratorio autonomo

## Requisito e piano

Ho scelto un resource group dedicato (`rg-cea-ud02-auto-`) perché se lo elimino sparisce tutto quello che contiene. La località è quella già verificata in Sezione 3, `italynorth`. VNet e storage account li creo entrambi ma per motivi diversi: la VNet serve per lo spazio di rete isolato richiesto dallo scenario, lo storage account invece è dove starebbero i dati, anche se qui restano vuoti. Ho messo gli stessi tag su entrambi (`course`, `unit`, `environment=dev`, `scenario=autonomous`, `deleteAfter`) così si capisce subito a cosa appartengono. Per il cleanup faccio come nel laboratorio guidato: lancio il comando di eliminazione, ma controllo anche con `az group exists` che il resource group non ci sia più.

## Svolgimento

Verificato il contesto prima di creare: `az account show` conferma la sottoscrizione attiva e abilitata.

Creato tutto da CLI, al contrario del laboratorio guidato:
- `az group create` per `rg-cea-ud02-auto-d37139f0`, in `italynorth`, con i 5 tag richiesti.
- `az network vnet create` per `vnet-cea-auto` (`10.30.0.0/16`) con subnet `snet-workload` (`10.30.10.0/24`).
- `az storage account create` per `stceaautod37139f0` (`StorageV2`, `Standard_LRS`, HTTPS only, TLS 1.2, accesso Blob pubblico disabilitato). Verificato con l'output del comando stesso: `ProvisioningState: Succeeded`.

Verifica indipendente da portale: aperto il resource group, VNet e storage account presenti con località e tag corretti, coincide con l'inventario da CLI (`az resource list --resource-group "$AUTO_RG"`).

ID delle risorse, anonimizzati prima di riportarli qui:

```
/subscriptions/<omitted>/resourceGroups/rg-cea-ud02-auto-d37139f0/providers/Microsoft.Network/virtualNetworks/vnet-cea-auto
/subscriptions/<omitted>/resourceGroups/rg-cea-ud02-auto-d37139f0/providers/Microsoft.Storage/storageAccounts/stceaautod37139f0
```

## Diagnosi

Nessun errore bloccante in questa parte. Osservazione utile: la subnet creata da CLI con `--subnet-prefix` valorizza il campo `addressPrefix` (singolare), mentre la stessa identica proprietà, quando creata da portale nel laboratorio guidato, valorizzava invece `addressPrefixes` (plurale) lasciando `addressPrefix` a `null`. Conferma che il campo popolato dipende da come la risorsa è stata creata, non è mai scontato quale dei due controllare.

## Cleanup e consegna

- risorse eliminate: `az group delete --name "$AUTO_RG" --yes --no-wait`, che elimina insieme resource group, VNet e storage account.
- controllo finale: `az group exists --name "$AUTO_RG"` → `false`.
- hash abbreviato e messaggio del commit: `3336378`, "Completa lo scenario Azure autonomo"
