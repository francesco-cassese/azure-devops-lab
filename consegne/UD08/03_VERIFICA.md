# UD08 — Verifica

## Parte A — Scelta singola

1. **Domanda:** DevOps è:<br>
   - A. soltanto Azure DevOps
   - B. un insieme di cultura, pratiche, automazione e feedback
   - C. soltanto Git
   - D. soltanto Docker

   **Risposta:** B. è un modo di lavorare fatto di cultura, pratiche e feedback, non uno strumento da installare.

---

2. **Domanda:** Continuous Integration significa soprattutto:<br>
   - A. integrare frequentemente modifiche verificabili
   - B. creare VM
   - C. distribuire sempre automaticamente in produzione
   - D. eliminare le review

   **Risposta:** A. si integrano spesso modifiche piccole e si verificano subito, invece di accumulare conflitti lavorando isolati per settimane.

---

3. **Domanda:** `git add`:<br>
   - A. effettua push
   - B. sposta modifiche nella staging area
   - C. crea una Pull Request
   - D. esegue merge

   **Risposta:** B. sposta la modifica nella staging area, pronta per il commit ma non ancora salvata nella cronologia.

---

4. **Domanda:** In una Pull Request `feature/x → main`, la head branch è:<br>
   - A. `main`
   - B. `feature/x`
   - C. `origin`
   - D. nessuna

   **Risposta:** B. `feature/x` contiene la proposta ed è da qui che parte la Pull Request, `main` è la base che la riceve.

---

5. **Domanda:** Una review con `Request changes`:<br>
   - A. elimina la PR
   - B. consente di chiedere modifiche prima del merge
   - C. crea un repository
   - D. effettua automaticamente rollback

   **Risposta:** B. chiede una correzione prima dell'approvazione, non blocca la Pull Request in modo definitivo.

---

6. **Domanda:** Un merge conflict si verifica quando:<br>
   - A. Git può sempre scegliere automaticamente
   - B. Git non può determinare in sicurezza il contenuto finale
   - C. il repository è vuoto
   - D. il branch è locale

   **Risposta:** B. succede quando due branch cambiano la stessa parte di un file in modo incompatibile e Git non può scegliere da solo.

---

7. **Domanda:** Nel Catalogo prodotti, `/api/products` appartiene principalmente a:<br>
   - A. frontend
   - B. backend/API
   - C. Git staging
   - D. review

   **Risposta:** B. è l'endpoint che `server.py` espone e gestisce, quindi è responsabilità del backend, non del frontend.

---

8. **Domanda:** Perché eseguire `git diff --cached`?<br>
   - A. per vedere le modifiche che entreranno nel prossimo commit
   - B. per cancellare il branch
   - C. per creare l'API
   - D. per autenticarsi a GitHub

   **Risposta:** A. mostra esattamente cosa entrerà nel prossimo commit, diverso da `git diff` che mostra le modifiche non ancora in staging.

---

## Parte B — Risposte brevi

9. **Domanda:** Distingui Continuous Delivery e Continuous Deployment.<br>

   **Risposta:** la differenza sta nell'ultimo passaggio. Con Continuous Delivery il software è pronto ma serve ancora qualcuno che clicchi "Deploy". Con Continuous Deployment invece va in produzione da solo, senza intervento umano.

---

10. **Domanda:** Perché è utile creare un feature branch invece di lavorare sempre direttamente su `main`?<br>

    **Risposta:** perché `main` deve restare stabile, non si può rischiare di romperla con delle prove fatte direttamente lì sopra.

---

11. **Domanda:** Che cosa succede alla stessa Pull Request quando vengono aggiunti nuovi commit al suo head branch?<br>

    **Risposta:** si aggiorna da sola, non serve aprirne un'altra: il nuovo commit compare nella stessa Pull Request già aperta, pronta per essere rivista di nuovo.

---

12. **Domanda:** Elenca almeno quattro controlli utili in una code review.<br>

    **Risposta:** almeno questi quattro: niente codice "morto" lasciato lì da prove precedenti, niente file estranei nel diff, niente token o password lasciati per sbaglio, e nessuna regressione, cioè non deve rompere qualcosa che prima funzionava.

---

13. **Domanda:** Spiega perché l'accesso temporaneo di un collaboratore deve essere rimosso.<br>

    **Risposta:** per il principio di least privilege, l'accesso va tenuto solo per il tempo necessario. Finita la collaborazione non porta più nessun beneficio, il lavoro è già fatto, ma resta comunque un canale che permette di scrivere sul repository: se quell'account venisse compromesso più avanti, chi lo controlla potrebbe ancora modificare il codice.

---

14. **Domanda:** Distingui frontend, backend/API, configurazione e dati nel Catalogo prodotti.<br>

    **Risposta:** il frontend è `static/index.html`, quello che vede l'utente. Il backend/API è `server.py`, risponde alle richieste e restituisce i dati in JSON. La configurazione è `config.json`, i parametri come porta e prefisso API. I dati sono `data/products.json`, l'elenco dei prodotti veri e propri.

---

## Parte C — Scenario

> Una Pull Request modifica `config.json`, `server.py`, un file di consegna di un'altra UD e contiene anche un file chiamato `token.txt`. I test HTTP non sono documentati.

15. **Domanda:** Quali problemi individui prima del merge?<br>

    **Risposta:** il file `token.txt` fa pensare a un segreto lasciato dentro per sbaglio, non dovrebbe mai finire in un commit. C'è anche un file di consegna di un'altra UD, che non c'entra niente con questa modifica. In più i test HTTP non sono documentati, quindi non si può verificare che il fix funzioni davvero prima di approvare.

---

16. **Domanda:** Quale sequenza di correzione e verifica richiederesti prima di approvare?<br>

    **Risposta:** prima di tutto toglierei dal diff il file di consegna dell'altra UD, visto che non c'entra niente con questa modifica. Poi per `token.txt` non basta cancellarlo con un commit, perché resta comunque recuperabile dalla cronologia, quindi va anche revocato e rigenerato un token nuovo. A quel punto chiederei di documentare anche i test HTTP, tipo `/health`, `/api/products`, un prodotto esistente e uno che non esiste per vedere il 404. Solo dopo tutte queste correzioni, con un nuovo push e un altro controllo del diff, approverei la Pull Request.
