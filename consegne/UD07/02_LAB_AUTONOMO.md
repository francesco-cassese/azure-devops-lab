# UD07 — Consegna laboratorio autonomo

## 1. Script CLI idempotente

| Campo | Risposta |
|---|---|
| logica | controllo prima con `az group exists` se `rg-ud07-auto` c'è già. Se non c'è lo creo, se c'è lo riuso. Fuori dall'if/else aggiorno comunque i tag e mostro nome/location/stato |
| prima esecuzione | ha scritto "non esiste: lo creo" e l'ha creato in `italynorth`, stato `Succeeded` |
| seconda esecuzione | ha scritto "esiste già: lo riutilizzo", nessun secondo gruppo creato, stesso stato `Succeeded` |
| verifica | `az group show` ha confermato nome, location e stato in entrambe le esecuzioni |

## 2. PowerShell equivalente

| Campo | Risposta |
|---|---|
| controllo esistenza | `Get-AzResourceGroup` con `-ErrorAction SilentlyContinue`, stessa logica dello script Bash ma con un oggetto invece di una stringa |
| modifica | `New-AzResourceGroup` solo se `$rg` è vuoto, poi `Update-AzTag` per i tag |
| output | prima volta: creato `rg-ud07-auto-ps`, `Succeeded`, tag giusti. Seconda volta: stesso identico output, nessun secondo gruppo |

## 3. Activity Log

| Campo | Risposta |
|---|---|
| operazione | "Update resource group" su `rg-ud07-auto`. Ho visto 3 coppie di eventi: uno per la creazione, due per i due aggiornamenti tag (uno per esecuzione dello script) |
| status | Succeeded |
| timestamp | 2026-09-15T17:15:20Z |

## 4. KQL

| Domanda | Risposta |
|---|---|
| 1. quante righe aggregate produce? | 2, una per `OK` e una per `WARN` |
| 2. quale stato ha latenza media più alta? | `WARN` (470 contro 150 di `OK`) |
| 3. perché `summarize` cambia la granularità dei dati? | prima avevo 4 righe, una per evento. Dopo ne ho solo 2, una per `Status`: raggruppa invece di mostrare tutto singolarmente |

## 5. Metrics

| Campo | Risposta |
|---|---|
| metrica | `Transactions` (diversa da `UsedCapacity`, già usata nel guidato) |
| unità | Count |
| aggregazione | Total |
| dato presente | sì, `0.0` |
| interpretazione | zero ha senso: non ho ancora caricato o letto niente su quello storage account. Creare la risorsa e cambiare un tag sono solo operazioni di gestione, non contano come transazioni |

## 6. Alert

| Campo | Risposta |
|---|---|
| scope | lo storage account `stud0789484335` |
| condition | Transactions, Total, Greater than 0 — quella già configurata nel guidato, non l'ho toccata |
| severity | 3 |
| evaluation frequency | `PT1M`, ogni minuto |
| Action Group | presente, `ag-ud07` |
| Enabled vs Fired | `Enabled: true` vuol dire solo che la regola è attiva e viene controllata ogni minuto. Non vuol dire che sia mai scattata: vuol dire solo che è pronta a scattare se serve |

## 7. Guasto amministrativo

| Campo | Risposta |
|---|---|
| sintomo | `az group show` su un nome inventato fallisce |
| errore | `ResourceGroupNotFound: Resource group 'rg-ud07-NON-ESISTE' could not be found.` |
| ipotesi | nome sbagliato, oppure il gruppo esiste ma in un'altra subscription |
| controllo | `az account show` per la subscription attiva, poi `az group list` per vedere quali gruppi esistono davvero |
| correzione | usare il nome giusto tra quelli elencati — non creare quello inventato, era sbagliato apposta |
| verifica | `az group show` con il nome giusto funziona senza errori |

## 8. Runbook

### Sintomo

Un comando su una risorsa (resource group, storage account, ecc.) fallisce con un errore tipo "non trovato", invece di dare i dati che ci si aspetta.

### Contesto

Prima di cambiare qualsiasi configurazione, controllare di essere loggati con l'account giusto e nella subscription giusta: spesso un "risorsa non trovata" è solo un problema di contesto, non una risorsa che manca davvero.

### Controlli

1. account e subscription: `az account show --query "{Name:name,State:state}" --output table`
2. nome esatto del resource group: `az group list --query "[].name" --output table`
3. nome esatto della risorsa dentro il gruppo giusto: `az resource list --resource-group <nome> --output table`

### Comandi

```bash
az account show --query "{Name:name,State:state}" --output table
az group list --query "[].name" --output table
az resource list --resource-group <nome-corretto> --output table
```

### Interpretazione

- subscription sbagliata → cambiarla con `az account set`, senza toccare altro
- il nome del gruppo non compare nella lista → il nome era sbagliato, non manca una risorsa da creare
- il gruppo c'è ma la risorsa no → controllare che il nome sia scritto esattamente uguale (maiuscole, trattini)

### Correzione minima

Ripetere il comando con il nome giusto, senza creare niente di nuovo e senza cambiare subscription se non era davvero quello il problema.

### Verifica

Il comando, con il nome giusto, deve andare senza errori.

### Cleanup

Non ho creato nessuna risorsa per sbaglio durante la diagnosi, quindi niente da ripulire in più.

## 9. Cleanup

| Campo | Risposta |
|---|---|
| rg-ud07-auto | eliminato, confermato con `az group exists` → `false` |
| rg-ud07-auto-ps | eliminato, confermato con `az group exists` → `false` |
