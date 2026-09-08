# Consegna UD02 — Laboratorio guidato

## Contesto verificato

- Azure Portal accessibile: sì, ho fatto il login su portal.azure.com con il mio account e vedo la sottoscrizione del laboratorio nell'elenco.
- Azure CLI autenticata: sì, avevo già fatto il login in UD01 (`az login --use-device-code`) e risultava ancora attivo, confermato con `az account show`.
- sottoscrizione corretta verificata senza pubblicarne l'ID: controllata con `az account show --output table`, il nome della sottoscrizione corrisponde a quella assegnata al laboratorio; non riporto l'ID come richiesto.
- località scelta e motivo: `italynorth`, perché risultava disponibile per la mia sottoscrizione (verificato con `az account list-locations`) ed è la prima opzione indicata dal laboratorio, quindi non ho dovuto usare l'alternativa `westeurope`.

## Ambiente creato

| Elemento | Nome tecnico | Tipo | Località | Scopo |
|---|---|---|---|---|
| Resource group | rg-cea-ud02-e385bc0c | Resource group | Italy North | Contenitore dedicato al laboratorio UD02, così l'eliminazione finale rimuove tutto insieme senza toccare altre risorse |
| Rete virtuale | vnet-cea-ud02 | Virtual network (10.20.0.0/16) con subnet snet-app (10.20.1.0/24) | Italy North | Spazio di rete logico dedicato al laboratorio, per osservare struttura e proprietà prima di usarla davvero |
| Storage account | stceae385bc0c | Storage account (StorageV2, Standard_LRS) | Italy North | Storage vuoto dedicato al laboratorio, con accesso Blob pubblico disabilitato e TLS minimo 1.2 |

## Decisioni e verifiche

Confrontato anche l'elenco "Resources" del resource group nel portale con l'inventario CLI: stesse risorse, stessi tipi. La "JSON View" di una risorsa mostra la stessa struttura dell'ID già vista in forma anonimizzata da CLI.

La differenza principale tra portale e CLI: sulla virtual network, il portale mostrava la subnet corretta (`10.20.1.0/24`), ma la query CLI della guida (`addressPrefix`) restituiva `null`. Causa: Azure ora usa il campo `addressPrefixes` (plurale) per le subnet create con la UI più recente — le due proprietà non sono intercambiabili (fonte: [documentazione Microsoft](https://learn.microsoft.com/en-us/azure/virtual-network/how-to-multiple-prefixes-subnet)). Corretta la query, il valore è comparso.

Anche per lo storage account il portale era più aggiornato della guida: campo "Primary service" mai citato (lasciato sul default, general purpose v2) e, nel riepilogo finale, i tag sembravano coinvolgere anche una virtual network e un private endpoint mai richiesti. Verificato scaricando il template ARM proposto dal portale: conteneva solo lo storage account, nessun'altra risorsa.

## Cleanup

- operazione di eliminazione: `az group delete --name "$LAB_RG" --yes --no-wait`, seguito da `az group wait --name "$LAB_RG" --deleted` per attendere il completamento.
- controllo utilizzato: `az group exists --name "$LAB_RG"`.
- risultato finale: `false`, resource group eliminato insieme a virtual network e storage account che conteneva.
- eventuale anomalia e soluzione: al primo tentativo, `az group delete` ha restituito l'errore `AADSTS530035: Access has been blocked by security defaults`, ripresentatosi anche rifacendo il login con `az login --use-device-code`. Risolto rifacendo il login con `az login` normale (senza device code): l'accesso è tornato disponibile, confermato con `az account show`, e da lì il cleanup è andato a buon fine.

## Rilevanza professionale

Il cleanup non è completo solo lanciando il comando di eliminazione (`az group delete`): lo è quando si verifica che la risorsa non esiste più (`az group exists`). I tag facilitano inventario (`az resource list`), governance e analisi dei costi, dando un contesto a ogni risorsa senza doverlo ricordare a mente.
