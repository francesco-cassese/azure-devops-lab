# UD10 — Verifica individuale

## Parte A — Scelta singola

1. **Domanda:** Una Docker image è:<br>
   - A. un processo in esecuzione
   - B. un artefatto usato per creare container
   - C. una VNet
   - D. un volume Windows

   **Risposta:** B. è il pacchetto già pronto con tutto il necessario per far girare l'applicazione: il **container** invece è quello che si ottiene quando lo si fa partire davvero.

---

2. **Domanda:** Nel comando `docker build -f docker/backend.Dockerfile .`, il punto finale rappresenta:<br>
   - A. la porta
   - B. il build context
   - C. il tag
   - D. il registry

   **Risposta:** B. è la cartella che viene mandata a Docker durante la build, da cui si può copiare dentro l'immagine con **COPY**.

---

3. **Domanda:** `EXPOSE 8000`:<br>
   - A. pubblica automaticamente la porta sull'host
   - B. documenta la porta prevista nell'immagine ma non sostituisce `-p`
   - C. crea un NSG
   - D. crea una rete

   **Risposta:** B. **EXPOSE** dichiara solo quale porta userà il container, è documentazione: non apre nulla verso l'host da sola, quello lo fa `-p` o `ports` in Compose.

---

4. **Domanda:** `127.0.0.1:8080:80` significa:<br>
   - A. host 80 → container 8080
   - B. host 127.0.0.1:8080 → container 80
   - C. backend → frontend
   - D. DNS → volume

   **Risposta:** B. la parte prima dei due punti è l'host, quella dopo è il container: qui la porta 8080 del pc arriva alla porta 80 dentro al container.

---

5. **Domanda:** In Compose, due servizi sulla stessa rete possono normalmente raggiungersi tramite:<br>
   - A. IP statico obbligatorio
   - B. nome del servizio
   - C. subscription ID
   - D. tag Git

   **Risposta:** B. su una rete Docker condivisa, i servizi si trovano tra loro chiamandosi per **nome**, non serve un indirizzo IP fisso, lo risolve da solo Docker.

---

6. **Domanda:** Dentro il container frontend, `localhost` indica:<br>
   - A. sempre il backend
   - B. il container frontend stesso
   - C. l'host Windows
   - D. Azure

   **Risposta:** B. dentro un container, **localhost** punta sempre al container stesso, mai a un altro container della stessa rete.

---

7. **Domanda:** `docker compose down -v`:<br>
   - A. conserva tutti i volumi
   - B. rimuove anche i volumi del progetto
   - C. fa push delle immagini
   - D. crea container

   **Risposta:** B. il flag `-v` in più rispetto al semplice `down` cancella anche i **volumi** del progetto, non solo container e rete.

---

8. **Domanda:** Un container `running`:<br>
   - A. è necessariamente healthy
   - B. può essere running ma unhealthy
   - C. non produce log
   - D. non appartiene a una rete

   **Risposta:** B. uno stato **running** dice solo che il processo è acceso, non che risponda bene: per quello serve l'**healthcheck**, che può segnarlo come unhealthy anche se è ancora in esecuzione.

---

## Parte B — Risposte brevi

9. **Domanda:** Distingui image, container e registry.<br>

   **Risposta:** un'**image** è il pacchetto pronto, con dentro tutto il necessario per far girare l'applicazione, ma da fermo, non ancora in esecuzione. Un **container** è quello che si ottiene quando quell'immagine viene fatta partire davvero, un'istanza viva che gira. Un **registry** è il magazzino dove le immagini vengono salvate e da cui vengono scaricate, tipo Docker Hub.

---

10. **Domanda:** Spiega perché il build context dovrebbe essere limitato.<br>

    **Risposta:** perché tutto quello che sta dentro il **build context** viene mandato al motore Docker durante la build, anche i file che non servono davvero. Se il context è troppo grande o generico, la build diventa più lenta, e si rischia di far entrare per sbaglio file che non dovrebbero finire nell'immagine, tipo segreti o cartelle come `.git`. Per questo si tiene il context il più piccolo possibile e si usa il **`.dockerignore`** per escludere quello che non serve.

---

11. **Domanda:** Distingui named volume e bind mount.<br>

    **Risposta:** un **named volume** è gestito interamente da Docker, ha un nome, e vive in uno spazio che Docker si occupa lui di creare e mantenere, senza dover sapere dove sia fisicamente sul disco. Un **bind mount** invece collega direttamente una cartella vera del pc dentro al container, con lo stesso percorso che ha già fuori.

---

12. **Domanda:** Perché le variabili d'ambiente permettono di riusare la stessa immagine?<br>

    **Risposta:** perché i valori che possono cambiare da un ambiente all'altro, tipo la soglia `LOW_STOCK_THRESHOLD`, non vengono scritti dentro all'immagine durante la build, ma passati da fuori quando il container parte. Così la stessa identica immagine può girare con configurazioni diverse in ambienti diversi, senza dover rifare la build ogni volta che cambia solo un valore.

---

13. **Domanda:** Perché il backend Compose non deve necessariamente pubblicare una porta sull'host?<br>

    **Risposta:** perché il backend deve parlare solo con il frontend, non con me da fuori: gli basta stare sulla stessa rete interna di Docker, dove il frontend lo trova già per nome. Pubblicare una porta sull'host serve solo per i servizi che devono essere raggiunti dall'esterno, come il frontend.

---

14. **Domanda:** Quali comandi useresti per iniziare il troubleshooting di uno stack Compose che non risponde?<br>

    **Risposta:** per prima cosa `docker compose ps`, per vedere lo stato di ogni servizio, se è running, healthy o uscito con errore. Poi `docker compose logs <servizio>`, per leggere cosa ha scritto davvero il container, che di solito dice già cosa non va. Se il sospetto riguarda la configurazione, anche `docker compose config`, per vedere i valori effettivi usati da Compose, ed eventualmente `docker inspect` per i dettagli più fini.

---

## Parte C — Scenario

> `docker compose ps` mostra frontend Running e backend Restarting. Il browser restituisce 502. Nei log backend compare `LOW_STOCK_THRESHOLD deve essere un intero, ricevuto: 'abc'`.

15. **Domanda:** Qual è la causa più probabile e qual è la modifica minima?<br>

    **Risposta:** la causa più probabile è che la variabile `LOW_STOCK_THRESHOLD` sia stata scritta con un valore non numerico, `'abc'` invece di un numero: il backend prova a convertirla in intero appena parte, fallisce, va in errore ed esce. Compose lo fa ripartire da solo, per questo risulta `Restarting` in loop, ma fallisce sempre allo stesso modo. La modifica minima è correggere solo quel valore nella configurazione, rimettendo un numero valido, senza toccare nient'altro.

---

16. **Domanda:** È necessario ricostruire l'immagine? Quali verifiche eseguiresti dopo la correzione?<br>

    **Risposta:** no, perché il valore sbagliato è in una configurazione letta a runtime, non dentro al Dockerfile o nel codice: basta correggere il valore e rifare `docker compose up -d`. Dopo la correzione controllerei `docker compose ps`, per vedere che il backend sia tornato **healthy** e non più Restarting, poi `docker compose logs backend`, per essere sicuro che l'errore non compaia più, e infine `curl` su `/health` e `/api/products` passando dal frontend, oltre a un controllo visivo nel browser.

---

17. **Domanda:** Una futura pipeline gira su `pool-ud09-wsl` e lo step `docker build` fallisce con errore di connessione al Docker daemon. Quale componente dell'ambiente controlleresti per primo e perché?<br>

    **Risposta:** controllerei per primo se **Docker** funziona sulla macchina dove gira l'Agent, con `docker info`. Se lì non risponde, la pipeline fallisce allo stesso modo, perché è proprio quella shell a eseguire i comandi del Job.

---

18. **Domanda:** Distingui, rispetto alla disponibilità dei tool, un self-hosted Agent da un Microsoft-hosted Agent.<br>

    **Risposta:** un Agent **Microsoft-hosted** parte ogni volta da una macchina virtuale pulita, con un insieme di strumenti già scelto e preinstallato da Microsoft: se serve qualcosa in più va installato dentro alla pipeline stessa, e non resta per la volta dopo, perché la macchina viene eliminata alla fine del Job. Un Agent **self-hosted** invece gira su una macchina gestita direttamente, quindi tutto quello già presente lì resta disponibile da un Job all'altro, ma tocca anche mantenerlo aggiornato e funzionante.

---

## Cleanup finale

- `docker compose down`: eseguito, rimossi container e rete, il volume non è stato toccato
- volume presente dopo `down`: sì, `catalogo-prodotti_catalog-runtime` c'è ancora
- `docker compose down -v`: eseguito, rimosso anche il volume
- volume rimosso: sì, `docker volume ls` non mostra più niente
- immagini UD10 rimosse: sì, `catalog-backend:ud10` e `catalog-frontend:ud10`, nessun errore di immagine in uso
- prune globale usato: NO
