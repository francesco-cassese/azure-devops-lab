# Consegna UD06 — Domande sui concetti

Per ciascuna domanda 1–12 riporta una risposta motivata.

1. **Domanda:** Quali risorse e componenti principali costituiscono una VM Azure e quale ruolo svolge ciascuno?<br>

   **Risposta:** L'image è il sistema operativo di partenza, per esempio Ubuntu. La size dice quanto è potente la VM, in termini di processore e memoria. Il disco da cui la VM si avvia è l'OS disk, e in più posso aggiungere un disco separato solo per i dati, se mi serve. La NIC collega la VM alla rete: le dà il suo indirizzo interno, la mette dentro una subnet, e su di lei posso applicare le regole di sicurezza che decidono cosa passa.

---

2. **Domanda:** Perché la presenza di un Public IP non garantisce che un servizio sulla VM sia raggiungibile da Internet?<br>

   **Risposta:** Perché un indirizzo pubblico è solo un numero assegnato, da solo non basta. Serve anche che le regole di sicurezza lascino passare la porta giusta, che il firewall dentro il sistema operativo non blocchi, e che il servizio sia davvero acceso e in ascolto su quella porta. Sono cose diverse, e devono essere tutte a posto insieme.

---

3. **Domanda:** Distingui Availability Zone, Availability Set e VM Scale Set, spiegando quale problema affronta ciascuno.<br>

   **Risposta:** Le Availability Zone sono zone fisicamente separate dentro la stessa regione, quindi se metto le istanze in zone diverse, un guasto in una zona sola non ferma tutto. L'Availability Set fa qualcosa di simile ma dentro lo stesso posto: distribuisce le VM su pezzi di hardware diversi e su momenti di manutenzione diversi, così non vengono spente tutte insieme. Il VM Scale Set invece gestisce tante VM come un gruppo unico, e può far salire o scendere il loro numero da solo quando cambia il carico di lavoro.

---

4. **Domanda:** Qual è la differenza tra scale up e scale out?<br>

   **Risposta:** Lo scale up vuol dire rendere più potente la stessa VM, per esempio dandole più processore. Lo scale out vuol dire invece aumentare il numero di VM, così il lavoro si divide tra più macchine invece di restare su una sola.

---

5. **Domanda:** Come può Azure Monitor Autoscale modificare un VM Scale Set e perché sono importanti soglie e limiti minimo/massimo?<br>

   **Risposta:** Una regola di autoscaling controlla qualcosa, per esempio quanto lavora il processore, e se resta troppo alto per un po' di tempo, aggiunge da sola nuove istanze. Il minimo dice quante istanze devono restare sempre accese come base. Il massimo è il limite che non deve mai essere superato, così se il carico resta alto a lungo il numero di macchine non cresce all'infinito e la spesa resta sotto controllo.

---

6. **Domanda:** Qual è la differenza tra App Service Plan e Web App?<br>

   **Risposta:** L'App Service Plan è come la base su cui appoggio tutto, decide quanta capacità ho a disposizione e dove gira. La Web App è invece l'applicazione vera e propria che uso io, quella che pubblico e faccio funzionare sopra quella base. Posso anche mettere più applicazioni sulla stessa base, e in quel caso si dividono la stessa capacità.

---

7. **Domanda:** Qual è la differenza concettuale tra Azure Monitor Autoscale e App Service Automatic Scaling?<br>

   **Risposta:** Con Autoscale sono io a decidere le regole che fanno scattare l'aumento delle istanze. Con Automatic Scaling invece è la piattaforma stessa a occuparsene, guardando il traffico reale senza che io imposti nulla. Sono due modi diversi di gestire lo stesso problema.

---

8. **Domanda:** Distingui Metrics e Logs/Log Analytics e indica che tipo di informazione fornisce ciascuno.<br>

   **Risposta:** Le Metrics sono numeri che cambiano nel tempo, mi dicono cosa sta succedendo in quel momento, per esempio quanto lavora il processore. I Logs sono invece un elenco di eventi dettagliati che posso cercare e filtrare, e mi aiutano a capire perché è successo qualcosa, non solo che è successo.

---

9. **Domanda:** Qual è il ruolo di Recovery Services vault, backup policy e recovery point e come sono collegati?<br>

   **Risposta:** Il vault è il posto che organizza e tiene sotto controllo tutti i backup. La policy stabilisce ogni quanto va fatto il backup e per quanto tempo va conservato. Il recovery point è invece la copia concreta salvata in un momento preciso, ed è da lì che parto quando devo ripristinare qualcosa.

---

10. **Domanda:** Distingui High Availability, Backup e Disaster Recovery utilizzando un esempio di esigenza per ciascuno.<br>

    **Risposta:** Con l'High Availability, se una VM smette di funzionare, un'altra prende subito il suo posto senza interrompere il servizio. Con il Backup, se cancello dati per sbaglio, li recupero da una copia salvata in precedenza. Con il Disaster Recovery, se un'intera zona geografica non è più usabile, riesco a far ripartire tutto altrove.

---

11. **Domanda:** Che cosa indicano RPO e RTO e perché rappresentano due requisiti diversi?<br>

    **Risposta:** L'RPO dice quanti dati sono disposto a perdere, per esempio l'ultima ora di lavoro. L'RTO dice invece quanto tempo posso restare fermo prima che il servizio torni a funzionare, per esempio mezz'ora. Nel concreto sono due cose diverse: una riguarda quanto perdo, l'altra riguarda quanto resto bloccato.

---

12. **Domanda:** Perché una VM `deallocated` può continuare a generare costi?<br>

    **Risposta:** Perché deallocare libera solo la parte che consuma per far girare la VM, ma non la cancella davvero. Dischi, indirizzi e altri servizi collegati restano lì e continuano a costare anche se la VM stessa non gira più.
