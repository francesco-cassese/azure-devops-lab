# UD07 — Consegna laboratorio guidato

## CLI

| Campo | Risposta |
|---|---|
| prima esecuzione script | il gruppo `rg-ud07-cli-test` non c'era ancora. Lo script ha scritto "Il Resource Group non esiste: lo creo." e l'ha creato in `westeurope`. Ho controllato con `az group show` ed era `Succeeded` |
| seconda esecuzione | l'ho rilanciato e stavolta ha detto "esiste già: lo riutilizzo", senza crearne un secondo, ha solo riaggiornato i tag |
| comportamento idempotente | lo script controlla prima se il gruppo c'è già con `az group exists`, e lo crea solo se manca. Così anche rilanciandolo più volte non si creano copie doppie o errori inutili |
| esempio JMESPath | con quella query ho visto solo i 3 campi che mi servivano, non tutte le proprietà che dà normalmente `az group show` |
| quando usare `tsv` | `tsv` mi dà solo il valore, senza virgolette: utile quando lo devo mettere subito in una variabile. `table`/`json` li uso quando devo solo leggere io |

## PowerShell

| Campo | Risposta |
|---|---|
| `Get-AzContext` verificato | sì, prima di creare qualsiasi risorsa, senza scrivere ID nella consegna |
| Resource Group test | `rg-ud07-ps-test` (`westeurope`) |
| prima esecuzione | `Get-AzResourceGroup` non l'ha trovato, quindi `New-AzResourceGroup` l'ha creato. `Update-AzTag` ha aggiunto i tag. Stato finale: `Succeeded` |
| seconda esecuzione | stesso identico output della prima volta, nessun secondo gruppo creato |
| perché il controllo `if` è utile | senza quel controllo lo script proverebbe sempre a creare il gruppo, anche quando esiste già. Con `if (-not $rg)` lo crea solo se manca davvero |

## Log Analytics

| Campo | Risposta |
|---|---|
| workspace | `law-ud07-8629`. La CLI ha dovuto registrare da sola il resource provider `Microsoft.OperationalInsights`, perché non era ancora attivo sulla sottoscrizione |
| regione | `westeurope` non ha funzionato (stesso problema già visto in UD06). Ho usato `northeurope`, come dice la guida, ed è andata bene. Il workspace quindi è in una regione diversa dal resource group principale, ma va bene lo stesso: sono cose separate |
| query `print` | ho dovuto prima installare l'estensione `log-analytics` (me l'ha chiesta la CLI stessa). Poi la query ha funzionato subito, senza dati già raccolti: serve solo a controllare che login, workspace e motore KQL funzionino |
| query `datatable` | la query con `summarize Count=count() by Status` ha raggruppato i 3 record finti per stato: 2 righe `OK`, 1 riga `WARN` |
| risultato sintetico | entrambe le query hanno funzionato senza aspettare log reali, quindi il workspace va bene. I log veri li ho controllati dopo |

## Activity Log

| Campo | Risposta |
|---|---|
| evento osservato | "Update resource group", dopo aver cambiato il tag `LastChange=UD07` su `$LAB_RG` |
| status | Succeeded |
| timestamp | 2026-09-15T14:59:27Z |
| dati personali omessi | sì, non ho riportato il `Caller` |

## Diagnostic Setting

| Campo | Risposta |
|---|---|
| esito | l'ho creata dal Portale, sotto Monitor → Activity log → Export Activity Logs. Poi ho controllato da CLI che esistesse davvero |
| destinazione | il workspace `law-ud07-8629`, nel resource group `rg-ud07-monitor` (ho tolto il subscription ID prima di scriverlo qui) |
| AzureActivity disponibile | AzureActivity non ancora popolata nel time range osservato. Ho già verificato separatamente il workspace e l'Activity Log diretto, quindi non è il workspace a essere guasto: è solo la latenza di ingestion |
| fallback usato, se necessario | non mi è servito, la creazione dal Portale è andata bene al primo tentativo |

## Metrics

| Campo | Risposta |
|---|---|
| Storage Account | `stud0789484335` (`northeurope`) |
| metrica | `UsedCapacity` |
| unità | Bytes |
| aggregazione | Average |
| punto dati disponibile | no |
| interpretazione | lo storage account l'ho appena creato, quindi non c'è ancora un valore. Non ho cambiato metrica per forzare un numero: ho lasciato scritto che è supportata ma senza campione ancora |

## Alert

| Campo | Risposta |
|---|---|
| nome | `alert-ud07-storage-transactions` |
| scope corretto | sì, lo storage account `stud0789484335` |
| condition | Transactions, aggregazione Total, Greater than 0 |
| severity | 3 - Informational |
| Action Group | presente, `ag-ud07` (email personale, non scritta qui) |
| perché non è necessario che sia Fired | Enabled vuol dire che la regola è attiva. Fired vuol dire che è scattata davvero almeno una volta. La mia è Enabled ma non ha ancora avuto transazioni, quindi è normale che non sia mai Fired |

## Correlazione

| Campo | Risposta |
|---|---|
| modifica osservata | ho cambiato il tag `State` dello storage account in `Changed` |
| evento Activity Log | "Create/Update Storage Account", Succeeded, alle 16:25:22. La prima volta l'evento non c'era ancora, riprovando dopo qualche minuto è comparso |
| la correlazione prova causalità? | no |
| motivazione | ho fatto la modifica e poco dopo è comparso un evento con lo stesso nome. Sembra collegato, ma non è una prova sicura: l'evento non dice cosa è cambiato davvero, solo che è stata fatta una scrittura sulla risorsa. Ho visto anche due eventi simili vicini, quindi non posso essere certo al 100% che sia proprio quello del mio tag |

## Cleanup

| Campo | Risposta |
|---|---|
| diagnostic setting rimossa | sì, `ud07-activity-to-law` |
| RG CLI test eliminato | sì, `rg-ud07-cli-test`, confermato con `az group exists` → `false` |
| RG PowerShell test eliminato | sì, `rg-ud07-ps-test`, rimosso da Cloud Shell |
| RG principale eliminato | non ancora, di proposito: il laboratorio autonomo riusa lo stesso workspace, storage account e alert rule creati qui. Lo elimino solo dopo aver fatto anche l'autonomo e la verifica finale |
