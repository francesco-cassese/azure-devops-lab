# Consegna UD04 — Laboratorio autonomo

## Scelta del servizio e della ridondanza

Ho scelto Blob perché devo salvare documenti e farli leggere agli utenti senza account key, quindi mi serve un URL per ogni file. Files è per una cartella di rete vera, non serve qui. Queue è per messaggi corti tra due sistemi, non per conservare documenti. Table è per righe con colonne fisse, un documento non ha quella forma. Blob invece salva oggetti come i miei file, ognuno con il suo percorso.

LRS replica solo nella stessa region, ZRS replica su zone diverse della stessa region. Se il requisito è resistere a un guasto zonale, in produzione userei ZRS, perché solo ZRS protegge da quel tipo di guasto. Nel laboratorio invece uso LRS perché i dati sono temporanei e verranno eliminati a fine esercitazione, quindi non ha senso pagare di più per una ridondanza che qui non serve.

## Operazioni e verifica

Ho creato il container `archive` da CLI, con `--auth-mode login`, tutto ok. Poi ci ho caricato dentro una copia del documento del lab, come `current/documento.txt`. Ho controllato che fosse a posto: BlockBlob, tier Hot, 49 byte, text/plain, tutto corretto. Poi ho fatto una SAS solo in lettura, che dura 15 minuti, giusto per testare che il file si scaricasse davvero: ho usato `curl` per scaricarlo e `cmp` per confrontarlo con l'originale, ed erano uguali. Alla fine ho tolto subito la variabile della SAS, non l'ho lasciata in giro.

## Diagnosi

**Errore 1: `AuthorizationPermissionMismatch`**
Sintomo: l'operazione viene rifiutata con questo messaggio.
Piano: data plane, non management plane.
Causa: manca un ruolo RBAC sul data plane (es. Storage Blob Data Reader o Contributor), anche se magari si ha già Contributor sullo storage account, che è un ruolo diverso.
Controllo: `az role assignment list --assignee <id> --scope <resource-id>` per vedere quali ruoli sono davvero assegnati su quello scope.
Correzione: assegnare il ruolo data plane minimo necessario sullo scope giusto (container o account).

**Errore 2: `ResourceNotFound: The specified container does not exist`**
Sintomo: il comando dice che il container non esiste.
Piano: data plane.
Causa: il container non è mai stato creato, oppure il nome usato è sbagliato.
Controllo: `az storage container exists --account-name <nome_account> --name <nome_container> --auth-mode login`.
Correzione: creare il container con `az storage container create`, o correggere il nome se era solo un errore di battitura.

**Errore 3: `curl: (22) The requested URL returned error: 403`**
Sintomo: il download con curl fallisce con 403.
Piano: data plane.
Causa: con una SAS non c'è login da verificare, il permesso è tutto dentro il token dell'URL, quindi la causa è che la SAS è scaduta, oppure ha permessi insufficienti per quell'operazione.
Controllo: confrontare l'orario di scadenza impostato in `$SAS_EXPIRY` con l'orario in cui è stato lanciato `curl`, e controllare i `--permissions` usati in fase di generazione.
Correzione: generare una nuova SAS con scadenza non ancora passata e i permessi corretti.

## Lifecycle, costi e cleanup

La regola `delete-temporary` filtra solo i Blob con prefisso `documents/temporary/`. Il nostro file è in `archive/current/documento.txt`: sia il container (`archive` invece di `documents`) sia il prefisso (`current/` invece di `temporary/`) sono diversi. La regola guarda solo il percorso che ha scritto dentro il filtro, quindi se il percorso non corrisponde, quel Blob non viene proprio considerato, a prescindere da quanto sia vecchio.

Il costo di uno storage account dipende da capacità occupata, tipo di ridondanza scelta, tier di accesso, numero di operazioni, eventuale recupero da Archive e trasferimento dati in uscita.

Per il cleanup l'ordine giusto è questo: 
- Tolgo i ruoli che avevo assegnato per accedere ai dati
- Controllo di non aver lasciato in giro nessun token SAS dentro file o variabili (SAS non si cancella, scade da sola) 
- Elimino davvero la risorsa (storage account o resource group), e alla fine controllo che sia stata eliminata per davvero.

## Risultato finale

- nessun segreto pubblicato:
- hash abbreviato e messaggio del commit:
