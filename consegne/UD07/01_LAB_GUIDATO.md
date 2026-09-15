# UD07 — Consegna laboratorio guidato

## CLI

| Campo | Risposta |
|---|---|
| prima esecuzione script | il resource group `rg-ud07-cli-test` non esisteva. Lo script ha scritto "Il Resource Group non esiste: lo creo." e l'ha creato in `westeurope`. Ho controllato con `az group show` che lo stato fosse `Succeeded` |
| seconda esecuzione | ho rilanciato lo stesso script. Questa volta ha scritto "Il Resource Group esiste già: lo riutilizzo." e non ha creato un secondo gruppo, ha solo riaggiornato i tag |
| comportamento idempotente | lo script prima controlla se il resource group esiste già (`az group exists`), e lo crea solo se manca. Così anche rieseguendolo più volte non si creano copie doppie e non si rischiano errori inutili |
| esempio JMESPath | con `--query "{Name:name,Location:location,Provisioning:properties.provisioningState}"` ho visto solo i tre campi che mi servivano, invece di tutte le proprietà che `az group show` restituisce normalmente |
| quando usare `tsv` | ho confrontato `--output tsv` (dà solo `rg-ud07-monitor`, senza virgolette) con `--output json` (dà `"rg-ud07-monitor"`, con le virgolette). Uso `tsv` quando mi serve un valore semplice da mettere subito in una variabile; `table`/`json` quando devo solo leggere l'output io |

## PowerShell

| Campo | Risposta |
|---|---|
| `Get-AzContext` verificato | sì, prima di creare qualsiasi risorsa, senza scrivere ID nella consegna |
| Resource Group test | `rg-ud07-ps-test` (`westeurope`) |
| prima esecuzione | `Get-AzResourceGroup` non ha trovato il gruppo, quindi `New-AzResourceGroup` l'ha creato. `Update-AzTag` ha aggiunto i tag. Stato finale: `Succeeded` |
| seconda esecuzione | stesso identico output della prima volta, nessun secondo gruppo creato |
| perché il controllo `if` è utile | senza quel controllo lo script proverebbe sempre a creare il resource group, anche quando esiste già. Con `if (-not $rg)` lo crea solo se manca davvero |

## Log Analytics

| Campo | Risposta |
|---|---|
| workspace | `law-ud07-8629`, creato con `az monitor log-analytics workspace create`. La prima volta la CLI ha dovuto registrare da sola il resource provider `Microsoft.OperationalInsights`, perché non era ancora attivo sulla sottoscrizione |
| regione | `westeurope` non ha funzionato ("currently not accepting new customers", stesso problema già visto in UD06). Ho usato `northeurope`, come indicato dalla guida, e questa volta è andata bene. Il workspace è quindi in una regione diversa dal resource group principale, ma va bene: un resource group può contenere risorse di regioni diverse |
| query `print` | ho dovuto prima installare l'estensione CLI `log-analytics` (me lo ha chiesto la CLI stessa). Poi `print Course='AZ-104', UD=7, Status='OK'` ha funzionato subito, senza bisogno di dati già raccolti: serve solo a controllare che login, workspace e motore KQL funzionino |
| query `datatable` | la query con `datatable` e `summarize Count=count() by Status` ha raggruppato correttamente i 3 record finti per stato: 2 righe `OK`, 1 riga `WARN` |
| risultato sintetico | entrambe le query hanno funzionato senza aspettare log reali, quindi il workspace e il motore di query vanno bene. I log veri (Activity Log) li controllo nei prossimi passi |

## Activity Log

| Campo | Risposta |
|---|---|
| evento osservato | "Update resource group", dopo aver modificato il tag `LastChange=UD07` su `$LAB_RG` con `az group update` |
| status | Succeeded |
| timestamp | 2026-09-15T14:59:27Z |
| dati personali omessi | sì, non ho riportato il `Caller` |

## Diagnostic Setting

| Campo | Risposta |
|---|---|
| esito | l'ho creata dal Portale, sotto Monitor → Activity log → Export Activity Logs. Poi ho controllato da CLI che esistesse davvero |
| destinazione | il workspace `law-ud07-8629`, nel resource group `rg-ud07-monitor` (ho tolto il subscription ID dall'ID completo prima di scriverlo qui) |
| AzureActivity disponibile | AzureActivity non ancora popolata nel time range osservato. Ho già verificato separatamente il workspace (query sintetiche) e l'Activity Log diretto, quindi non è il workspace a essere guasto: è solo la latenza di ingestion |
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
| modifica osservata | ho cambiato il tag `State` dello storage account in `Changed` con `az storage account update` |
| evento Activity Log | "Create/Update Storage Account", Succeeded, alle 16:25:22. La prima volta che ho controllato l'evento non c'era ancora (stesso ritardo già visto con l'Activity Log del resource group), riprovando dopo qualche minuto è comparso |
| la correlazione prova causalità? | no |
| motivazione | ho fatto la modifica e poco dopo è comparso un evento con lo stesso nome ("Create/Update Storage Account"). Sembra collegato, ma non è una prova sicura: l'evento non dice cosa è cambiato davvero, solo che è stata fatta una scrittura sulla risorsa. In più ho visto due eventi simili vicini nel tempo, quindi non posso essere certo al 100% che sia proprio quello del mio tag e non un altro |

## Cleanup

| Campo | Risposta |
|---|---|
| diagnostic setting rimossa | sì, `ud07-activity-to-law` eliminata con `az monitor diagnostic-settings subscription delete` |
| RG CLI test eliminato | sì, `rg-ud07-cli-test`, confermato con `az group exists` → `false` |
| RG PowerShell test eliminato | sì, `rg-ud07-ps-test`, rimosso con `Remove-AzResourceGroup -Force` da Cloud Shell |
| RG principale eliminato | rimandato di proposito: il laboratorio autonomo (Attività 4, 5, 6) riusa lo stesso workspace, storage account e alert rule creati qui. Lo elimino solo dopo aver fatto anche l'autonomo e la verifica finale, come dice esplicitamente la consegna dell'autonomo |
