# Consegna UD05 — Domande sui concetti

Per ciascuna domanda 1–8 riporta una risposta motivata.

1. **Domanda:** Perché due VNet da collegare non devono avere CIDR sovrapposti?<br>

   **Risposta:** Perché il routing si basa sugli indirizzi IP. Se le due VNet hanno lo stesso blocco di indirizzi, un pacchetto diretto a un IP che esiste uguale in entrambe non sa dove andare, il sistema non può capire se deve andare nella prima VNet o nella seconda. Per questo gli spazi devono essere diversi tra le reti che vuoi collegare.

---

2. **Domanda:** Quale rete è più grande, `/24` o `/26`, e perché?<br>

   **Risposta:** `/24` è più grande. Con `/24` restano 8 bit per gli host (256 indirizzi), con `/26` ne restano solo 6 (64 indirizzi), perché due bit sono stati tolti agli host per creare sottoreti più piccole. Più alto è il numero dopo la `/`, meno bit restano per gli host, quindi più piccola è la rete.

---

3. **Domanda:** Perché un public IP non garantisce raggiungibilità?<br>

   **Risposta:** Perché un IP pubblico è solo un indirizzo assegnato, non basta da solo. Serve anche che qualcosa risponda davvero su quell'indirizzo, e che NSG (Network Security Group), route e sistema operativo lascino passare il traffico. Avere un IP pubblico ed essere raggiungibile sono due cose diverse.

---

4. **Domanda:** Come viene scelta una regola NSG tra più corrispondenti?<br>

   **Risposta:** Ogni regola NSG ha una priorità da 100 a 4096. Vengono valutate in ordine dal numero più basso, e appena una regola corrisponde al traffico, la valutazione si ferma lì, le regole successive con priorità più alta non vengono nemmeno considerate.

---

5. **Domanda:** Cosa significa che un NSG è stateful?<br>

   **Risposta:** Un NSG stateful vuol dire che se un flusso è permesso in una direzione, il traffico di risposta a quello stesso flusso non ha bisogno di una regola speculare nella direzione opposta. Non autorizza però una connessione nuova ed indipendente, comprende solo le risposte a connessioni già aperte.

---

6. **Domanda:** Perché un `Allow` sulla NIC non supera un `Deny` applicabile sulla subnet?<br>

   **Risposta:** Perché quando esistono entrambi (NSG sulla subnet e NSG sulla NIC), il traffico deve passare tutti e due i controlli. Se anche solo uno dei due blocca, il traffico non passa, anche se l'altro lo permette: un `Allow` su uno dei due non annulla un `Deny` sull'altro.

---

7. **Domanda:** Qual è la differenza tra DNS, routing e NSG?<br>

   **Risposta:** Sono tre funzioni separate.<br>
   **DNS** (Domain Name System): traduce i nomi in indirizzi IP, non autorizza traffico e non decide percorsi.<br>
   **Routing**: decide il percorso che un pacchetto fa per arrivare a destinazione, quale next hop usare.<br>
   **NSG** (Network Security Group): filtra il traffico lungo quel percorso, permettendo o negando in base a origine, destinazione, porta e protocollo.

---

8. **Domanda:** Perché IP Flow Verify verrà completato dopo la creazione della VM?<br>

   **Risposta:** Perché IP Flow Verify ha bisogno di una VM per testare davvero un flusso di traffico. In UD05 non creiamo ancora una VM, quindi il test si completa in UD06, dopo averla creata.
