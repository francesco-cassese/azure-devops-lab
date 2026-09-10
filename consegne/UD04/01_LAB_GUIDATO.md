# Consegna UD04 — Laboratorio guidato

## Contesto anonimizzato

- resource group: `rg-cea-storage-<suffisso>`
- storage account: `stcea<suffisso>`
- region: `italynorth`
- tipo e ridondanza: `StorageV2`, `Standard_LRS`

## Servizi e configurazione

| Elemento | Configurazione | Motivazione |
|---|---|---|
| Blob container | `documents`, accesso privato | non mi serve che sia pubblico, è solo un file di prova |
| access tier | Hot | lo sto usando adesso, non ha senso archiviarlo |
| accesso pubblico | disabilitato (`allowBlobPublicAccess=false`) | non serve accesso anonimo, ci accedo sempre da loggato |
| trasferimento/TLS | HTTPS obbligatorio, TLS 1.2 minimo | così i dati non viaggiano in chiaro |

## Autorizzazione e lifecycle

Ho dato a me stesso il ruolo **Storage Blob Data Contributor**, solo su questo storage account, non su tutta la sottoscrizione, perché mi serviva solo qui. Prima di assegnarlo provavo a leggere i blob e mi dava errore, dopo aver aspettato qualche minuto ha funzionato.

Ho provato tre modi diversi per accedere agli stessi dati. Con **Microsoft Entra ID** uso la mia identità e il ruolo che mi sono dato: se un giorno serve togliere l'accesso, basta togliere il ruolo. Con la **Shared Key** (la chiave dell'account) ho avuto accesso a tutto senza che fosse legato a me in particolare: funziona, ma è più rischiosa, chi ha la chiave può fare quello che vuole su tutto l'account. Con una **SAS** (firmata con la mia identità, non con la chiave) ho creato un link che permette solo di leggere un file solo, valido 30 minuti: ho controllato che il file scaricato da quel link fosse uguale all'originale, poi ho lasciato scadere il link senza salvarlo da nessuna parte.

Ho creato una regola di lifecycle (`delete-temporary`) che cancella i blob non modificati da più di un giorno, ma solo quelli dentro `documents/temporary/`, non tutto l'account. Non ho aspettato che cancellasse davvero niente, ho solo controllato che la regola fosse salvata giusta, perché ci mette ore prima di partire.

## Verifiche, costi e cleanup

Riporta esiti essenziali, principali driver di costo, rimozione del ruolo temporaneo e verifica dell'eliminazione del resource group.

## Rilevanza professionale

Per questo caso (un documento letto da un'app tramite un link, non aperto come una cartella) sceglierei Blob e non Files: non devo montare nessuna cartella condivisa, mi basta un indirizzo diretto al file. Se invece un'app avesse bisogno di leggere e scrivere come farebbe con una cartella normale (tipo un programma vecchio che si aspetta un percorso di rete), allora sceglierei Files.

Come modo di accedere userei Microsoft Entra ID con un ruolo apposta (qui Storage Blob Data Contributor), perché lega l'accesso a me e si può togliere quando vuoi. Eviterei la account key perché chi la trova può fare tutto su tutto l'account, non solo quello che gli serve. Una SAS la userei solo per dare un accesso breve a qualcuno che non ha un account Entra su questo tenant, tipo condividere un file per un attimo con una persona esterna.

