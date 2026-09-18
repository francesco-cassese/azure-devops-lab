# UD10 — Risposte alle domande sui concetti

1. **Domanda:** Qual è la differenza fra codice sorgente, image e container?

    **Risposta:** L'**Image** è un pacchetto pronto e immutabile ma non equivale a un processo d'esecuzione, quello è il **Container**, cioè un'istanza creata a partire da quell'image. Mentre il **Codice Sorgente** è quello che scriviamo noi sviluppatori. 

---

2. **Domanda:** Che cosa fa docker build e che cosa non fa?

    **Risposta:** Il **Docker Build** costruisce solo l'artefatto cioè l'image stessa, ma non la esegue. 

---

3. **Domanda:** Che ruolo hanno Dockerfile, build context e .dockerignore nella creazione di un'image?

    **Risposta:** Il **Dockerfile** è una sequenza logica di passaggi, come ad esempio l'esecuzione di una ricetta, il **build context** invece è l'insieme di file che il builder può realmente vedere e utilizzare durante quella build, quelli che non vede sono quelli elencati in **.dockerignore**, che si occupa di dire a Docker cosa non mandare al builder.

---

4. **Domanda:** Che cosa succede se l'image indicata da FROM non è disponibile localmente?

    **Risposta:** Deve recuperarla da un registry configurato, normalmente **Docker Hub**.

---

5. **Domanda:** Distingui RUN e CMD.

    **Risposta:** **RUN** viene eseguito durante docker build, e le modifiche che produce entrano a far parte dell'image finale, in modo permanente, mentre **CMD** decide invece cosa succede ogni volta che nasce un nuovo container da quella image

---

6. **Domanda:** Perché una modifica a server.py non modifica automaticamente un'image già costruita?

    **Risposta:** Perchè **COPY** aveva già inserito una copia del file nell'image durante la build, e il container esegue quella copia, non il file sul disco. L'image è immutabile, quindi la modifica ci sarà ma solo sul mio file system, l'image non si accorgerà di questa modifica. 

---

7. **Domanda:** A che cosa serve il tag catalog-backend:ud10?

    **Risposta:** serve a dare un nome a quella build precisa: **catalog-backend** è il nome del repository locale dell'image, **ud10** è il **tag**, cioè l'etichetta che la distingue da altre build della stessa image. Senza tag, Docker userebbe di default **latest**, che comunque resta solo una convenzione e non vuol dire davvero "l'ultima versione".

---

8. **Domanda:** Che cosa succede, in ordine, quando eseguiamo docker run catalog-backend:ud10?

    **Risposta:** prima Docker prende l'image catalog-backend:ud10 già pronta, poi crea un nuovo container a partire da essa, e alla fine lancia dentro quel container il comando scritto in **CMD** nel Dockerfile. Qui, senza nessun flag aggiunto, il container parte semplicemente con i valori predefiniti che erano già dentro l'image tramite **ENV**, non con una configurazione diversa.

---

9. **Domanda:** Distingui EXPOSE 8000 e --publish 127.0.0.1:8000:8000.

    **Risposta:** **EXPOSE 8000** non fa niente di concreto verso l'esterno, è solo una nota scritta nell'image che dice su quale porta ascolta l'app. **--publish 127.0.0.1:8000:8000** invece è il collegamento vero, quello che decide che la porta 8000 del container sia raggiungibile dalla porta 8000 del mio computer. Senza quello, anche con EXPOSE scritto, non arriverebbe nessuna richiesta dall'host al container.

---

10. **Domanda:** Che problema risolve Docker Compose rispetto a molti comandi docker run manuali?

    **Risposta:** evita di dover ricordare a mano tutta la sequenza di comandi che servirebbero per far girare backend e frontend insieme: creare le due image, la rete, il volume, avviarli nell'ordine giusto, collegarli, pubblicare la porta giusta. Più sono i pezzi coinvolti, più è facile sbagliare qualcosa per strada. Con **Compose** basta scrivere una volta come deve essere lo stato finale, e lascio a Docker il compito di realizzarlo davvero.

---

11. **Domanda:** Distingui il ruolo di un Dockerfile dal ruolo di compose.yaml.

    **Risposta:** Il **Dockerfile** descrive come deve essere costruita un'image, **Compose** invece descrive come devono far funzionare insieme più servizi. Quindi non sostituisce il Dockerfile ma lo coordina.

---

12. **Domanda:** Che cosa crea/gestisce Compose nella nostra UD10?

    **Risposta:** Nella nostra unità **Compose** definisce: backend e frontend (`services`), una `networks` chiamata `catalog-net` con driver `bridge` e un volume in `volumes` chiamato `catalog-runtime`.

---

13. **Domanda:** Perché docker compose up -d --build può costruire sia backend sia frontend?

    **Risposta:** perchè sia backend sia frontend hanno una loro sezione `build:` nel file, ognuna con il proprio Dockerfile. Quando lancio `--build`, Compose trova entrambe le sezioni `build:` e costruisce entrambe le image, una per servizio, con lo stesso comando.

---

14. **Domanda:** Perché il backend non viene pubblicato direttamente sull'host nello stack Compose?

    **Risposta:** perchè il browser deve passare sempre dal frontend, che poi passa lui le richieste al backend attraverso la rete Docker. Così l'unico punto raggiungibile da fuori è il frontend, non il backend.

---

15. **Domanda:** Perché Nginx usa http://backend:8000 e non http://localhost:8000?

    **Risposta:** Perchè Nginx gira dentro il container frontend, di conseguenza se usasse  http://localhost:8000 cercherebbe quella porta nel suo container, ma il backend gira su un container differente quindi non verrebbe trovato. Di conseguenza si appoggia sul servizio DNS che offre il Docker per poter collegarsi al container del backend. 

---

16. **Domanda:** Che funzione ha catalog-net?

    **Risposta:** è l'etichetta della rete condivisa di Docker che permette il collegamento tra backend e frontend.

---

17. **Domanda:** Che funzione ha catalog-runtime?

    **Risposta:** **catalog-runtime** è il named volume montato nel backend sul percorso `/runtime`. La sua funzione è far sopravvivere i dati scritti lì dentro anche quando il container backend viene rimosso o ricreato, perché quei dati non vivono nel container, vivono nel volume, gestito da Docker separatamente.

---

18. **Domanda:** Perché running e healthy non significano la stessa cosa?

    **Risposta:** **running** dice solo che il processo del container esiste ed è partito, non dice se l'app dentro funziona davvero. **healthy** invece vuol dire che è stato fatto un controllo reale, l'**healthcheck**, e quel controllo ha avuto successo. Un container può essere running senza essere ancora healthy, per esempio appena parte è in stato starting, oppure può restare unhealthy se l'app dentro è rotta pur avendo il processo ancora acceso.

---

19. **Domanda:** Che cosa fa depends_on: condition: service_healthy nel nostro stack?

    **Risposta:** aspettare che un determinato servizio sia pronto e che il suo `healthcheck` passi allo stato `healthy`, prima di far partire il servizio che dipende da lui.

---

20. **Domanda:** Distingui rebuild e recreate.

    **Risposta:** il **rebuild** vuol dire ricostruire l'image da zero, e serve quando cambia qualcosa nel codice o nel Dockerfile. Il **recreate** invece non tocca l'image: spegne e riaccende solo il container, con qualcosa di diverso, tipo un valore cambiato. Quindi se non è cambiato il codice ma solo un valore, non serve rifare tutto da capo, basta il recreate.

---

21. **Domanda:** Quale ordine useresti per diagnosticare uno stack Compose che non risponde?

    **Risposta:** prima guardo `docker compose ps` per vedere stato e health dei container, poi `docker compose logs` sul servizio che sembra il problema, poi `docker compose config` per controllare come Compose ha letto davvero il file. Solo dopo aver visto queste cose decido se serve un recreate o un rebuild, faccio una modifica alla volta e rifaccio il test, invece di modificare tutto insieme a caso.

---

22. **Domanda:** In che modo ciò che facciamo manualmente in UD10 verrà riutilizzato nelle pipeline successive?

    **Risposta:** gli stessi comandi che oggi lancio io a mano, build dell'image e push su un registry, più avanti li lancerà un **Agent** dentro una pipeline: in UD14 farà lui il `docker build` e il push su ACR, in UD15 si occuperà anche del deployment. Il concetto resta identico, cambia solo chi lo esegue davvero.