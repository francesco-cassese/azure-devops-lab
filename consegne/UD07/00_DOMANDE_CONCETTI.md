# UD07 — Risposte alle domande sui concetti

 1. **Domanda:** Perché `--query` è preferibile a cercare manualmente una stringa nell'output JSON?<br>

    **Risposta:** Perché `--query` ti permette di filtrare e farti restituire solo i campi dell'oggetto JSON che ti interessano.

---

2. **Domanda:** Qual è la differenza tra `table` e `tsv` in Azure CLI?<br>

    **Risposta:** `table` restituisce un output formattato per la lettura umana, mentre `tsv` restituisce solo i valori grezzi puliti (senza bordi, intestazioni o virgolette), ideali per essere salvati in variabili o usati in uno script.

---

3. **Domanda:** Che cosa significa lavorare con oggetti in PowerShell?<br>

    **Risposta:** In PowerShell I comandi (chiamati cmdlet) restituiscono oggetti strutturati. cioè un "pacchetto" che contiene dati organizzati in due parti principali:

    - **Proprietà**: Le caratteristiche dell'elemento (es. nome, dimensione, data di creazione, stato).

    - **Metodi**: Le azioni che puoi compiere direttamente su quell'oggetto (es. cancellarlo, avviarlo, modificarlo).

---

4. **Domanda:** Che cosa significa che una procedura amministrativa è idempotente?<br>

    **Risposta:** Quando la ripetizione di una stessa procedura porta allo stesso stato desiderato, senza effetti indesiderati. 

---

5. **Domanda:** Distingui Activity Log, Metrics e Logs.<br>

    **Risposta:** 
     - **Activity log:** è una sorta di registro, controlla se quella determinata risorsa è stata cambiata e chi è stato a farlo.

     - **Metrics:** Dati numerici leggeri e in tempo reale (es. % CPU) raccolti a intervalli regolari.

     - **Logs:** Registri ed eventi dettagliati e strutturati (es. messaggi di errore, tracce di sistema) usati per analisi approfondite.

---  

6. **Domanda:** A che cosa serve un Log Analytics workspace?<br>

    **Risposta:** Il **Log Analytics** è l'ambiente dove i log vivono e dove si eseguono query.

---

7. **Domanda:** A che cosa serve una diagnostic setting?<br>

    **Risposta:** La **diagnostic setting** è la regola con cui decidi quali registri o dati di performance raccogliere e dove mandarli.

---

8. **Domanda:** Perché Activity Log e AzureActivity non sono esattamente la stessa cosa?<br>
    
    **Risposta:** 
    - **Activity Log:** È il registro nativo di Azure in cui la piattaforma annota automaticamente tutti gli eventi e le modifiche che avvengono sulle risorse. 

    - **AzureActivity:** È il tipo di oggetto strutturato (o la tabella di Log Analytics) che ricevi quando interroghi quei log (ad esempio tramite PowerShell o query), il quale organizza i dati in proprietà e metodi per permetterti di filtrarli e analizzarli comodamente.

---

9. **Domanda:** Distingui Alert Rule e Action Group<br> 

    **Risposta:** L'**Alert Rule** descrive che cosa osservare e quando considerare vera una condizione mentre l'**Action Group** descrive che cosa fare quando quella condizione è vera.

---

10. **Domanda:** Perché un alert Fired non equivale automaticamente a un incidente?<br>
    
    **Risposta:** Perché l'alert in sé è solo un segnale: indica che una soglia critica è stata superata, ma non sa se c'è un reale impatto sul servizio. Inoltre, se per errore umano vengono impostate soglie sbagliate, verranno segnalate anche azioni normali che non rappresentano un errore effettivo, creando il cosiddetto "alert noise".

---

11. **Domanda:** Qual è la differenza tra correlazione e causalità?<br>

    **Risposta:**
    - **Correlazione:** Si intende quando due risorse variano insieme o si muovono nello stesso momento. Sono legate statisticamente ma non vuol dire che una provochi l'altra.

    - **Causalità:** Si intende quando lo stato di una risorsa provoca il cambiamento diretto del comportamento di un'altra, una sorta di (causa / effetto).

---

12. **Domanda:** Quali sono i passaggi essenziali di un troubleshooting ripetibile?<br>

    **Risposta:** descrivere il sintomo → chiarire il risultato atteso → raccogliere evidenze → formulare un'ipotesi → verificare l'ipotesi → applicare la modifica minima → ripetere il test → documentare.
