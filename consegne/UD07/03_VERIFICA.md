# UD07 — Verifica

## Parte A — Scelta singola

1. **Domanda:** In Azure CLI, quale opzione estrae proprietà dall'output strutturato?<br>
   - A. `--query`
   - B. `--force`
   - C. `--metric`
   - D. `--scope`

   **Risposta:** A. `--query` è il parametro che filtra le proprietà dall'output di un comando.

---

2. **Domanda:** Quale formato è particolarmente utile per assegnare un singolo valore a una variabile Bash?<br>
   - A. table
   - B. tsv
   - C. jsonc
   - D. yamlc

   **Risposta:** B. `tsv` dà il valore secco, senza virgolette né struttura, comodo per una variabile.

---

3. **Domanda:** PowerShell lavora principalmente con:<br>
   - A. solo testo non strutturato
   - B. oggetti
   - C. pacchetti Ethernet
   - D. Blob

   **Risposta:** B. I cmdlet restituiscono oggetti, non semplice testo.

---

4. **Domanda:** Activity Log riguarda principalmente:<br>
   - A. eventi del control plane della subscription
   - B. contenuto dei file locali
   - C. tabelle SQL applicative
   - D. password degli utenti

   **Risposta:** A. Registra le operazioni di gestione sulle risorse, non il contenuto applicativo.

---

5. **Domanda:** Una diagnostic setting serve a:<br>
   - A. cambiare password
   - B. instradare segnali diagnostici verso destinazioni
   - C. creare una VNet
   - D. fare scale up

   **Risposta:** B. Decide quali categorie di log/metriche inviare, e verso quale destinazione.

---

6. **Domanda:** Quale linguaggio si usa normalmente per interrogare Log Analytics?<br>
   - A. CSS
   - B. KQL
   - C. YAML
   - D. Bicep

   **Risposta:** B. KQL (Kusto Query Language) è il linguaggio delle query su Log Analytics.

---

7. **Domanda:** Un Action Group definisce principalmente:<br>
   - A. il CIDR della rete
   - B. notifiche e azioni associate agli alert
   - C. il tier di Storage
   - D. il ruolo RBAC

   **Risposta:** B. È la destinazione dell'azione (email, SMS, webhook...), separata dalla condizione dell'alert.

---

8. **Domanda:** Una metric alert rule in stato Enabled:<br>
   - A. è sempre Fired
   - B. viene valutata, ma può non essere Fired
   - C. elimina la risorsa
   - D. crea automaticamente un incidente

   **Risposta:** B. Enabled vuol dire solo che la regola è attiva e viene controllata, non che sia mai scattata.

---

## Parte B — Risposte brevi

9. **Domanda:** Distingui Activity Log, Metrics e Logs.<br>

   **Risposta:** Activity Log dice cosa è successo a livello di gestione (chi ha creato/modificato/eliminato una risorsa, e con che esito). Metrics sono numeri nel tempo, tipo CPU o transazioni. Logs sono record più dettagliati, che interrogo con KQL quando mi serve capire di più di un semplice numero.

---

10. **Domanda:** Spiega l'idempotenza con un esempio amministrativo.<br>

    **Risposta:** Lo script che ho scritto per `rg-ud07-auto` è un esempio: la prima volta controlla che il gruppo non esista e lo crea, la seconda volta lo trova già lì e lo riusa senza crearne un secondo. Rieseguirlo non cambia il risultato finale.

---

11. **Domanda:** Distingui `table` e `tsv`.<br>

    **Risposta:** `table` è per leggere io a schermo, con le colonne allineate. `tsv` mi dà solo il valore secco, senza virgolette, comodo quando lo devo mettere subito in una variabile per il comando dopo.

---

12. **Domanda:** Spiega perché Log Analytics workspace e diagnostic setting non sono la stessa cosa.<br>

    **Risposta:** Il workspace è il posto dove i dati vivono davvero e dove posso interrogarli. La diagnostic setting è solo la regola che decide cosa mandare lì dentro e da dove. Posso avere un workspace vuoto se non ho ancora collegato nessuna diagnostic setting.

---

13. **Domanda:** Distingui Alert Rule e Action Group.<br>

    **Risposta:** L'Alert Rule decide quando una condizione è vera (tipo "Transactions > 0"). L'Action Group decide cosa fare quando succede (mandare un'email, per esempio). Sono separati apposta, così lo stesso Action Group si può riusare su più alert diversi.

---

14. **Domanda:** Perché correlazione temporale non implica causalità?<br>

    **Risposta:** L'ho visto io stesso oggi: ho cambiato un tag e poco dopo è comparso un evento nell'Activity Log, ma non potevo essere sicuro al 100% che fosse proprio quello — c'erano più eventi simili vicini. Vedere due cose vicine nel tempo non basta a dire che una ha causato l'altra.

---

## Parte C — Scenario

> Alle 10:15 una risorsa Azure viene modificata. Alle 10:16 l'Activity Log mostra una `write` riuscita. Alle 10:20 una metrica aumenta e alle 10:25 un alert passa a Fired.

15. **Domanda:** Quali fatti puoi affermare con certezza?<br>

    **Risposta:** Posso dire con certezza solo che le cose sono successe in quest'ordine nel tempo: modifica alle 10:15, evento registrato alle 10:16, metrica salita alle 10:20, alert Fired alle 10:25. Non posso ancora dire che la prima cosa ha causato le altre, solo che sono avvenute in sequenza.

---

16. **Domanda:** Quale ulteriore analisi è necessaria prima di affermare che la modifica delle 10:15 ha causato l'alert?<br>

    **Risposta:** Dovrei controllare cosa è stato modificato esattamente, se quella modifica è collegata davvero alla metrica che è salita, se ci sono altri log coerenti con questa spiegazione, e se rifacendo la stessa modifica (o annullandola) succede di nuovo la stessa cosa. Solo con queste prove in più potrei dire che c'è causalità, non solo coincidenza di orari.
