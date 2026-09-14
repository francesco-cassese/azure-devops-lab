# UD06 — Consegna laboratorio guidato

## VM

- image: Ubuntu Server 24.04 LTS
- size: Standard_B2ts_v2
- private IP: 172.16.0.4
- public IP: 74.159.81.39
- NIC: vm-ud06-linux236
- subnet: snet-vm
- OS disk: vm-ud06-linux_OsDisk_1_8f27398d567942cfa8aa80dda2d4744c

## Accesso e workload

- SSH: riuscita, chiave ed25519 (~/.ssh/ud06_azure), utente azureuser
- Nginx: installato e acceso
- test localhost: curl -I http://localhost → 200 OK
- test esterno: curl -I http://$LAB_VM_IP → 200 OK
- IP Flow Verify: Access allowed
- regola responsabile: Allow-HTTP-MyIP

## Azure Monitor

- metrica VM: Percentage CPU, Network In Total, Network Out Total
- intervallo: ho provato sia le ultime 24 ore che l'ultima ora
- aggregazione: per la CPU ho provato sia la media che il massimo
- osservazione: guardando la media su 24 ore la CPU sembrava sempre bassa (0,79%), come se la VM non avesse fatto niente. Guardando invece il massimo sulle stesse 24 ore si vede che in un momento è arrivata al 19,74%, forse mentre installavo Nginx. Se guardo solo l'ultima ora il massimo è basso (3,26%), quindi quel picco era già passato da un po'. Ho capito che un solo numero non basta, guardando la stessa metrica in modo diverso si vedono cose diverse. Network In e Out sono rimasti bassi, solo il traffico dei miei test

## VMSS / Autoscale

Non ho creato un VMSS davvero, la guida dice di non farlo in questa UD. I valori qui sotto sono quelli dell'esempio già scritto nella guida, li ho solo letti e capiti, non testati da me.

- min: 1
- default: 1
- max: 3
- metrica: Percentage CPU
- soglia: sopra il 70% per 5 minuti
- azione: aggiungi 1 istanza
- perché serve un max: se no le istanze potrebbero continuare ad aumentare senza fermarsi mai, e il costo salire senza controllo

## App Service

- App Service Plan: plan-ud06-29497
- tier: F1 (Free)
- Web App: ud06-web-28037-27669
- hostname: ud06-web-28037-27669.azurewebsites.net
- test HTTPS: curl -I https://ud06-web-28037-27669.azurewebsites.net → 200 OK

## Scaling App Service

| Modalità | Basata su |
|---|---|
| Manual | non disponibile sul piano Free, si vede da Maximum scale a 0 |
| Azure Monitor Autoscale | non disponibile sul piano Free, si vede da Maximum scale a 0 |
| Automatic Scaling | non disponibile sul piano Free, si vede da Maximum scale a 0 |

## Azure Monitor App Service

- metrica: Requests, Response Time
- osservazione: 2 richieste, sono i due curl che ho fatto io. Tempo di risposta medio alto (26 sec), forse perché l'app doveva ancora "svegliarsi" dopo il deploy sul piano gratuito

## Backup

- Recovery Services vault: vault577 (proposto dal Portale, non creato davvero)
- frequenza ipotizzata: ogni ora
- retention: 30 giorni
- recovery point: non creato, ho solo guardato come funziona
- backup reale avviato?: no — non previsto nella UD

## HA / Backup / DR

- Scenario A ("voglio ridurre l'impatto del guasto di una singola istanza"): High Availability
- Scenario B ("voglio recuperare il contenuto della VM a uno stato precedente"): Backup
- Scenario C ("voglio ripristinare il workload in un'altra regione dopo un grave outage"): Disaster Recovery

## Problemi tecnici incontrati

Ho provato a vedere l'inventario della VM con il comando della guida:

```bash
az vm show --resource-group "$LAB_RG" --name "$LAB_VM" --show-details --query "{...}" --output table
```

e mi dava sempre questo errore:

```text
(InvalidApiVersionParameter) The api-version '2026-04-01' is invalid. The supported versions are '2026-06-01,2025-04-01,2025-03-01,...'
```

Ho provato ad aggiornare la CLI (`az upgrade`) ma diceva che era già l'ultima versione, quindi in quel momento non ho risolto: ho letto l'inventario dal Portale invece che da CLI.

Più avanti, per vedere le metriche `Network In Total` e `Network Out Total` della VM, mi dava un altro errore, `Resource not found` (mentre `Percentage CPU` funzionava senza problemi). Ho letto la pagina ufficiale linkata proprio dentro l'errore di Azure (https://aka.ms/metricstroubleshoot, che rimanda a https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-troubleshoot), e la prima causa elencata era il resource provider `Microsoft.Insights` non registrato. Ho controllato ed era proprio così, quindi l'ho registrato:

```bash
az provider register --namespace Microsoft.Insights
```

e le metriche di rete hanno iniziato a funzionare. Solo più tardi, riprovando per caso il comando `--show-details` di prima, ho visto che nel frattempo aveva ricominciato a funzionare anche quello: non so con certezza se sia stato per la registrazione di `Microsoft.Insights` o se si sia sistemato da solo per un altro motivo, i due problemi non erano collegati di proposito.

Ho anche provato a cercare il runtime PHP per la Web App con il comando della guida:

```bash
export WEB_RUNTIME=$(az webapp list-runtimes --os linux --output tsv | grep '^PHP:' | head -n 1)
```

e mi dava sempre `WEB_RUNTIME` vuoto. Ho controllato l'output vero di `az webapp list-runtimes --os linux` e ho visto che il formato è cambiato: ora scrive `PHP|8.5` (con la barra), non più `PHP:8.2` (con i due punti) come si aspettava la guida. Ho cambiato il filtro in `grep '^PHP|'` e ha funzionato.

## Cleanup

- Resource Group eliminato: sì (`az group delete --name rg-ud06-compute --yes`)
- `az group exists`: `false`
