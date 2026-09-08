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
| Storage account | | | | |

## Decisioni e verifiche

*(sezione da completare con le altre risorse — per ora la differenza osservata tra portale e CLI)*

La differenza più chiara che ho notato finora è sul virtual network. Sul portale la subnet era creata bene, con l'intervallo giusto (`10.20.1.0/24`) visibile a schermo. Ma controllando da riga di comando con la query suggerita dalla guida, il campo del prefisso usciva vuoto (`null`). All'inizio ho pensato di aver sbagliato qualcosa nella creazione. In realtà la risorsa era corretta: Azure oggi salva quel dato in un campo diverso (`addressPrefixes`, con la "s") rispetto a quello usato dalla query della guida (`addressPrefix`, senza "s"). Cambiando il nome del campo nella query, il valore giusto è comparso. Anche la documentazione Microsoft dice di usare sempre `addressPrefixes` (fonte: https://learn.microsoft.com/en-us/azure/virtual-network/how-to-multiple-prefixes-subnet). Questa cosa mi ha fatto capire perché nel laboratorio si ricontrolla sempre da CLI quello che si fa da portale: a volte il portale è aggiornato ma il comando che uso per controllare no.

## Cleanup

- operazione di eliminazione:
- controllo utilizzato:
- risultato finale:
- eventuale anomalia e soluzione:

## Rilevanza professionale

Spiega come inventario, tag e verifica del cleanup rendono una procedura ripetibile e controllabile.
