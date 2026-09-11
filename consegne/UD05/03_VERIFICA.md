# Consegna UD05 — Verifica

## Parte A — Scelta singola

Per le domande 1–8 riporta risposta e motivazione.

1. **Domanda:** Quale subnet è più grande?<br>
   A. `/26`<br>
   B. `/24`<br>
   C. sono uguali<br>
   D. dipende dall'NSG

   **Risposta:** B - `/24` lascia 8 bit liberi per gli host, quindi 256 indirizzi, più di `/26`.

---

2. **Domanda:** Due VNet da collegare hanno entrambe `10.0.0.0/16`. Il problema principale è:<br>
   A. TLS<br>
   B. sovrapposizione degli indirizzi<br>
   C. DNS pubblico<br>
   D. account key

   **Risposta:** B - se due VNet usano lo stesso blocco di indirizzi, il routing non sa a quale delle due mandare un pacchetto diretto a un indirizzo che esiste in entrambe.

---

3. **Domanda:** Tra regole NSG con priorità 200 e 300 viene valutata prima:<br>
   A. 300<br>
   B. 200<br>
   C. quella creata prima<br>
   D. quella con nome alfabeticamente minore

   **Risposta:** B - viene valutata prima la priorità più bassa, quindi 200 prima di 300.

---

4. **Domanda:** Un NSG può essere associato a:<br>
   A. subnet e NIC<br>
   B. soltanto subscription<br>
   C. soltanto tenant<br>
   D. account Storage

   **Risposta:** A - un NSG può essere associato a una subnet, a una NIC, o a entrambe.

---

5. **Domanda:** Se subnet e NIC hanno NSG, il traffico deve essere:<br>
   A. consentito da entrambi<br>
   B. consentito solo dalla NIC<br>
   C. consentito solo dalla subnet<br>
   D. sempre consentito dalla route

   **Risposta:** A - se sia la subnet che la NIC hanno un NSG, il traffico deve passare tutti e due i controlli.

---

6. **Domanda:** DNS serve principalmente a:<br>
   A. tradurre nomi in indirizzi<br>
   B. assegnare ruoli<br>
   C. filtrare porte<br>
   D. creare route

   **Risposta:** A - DNS traduce i nomi in indirizzi IP perchè l'utente lavora con i nomi ma il computer comunica con gli indirizzi.

---

7. **Domanda:** Quale strumento indica la regola che consente o nega un flusso su una VM?<br>
   A. Cost Analysis<br>
   B. IP Flow Verify<br>
   C. Lifecycle management<br>
   D. Azure Files

   **Risposta:** B - IP Flow Verify è uno strumento di Network Watcher che dice se un flusso è permesso o negato su una VM, ma serve una VM vera per usarlo.

---

8. **Domanda:** Un public IP senza servizio in ascolto e regole coerenti:<br>
   A. garantisce raggiungibilità<br>
   B. non garantisce raggiungibilità<br>
   C. disabilita il DNS<br>
   D. crea una VPN

   **Risposta:** B - un IP pubblico è solo un indirizzo assegnato, non garantisce che qualcosa risponda davvero su quell'indirizzo.

## Parte B — Risposte brevi

9. **Domanda:** Spiega perché le subnet devono lasciare margine di crescita.<br>

   **Risposta:** Perché se la subnet è troppo piccola e servono più risorse in futuro, bisogna fare una migrazione per sistemarla. Meglio lasciare margine da subito, pensando a quanto potrebbe crescere, non solo a quello che c'è oggi.

---

10. **Domanda:** Distingui NSG, route e DNS.<br>

    **Risposta:** **NSG**: contiene regole di sicurezza che permettono o negano il traffico in base a origine, destinazione, porta e protocollo.<br>
    **Routing**: decide il percorso che un pacchetto fa per arrivare a destinazione, quale next hop usare.<br>
    **DNS**: traduce i nomi in indirizzi IP.

---

11. **Domanda:** Spiega la statefulness di un NSG.<br>

    **Risposta:** Un NSG stateful si ricorda dei flussi già aperti. Se una regola permette il traffico in entrata verso una porta, quando arriva la risposta (in uscita, verso lo stesso client) il NSG la lascia passare da sola, senza dover scrivere una seconda regola apposta. Questo vale solo per rispondere a quel flusso specifico, non per aprire una connessione nuova nella direzione opposta.

---

12. **Domanda:** Perché una baseline NSG sulla subnet può essere più semplice da governare?<br>

    **Risposta:** Perché con un NSG per ogni NIC, configurato a mano una per una, rischi di dimenticarne qualcuna o di configurarle in modo diverso senza volerlo. Con una baseline unica sulla subnet, tutte le NIC collegate ereditano automaticamente le stesse regole, senza rischio di incoerenza.

---

13. **Domanda:** Quali verifiche sono possibili su una NIC senza VM e quale prova manca?<br>

    **Risposta:** Senza VM vedo solo la configurazione scritta: regole NSG, priorità, associazioni, IP delle NIC. Manca la prova vera (regole/route effettive, IP Flow Verify), che serve una VM accesa.

## Parte C — Caso situazionale

**Scenario:** una regola `Allow-Web` priorità 400 consente TCP 443 da `10.60.10.0/24`. Una regola `Deny-Web` priorità 150 nega TCP 443 dalla stessa origine. Il tecnico cambia il nome della prima in `AAA-Allow-Web`, ma il traffico resta negato.

14. **Domanda:** Spiega perché il cambio di nome non modifica l'esito.<br>

    **Risposta:** Perché l'ordine di valutazione si basa sulla priorità numerica, non sul nome della regola. Cambiare il nome in `AAA-Allow-Web` non cambia il numero 400, quindi `Deny-Web` (150) continua a essere valutata prima e a vincere.

---

15. **Domanda:** Proponi una correzione minima senza aprire Internet.<br>

    **Risposta:** Rimuovere `Deny-Web` con `az network nsg rule delete`, che blocca esattamente lo stesso flusso che `Allow-Web` dovrebbe permettere. Poi controllare con `az network nsg rule list` che resti solo `Allow-Web`. Niente da aprire su Internet, basta togliere quella regola.

---

16. **Domanda:** Elenca i controlli successivi se, dopo la correzione, l'applicazione resta comunque irraggiungibile.<br>

    **Risposta:** Dopo l'NSG controllerei: le route effettive sulla NIC, se il servizio è davvero in ascolto sulla porta 443 dentro la VM, un eventuale firewall del sistema operativo della VM, e come controllo generale `nslookup <nome>` e `ping`.

