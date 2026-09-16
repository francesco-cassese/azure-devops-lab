# UD08 — Risposte domande concetti

1. **Domanda:** Perché DevOps non coincide con Azure DevOps?

    **Risposta:** Perchè Azure DevOps è la stumentazione che usiamo, mentre DevOps è la "metodologia" applicata al lavoro. 

---

2. **Domanda:** Distingui Continuous Integration, Continuous Delivery e Continuous Deployment.

    **Risposta:** 
    - **Continuos Integrations** (CI), significa integrare frequentemente modifiche relativamente piccole nella base comune del progetto e verificarle rapidamente.

    - **Continuos Delivery** & **Continuos Deployment** entrambi arrivano al punto in cui il software, dopo i test, è pronto per il rilascio , cambia solo cosa succede subito dopo. Il primo richiede ancora una decisione umana, cioè ci deve essere qualcuno che clicchi sul pulsante "Deploy" nell'altro è tutto automatizzato.

---

3. **Domanda:** Che differenza c'è tra working tree, staging area e commit?

    **Risposta:** Working tree equivale all'albero delle modifiche, cioè quando git si accorge di una modifica al file lo evidenzia li, gli stessi file quando saranno pronti per essere "salvati" verranno aggiunti successivamente alla staging area pronti per il commit che equivale al salvataggio effettivo della modifica.

---

4. **Domanda:** Perché conviene creare un feature branch da `main` aggiornata?

    **Risposta:** perchè il `main` deve restare sempre una versione stabile e funzionante, non possiamo permetterci di fare prove e "rompere" la struttura principale, allo stesso tempo però bisogna ricordarsi di tenere il nostro branch sempre in linea con eventuali aggiornamenti con il main, magari prima di fare ogni modifica, cosi evitiamo conflitti dovuti ad aggiunte applicate da altri branch.

---   

5. **Domanda:** Che cosa rappresentano base branch e head branch in una Pull Request?

    **Risposta:** la base branch è quella che riceve la modifica, di solito il main, mentre la head branch è la tua branch, quella dove hai fatto le modifiche e da cui parte la Pull Request, e la PR in pratica mette le due a confronto per farti vedere il diff tra quello che c'è già e cosa stai proponendo.

---

6. **Domanda:** Perché una review non dovrebbe limitarsi a controllare che il codice "funzioni"? 

    **Risposta:** perchè possono essere stati aggiunti refusi dovuti da prove fatte in precedenza, di conseguenza codice "morto" utile solo a sporcare il 'main' mandando in confusione un futuro collaboratore. Poi bisogna controllare anche che nel diff non sia finito dentro qualcosa che non doveva esserci, tipo file che non c'entrano o magari token e password lasciati per sbaglio, che il codice si legga bene da chi lo rivede e che non stia rompendo qualcosa che prima funzionava.

--- 

7. **Domanda:** Che cosa succede a una Pull Request quando il contributor aggiunge un nuovo commit allo stesso branch?

    **Risposta:** viene aggiornata da sola e mostra anche il nuovo commit, non serve aprirne un'altra. il push va comunque fatto a mano da chi contribuisce, ma una volta pushato il reviewer se lo ritrova dentro la Pull Request che aveva già aperto, pronto per essere rivisto di nuovo.

---

8. **Domande:** Che cosa provoca tipicamente un merge conflict? 

    **Risposta:** Quando il mio branch non è in linea con il main, e mentre io effettuavo modifiche sul mio branch un altro collaboratore ha già pushato modifiche sullo stesso pezzo di codice.

---

9. **Domande:** Perché l'accesso del collaboratore deve essere rimosso al termine?

    **Risposta:** perchè secondo il principio di **least privilege** gli diamo l'accesso solo per il tempo necessario, così riduciamo il rischio che vengano effettuate modifiche a nostra insaputa anche dopo.

---

10. **Domanda:** Distingui frontend, backend/API, configurazione e dati nel Catalogo prodotti.

    **Risposta:** 
    - **Frontend:** è la parte che vede l'utente e con cui ha interazione, qui è dove appaiono a schermo i prodotti (`static/index.html`).
    - **Backend/API:** `server.py`, si occupa di rispondere alle richieste HTTP e tirare fuori i dati in JSON, gestisce solo `GET` quindi legge i prodotti da un file e te li restituisce, niente di più.
    - **Configurazione:** `config.json`, i parametri che regolano il server tipo host, porta, prefisso delle API e la soglia sotto cui uno stock diventa "LOW", tenuti separati dal codice così se cambi un valore non devi toccare `server.py`.
    - **Dati:** `data/products.json`, l'elenco dei prodotti veri e propri che il backend va a leggere e restituisce.

---

11. **Domanda:** Quali endpoint principali espone l'applicazione?

    **Risposta:** 
    `GET /health`, `GET /api/products` , `GET /api/products/<id>` e `GET /`

---    

12. **Domanda:** Perché è utile eseguire `git diff` prima del commit?

    **Risposta:** perchè ti fa vedere le modifiche che non sono ancora in staging, cioè cosa è cambiato nella working tree rispetto a quello che hai già aggiunto con `git add`. poi c'è `git diff --cached` che invece ti fa vedere quello che entrerà davvero nel commit, quindi uno lo usi per capire cosa hai cambiato prima di decidere cosa aggiungere, l'altro per controllare cosa stai per salvare per davvero.
