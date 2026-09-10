# Consegna UD04 — Verifica

## Parte A — Scelta singola

Per le domande 1–8 riporta risposta e motivazione.

1. **Domanda:** Quale servizio è più adatto a immagini applicative accessibili come oggetti HTTP?<br>
   A. Blob<br>
   B. Files<br>
   C. Queue<br>
   D. Table

   **Risposta:** A — Blob salva ogni file come oggetto con un suo URL, esattamente il caso di questa domanda.

---

2. **Domanda:** Quale servizio offre condivisioni file SMB gestite?<br>
   A. Blob<br>
   B. Files<br>
   C. Queue<br>
   D. Table

   **Risposta:** B — Files offre vere condivisioni SMB, montabili come una cartella di rete, cosa che Blob non fa.

---

3. **Domanda:** Contributor sullo storage account consente automaticamente lettura Blob via Entra ID?<br>
   A. Sì, sempre<br>
   B. No, serve un ruolo del piano dati<br>
   C. Solo con LRS<br>
   D. Solo dal portale

   **Risposta:** B — Servono comunque i permessi giusti sul piano dati (tipo Storage Blob Data Reader), Contributor da solo non basta.

---

4. **Domanda:** Quale ridondanza protegge da un guasto zonale nella region primaria?<br>
   A. LRS<br>
   B. ZRS<br>
   C. nessuna replica<br>
   D. Hot

   **Risposta:** B — ZRS tiene copie in zone diverse, così se una zona ha un problema le altre reggono comunque.

---

5. **Domanda:** Quale metodo concede un accesso delegato con permessi e scadenza?<br>
   A. Tag<br>
   B. SAS<br>
   C. Lock<br>
   D. Endpoint

   **Risposta:** B — SAS è un link con dentro un permesso e una scadenza già decisi, è proprio quello che serve per dare un accesso delegato senza dare tutto l'account.

---

6. **Domanda:** Un budget Azure Storage:<br>
   A. elimina i Blob al raggiungimento della soglia<br>
   B. cambia automaticamente tier<br>
   C. segnala una soglia ma non blocca i consumi<br>
   D. sostituisce lifecycle management

   **Risposta:** C — Il budget ha il compito di notificarti il superamento della soglia impostata, non può eseguire azioni.

---

7. **Domanda:** Una lifecycle rule con prefisso `documents/temporary/` interessa:<br>
   A. ogni Blob dell'account<br>
   B. soltanto Blob che corrispondono al filtro<br>
   C. tutte le file share<br>
   D. solo le account key

   **Risposta:** B — Ad esempio se ho un blob che risponde a `/image/current` non verrà intercettato da quella lifecycle rule.

---

8. **Domanda:** Perché `--auth-mode login` è importante?<br>
   A. rende esplicito l'uso dell'identità Entra<br>
   B. rende pubblico il container<br>
   C. disabilita TLS<br>
   D. crea una chiave

   **Risposta:** A — Ti associa direttamente all'identità Entra con cui sei già loggato.

## Parte B — Risposte brevi

9. **Domanda:** Distingui ridondanza e backup.<br>

   **Risposta:** La ridondanza tiene più copie di un dato, protegge da un guasto fisico (datacenter rotto). Non protegge però da un errore umano: se cancello un blob, la cancellazione si copia anche sulle repliche. Il backup invece salva una versione precisa nel tempo, e permette di tornarci anche dopo un errore.

---

10. **Domanda:** Distingui management plane e data plane con un comando per ciascuno.<br>

    **Risposta:** Management plane: gestisce la risorsa storage account in sé, es. `az storage account create`. Data plane: opera sui dati dentro, es. `az storage blob upload`.

---

11. **Domanda:** Elenca quattro proprietà di una SAS a minimo privilegio.<br>

    **Risposta:** Una SAS a minimo privilegio deve avere permessi minimi (solo quello che serve, es. sola lettura), scope più ristretto possibile (il singolo blob, non tutto il container), scadenza breve (pochi minuti, non giorni), e viaggiare solo su HTTPS.

---

12. **Domanda:** Spiega perché Archive non è appropriato per dati da recuperare immediatamente.<br>

    **Risposta:** Un dato in Archive è offline, va prima reidratato (riportato online) prima di poterlo leggere, e la reidratazione richiede tempo, non è immediata. Se serve un dato subito, Archive non va bene: meglio un tier come Hot o Cool, dove il dato è già pronto da leggere.

---

13. **Domanda:** Perché non bisogna salvare account key o SAS nel repository?<br>

    **Risposta:** Perché chiunque trovi quel codice nel repository ha lo stesso accesso ai dati che avresti tu: una account key dà accesso ampio a tutto l'account, una SAS dà accesso a quello che permette il suo token, finché non scade. Una volta pubblicato in un repository, anche cancellandolo dopo resta nella cronologia dei commit, quindi va comunque rigenerato o revocato alla fonte.

## Parte C — Caso situazionale

**Scenario:** un'applicazione espone documenti privati. Il tecnico assegna Contributor allo storage account, omette `--auth-mode login`, condivide una account key e crea una SAS con permessi completi senza scadenza breve.

14. **Domanda:** Individua almeno tre problemi.<br>

    **Risposta:**<br> 
    **Primo problema:** Contributor è troppo ampio per il bisogno, gestisce tutta la risorsa ma non dà accesso ai blob via Entra ID.<br>**Secondo problema:** l'account key condivisa dà accesso completo a tutto l'account. <br>**Terzo problema:** la SAS ha permessi completi e nessuna scadenza breve, quindi non è limitata quasi per niente.

---

15. **Domanda:** Proponi autorizzazione e scope più appropriati.<br>

    **Risposta:** Darei il ruolo Storage Blob Data Reader, con scope sul singolo container dei documenti, non sullo storage account o sulla sottoscrizione. Così l'app legge quello che le serve, senza poter modificare o eliminare nulla, e senza accesso al resto dell'account.

---

16. **Domanda:** Indica come verificheresti accesso e cleanup senza pubblicare segreti.<br>

    **Risposta:** Per controllare l'accesso userei `az role assignment list --scope <resource-id> --auth-mode login`, così non devo mai leggere una chiave. Per il cleanup userei `az group exists`, che dice solo `true` o `false`. Nell'evidenza scriverei solo cosa ho fatto e com'è andata, mai il valore vero di una SAS o di una chiave, e userei ID finti al posto di quelli reali.
