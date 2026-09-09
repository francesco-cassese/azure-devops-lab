# Consegna UD03 — Domande sui concetti

Per ciascuna domanda 1–8 riporta una risposta motivata.

1. **Domanda:** perché autenticazione riuscita e autorizzazione sufficiente non sono equivalenti?<br>

   **Risposta:** sono due controlli diversi, uno dopo l'altro. L'autenticazione verifica chi sono, l'autorizzazione verifica se posso fare quella specifica azione su quella specifica risorsa. Passare il primo non garantisce di passare il secondo: posso accedere al portale con le mie credenziali e poi ricevere `AuthorizationFailed` provando a creare una risorsa, perché non ho un ruolo che me lo permette su quello scope.

---

2. **Domanda:** quale differenza operativa esiste tra ruolo Microsoft Entra e ruolo Azure?<br>

   **Risposta:** la differenza sta negli oggetti su cui operano. I ruoli Microsoft Entra autorizzano la gestione degli oggetti della directory del tenant, utenti, gruppi, domini, configurazioni: un esempio è User Administrator, che opera sulle identità entro i limiti del ruolo. I ruoli Azure autorizzano operazioni sulle risorse Azure tramite Azure Resource Manager: Reader, Contributor e Owner sono esempi di ruoli Azure. Sono due sistemi separati: avere un ruolo forte in uno non dà automaticamente un ruolo forte nell'altro.

---

3. **Domanda:** quali tre elementi formano una role assignment?<br>

   **Risposta:** una role assignment è sempre l'insieme di tre elementi. Il principal è chi riceve l'accesso, utente, gruppo, service principal o managed identity. La role definition è cosa è permesso fare, l'elenco di azioni consentite. Lo scope è dove si applica, management group, sottoscrizione, resource group o singola risorsa. Mancarne uno dei tre non produce un'assegnazione valida.

---

4. **Domanda:** perché Reader su un resource group è preferibile a Contributor sulla sottoscrizione quando serve soltanto consultare quel progetto?<br>

   **Risposta:** dare Contributor sull'intera sottoscrizione a qualcuno che deve lavorare solo su un resource group significa che quella persona può modificare ogni risorsa della sottoscrizione, non solo quelle che le competono. Se quell'account viene compromesso o commette un errore, l'impatto è su tutta la sottoscrizione, non su un singolo progetto. Reader sul resource group giusto dà invece esattamente l'accesso necessario, niente di più.

---

5. **Domanda:** perché un ruolo ereditato non si rimuove dalla risorsa figlia?<br>

   **Risposta:** perché l'assegnazione non esiste sulla risorsa figlia, esiste sullo scope superiore e si propaga verso il basso. Sulla risorsa figlia si vede solo l'effetto, non l'assegnazione vera. Per rimuoverla bisogna agire dove è stata creata, cioè sullo scope superiore.

---

6. **Domanda:** un tag `deleteAfter` impedisce l'eliminazione? Motiva.<br>

   **Risposta:** no, non la impedisce. Il tag è solo una coppia chiave-valore leggibile, non un meccanismo di applicazione automatica: descrive la risorsa, non decide nulla su di essa. Che succeda qualcosa dopo la data scritta nel tag dipende da chi lo legge, una persona o un'automazione scritta apposta, e decide di agire. Se nessuno lo fa, la risorsa resta attiva anche oltre la data indicata.

---

7. **Domanda:** che cosa cambia tra lock `CanNotDelete` e ruolo Reader?<br>

   **Risposta:** Reader è un permesso: decide che l'identità può solo leggere. Il lock `CanNotDelete` invece blocca l'eliminazione a chiunque, anche a un Owner che normalmente potrebbe farla. Non sostituisce RBAC, si aggiunge come barriera in più.

---

8. **Domanda:** perché un budget non è sufficiente a garantire che la spesa non superi una cifra?<br>

   **Risposta:** perché il budget è solo una segnalazione: confronta la spesa con la soglia e manda una notifica, ma non esegue nessuna azione. Se nessuno interviene dopo la notifica, la spesa continua a salire come se il budget non ci fosse.
