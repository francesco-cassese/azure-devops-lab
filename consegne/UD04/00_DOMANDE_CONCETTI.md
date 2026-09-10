# Consegna UD04 — Domande sui concetti

Per ciascuna domanda 1–8 riporta una risposta motivata.

1. **Domanda:** Perché Azure Blob e Azure Files non sono intercambiabili?<br>

   **Risposta:** Perché hanno un modo diverso di tenere i dati. Blob li mette in un container, ogni file ha un suo indirizzo web. Files invece è una cartella vera, la puoi aprire e vedere come quelle di Windows. Se un programma è fatto per lavorare con una cartella vera, non puoi dargli Blob al posto di Files e aspettarti che funzioni uguale: dovresti cambiare il programma, non basta cambiare nome o posto.

---

2. **Domanda:** Qual è la differenza tra management plane e data plane?<br>

   **Risposta:** Il management plane è gestire la risorsa in sé, tipo creare l'account o cambiare la rete, passa da ARM. Il data plane invece è lavorare sui dati veri, tipo leggere un blob. Sono due cose separate: avere Contributor sull'account (management plane) non mi dà accesso ai blob con Entra ID, mi serve un ruolo apposito per il data plane.

---

3. **Domanda:** Perché Contributor sullo storage account non implica accesso Blob con Entra ID?<br>

   **Risposta:** Perché Contributor è un ruolo sul management plane, gestisce la risorsa ma non i dati dentro. Per leggere o scrivere un blob con la mia identità serve un ruolo specifico del data plane, tipo Storage Blob Data Reader, assegnato a parte.

---

4. **Domanda:** Perché geo-ridondanza e backup risolvono problemi diversi?<br>

   **Risposta:** La geo-ridondanza copia i dati così come sono, anche se sono sbagliati: se cancello un blob per errore, quella cancellazione si copia pure lei sulle altre region. Protegge solo dal guasto fisico, tipo un datacenter che si rompe. Il backup invece mi permette di recuperare una versione precedente se sbaglio io, quindi protegge da un errore mio, non da un guasto.

---

5. **Domanda:** Quali fattori valuteresti prima di scegliere Archive?<br>

   **Risposta:** Quanto spesso mi serve davvero riaprire quel dato, quanto tempo posso aspettare se un giorno mi serve (Archive va reidratato, non è immediato), quanto tempo minimo devo tenerlo lì dentro senza spostarlo, e quanto costa recuperarlo, non solo quanto costa tenerlo fermo lì.

---

6. **Domanda:** Perché una account key ha un impatto maggiore di una SAS limitata?<br>

   **Risposta:** Perché la account key dà accesso pieno a tutto l'account, senza scadenza né limiti. Una SAS invece ha una scadenza e permessi limitati, tipo sola lettura su un solo container. Se si perde una SAS il danno resta piccolo e per poco tempo, se si perde una account key il danno è su tutto finché non la rigenero.

---

7. **Domanda:** Quali proprietà rendono una SAS coerente con il minimo privilegio?<br>

   **Risposta:** Permessi minimi, scope più ristretto possibile (un container solo, non tutto l'account), scadenza breve, solo HTTPS, e mai pubblicata da nessuna parte tipo repository o screenshot.

---

8. **Domanda:** Perché non possiamo verificare una policy lifecycle aspettando pochi minuti?<br>

   **Risposta:** Perché quando salvo la policy non parte subito, ci mette anche ore prima di iniziare a controllare i blob. Non c'entra la soglia scritta nella regola (tipo dopo 90 giorni), è il sistema che ci mette tempo ad avviarsi. Se guardo dopo pochi minuti e non vedo niente, non vuol dire che è sbagliata, magari deve solo partire ancora.
