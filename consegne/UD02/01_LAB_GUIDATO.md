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
| Rete virtuale | | | | |
| Storage account | | | | |

## Decisioni e verifiche

Descrivi perché le risorse appartengono allo stesso resource group, quali responsabilità rimangono al cliente, perché sono stati applicati nomi e tag e quale differenza hai osservato tra portale e CLI. Riporta soltanto comandi essenziali e output anonimizzati.

## Cleanup

- operazione di eliminazione:
- controllo utilizzato:
- risultato finale:
- eventuale anomalia e soluzione:

## Rilevanza professionale

Spiega come inventario, tag e verifica del cleanup rendono una procedura ripetibile e controllabile.
