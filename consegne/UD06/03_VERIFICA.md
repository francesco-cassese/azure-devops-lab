# UD06 — Verifica

## Parte A — Scelta singola

1. **Domanda:** Quale componente collega normalmente una VM Azure alla subnet?<br>
   - A. NIC
   - B. Backup policy
   - C. App Service Plan
   - D. Recovery point

   **Risposta:** A. La NIC è quella che collega la VM alla rete.

---

2. **Domanda:** Quale tecnologia gestisce un insieme di VM e può supportare autoscaling?<br>
   - A. Availability Set
   - B. VM Scale Set
   - C. Recovery Services vault
   - D. Log Analytics workspace

   **Risposta:** B. Il VM Scale Set gestisce un gruppo di VM e può far crescere o scendere da solo il loro numero.

---

3. **Domanda:** Passare da 2 a 4 istanze è:<br>
   - A. scale up
   - B. scale out
   - C. failback
   - D. deallocate

   **Risposta:** B. Aumentare il numero di istanze è scale out, non scale up.

---

4. **Domanda:** Quale elemento definisce capacità e tier di una Web App?<br>
   - A. App Service Plan
   - B. NSG
   - C. Recovery point
   - D. NIC

   **Risposta:** A. L'App Service Plan decide la capacità e il tier su cui gira la Web App.

---

5. **Domanda:** Azure Monitor Autoscale può usare:<br>
   - A. soltanto nomi DNS
   - B. metriche e regole
   - C. soltanto backup policy
   - D. account key

   **Risposta:** B. Usa regole basate su metriche e soglie.

---

6. **Domanda:** Quale affermazione è corretta?<br>
   - A. Metrics e Logs sono sinonimi
   - B. Metrics rappresentano valori numerici nel tempo; Logs sono record interrogabili
   - C. Log Analytics è un NSG
   - D. Azure Monitor è un backup

   **Risposta:** B. Le metriche sono numeri nel tempo, i log sono record che si possono interrogare.

---

7. **Domanda:** Quale risorsa è centrale nel workflow tradizionale di Azure Backup per VM?<br>
   - A. Recovery Services vault
   - B. VNet
   - C. Load Balancer
   - D. App Service Plan

   **Risposta:** A. Il Recovery Services vault è la risorsa che organizza il backup delle VM.

---

8. **Domanda:** Azure Site Recovery è principalmente associato a:<br>
   - A. tagging
   - B. Disaster Recovery
   - C. object storage
   - D. DNS

   **Risposta:** B. Azure Site Recovery serve per il disaster recovery.

---

## Parte B — Risposte brevi

9. **Domanda:** Distingui Availability Zone, Availability Set e VM Scale Set.<br>

   **Risposta:** Le Availability Zone sono datacenter separati fisicamente dentro la stessa regione, se una zona ha un problema le altre restano su. L'Availability Set fa qualcosa di simile ma dentro un solo datacenter, mette le VM su rack e finestre di manutenzione diverse così non cadono tutte insieme durante un guasto o un aggiornamento. Il VM Scale Set invece è un gruppo di VM identiche che può crescere o ridursi da solo in base al carico.

---

10. **Domanda:** Distingui scale up e scale out.<br>

    **Risposta:** Scale up vuol dire dare più risorse alla stessa VM, per esempio più processore. Scale out vuol dire aggiungere altre VM che lavorano insieme, per esempio passare da 1 a 3 VM.

---

11. **Domanda:** Distingui App Service Autoscale e Automatic Scaling.<br>

    **Risposta:** L'Azure Monitor Autoscale funziona come per i VM Scale Set, cambia il numero di istanze in base a regole su metriche e soglie. L'Automatic Scaling invece è gestito direttamente dalla piattaforma, pensato per il traffico, con parametri suoi come le istanze sempre pronte o il numero massimo di scale. Non sono la stessa cosa, e la disponibilità di entrambi dipende dal tier del piano.

---

12. **Domanda:** Distingui High Availability, Backup e Disaster Recovery.<br>

    **Risposta:** La High Availability serve quando si rompe un'istanza, l'app continua a girare sulle altre nella regione. Il Backup è il salvataggio dello stato di una risorsa in un momento preciso, come una fotografia. Il Disaster Recovery invece serve per spostare l'app in un'altra regione, quando quella dove gira ha un danno serio.

---

13. **Domanda:** Spiega Recovery Services vault, backup policy e recovery point.<br>

    **Risposta:** Il Recovery Services vault è la risorsa che organizza e gestisce la protezione e i recovery point, non è solo una cartella di file. La backup policy decide ogni quanto fare il backup e per quanto tempo tenerlo, la retention: più è lunga, più indietro nel tempo posso tornare. Il recovery point è invece uno stato recuperabile preciso, quando faccio un ripristino scelgo proprio un recovery point specifico, non un momento generico nel passato.

---

14. **Domanda:** Distingui RPO e RTO.<br>

    **Risposta:** L'RPO è quanti dati posso permettermi di perdere. L'RTO è dopo quanto tempo il servizio deve tornare di nuovo attivo.

---

## Parte C — Caso situazionale

> Una VM Linux è Running. Nginx risponde a `curl localhost`. La VM ha un Public IP. Nell'NSG:
>
> - `Deny-HTTP` priority 100, TCP 80, sorgente My IP, Deny
> - `Allow-HTTP` priority 300, TCP 80, sorgente My IP, Allow
>
> La richiesta HTTP esterna fallisce.

15. **Domanda:** Qual è la causa più probabile e perché?<br>

    **Risposta:** La causa è la regola `Deny-HTTP`, perché ha priorità 100, più bassa del numero di `Allow-HTTP` (300). Nell'NSG vince la regola con priorità più bassa e viene valutata per prima, quindi il traffico sulla porta 80 viene bloccato da `Deny-HTTP` prima ancora di arrivare a `Allow-HTTP`. Per questo la richiesta esterna sembra restare senza risposta, il pacchetto viene scartato senza nessun errore esplicito.

---

16. **Domanda:** Qual è la correzione minima e quali verifiche useresti per dimostrare il ripristino end-to-end?<br>

    **Risposta:** La correzione minima è eliminare la regola `Deny-HTTP`, lasciando solo `Allow-HTTP` che già permette il traffico dal mio IP. Non serve toccare altro.

    Per dimostrare il ripristino end-to-end: prima `curl -I http://localhost` dentro la VM, per confermare che Nginx risponde ancora in locale. Poi `curl -I http://$LAB_VM_IP` dall'esterno, per vedere se la richiesta HTTP ora arriva davvero. Infine `az network watcher test-ip-flow`, per avere conferma esplicita di `Access allowed` e vedere quale regola lo permette.
