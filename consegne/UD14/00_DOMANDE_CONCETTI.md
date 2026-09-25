# UD14 — Domande concetti

1. **Domanda:** Qual è lo scopo principale della Continuous Integration?

    **Risposta:** Serve a far passare ogni modifica del codice dagli stessi controlli, nello stesso ordine e con le stesse regole, in modo automatico. Così il risultato non dipende da chi lancia i comandi a mano né da come è configurato il suo computer.

---

2. **Domanda:** Perché eseguiamo i test prima della build Docker?

    **Risposta:** Perché se i test falliscono non ha senso costruire e pubblicare una nuova immagine: sarebbe un'immagine con del codice che non funziona. Per questo lo stage Test viene prima dello stage BuildPush, e se Test fallisce BuildPush non parte. Il principio è: prima verifico, poi produco.

---

3. **Domanda:** Che cosa significa realmente una pipeline verde?

    **Risposta:** Significa solo che i controlli che abbiamo deciso di mettere nella pipeline sono passati. Nel lab i controlli sono 3 test e una build Docker. Non vuol dire che il software non abbia bug, che sia sicuro o che si possa mettere in produzione senza altre verifiche, perché la pipeline controlla solo quello che le abbiamo chiesto di controllare.

---

4. **Domanda:** Perché `Build.BuildId` è più utile di `latest` come tag dell'immagine?

    **Risposta:** Perché il BuildId è un numero diverso a ogni run, quindi ogni immagine ha un tag tutto suo e posso risalire alla run che l'ha prodotta. Nel lab l'immagine è `catalog-backend:7`: il 7 mi dice da quale build arriva. `latest` invece è sempre "l'ultima", quindi non mi dice quale versione sia e cambia a ogni pubblicazione.

---

5. **Domanda:** Qual è la differenza tra `sc-azure-ud13-15` e `sc-acr-ud14`?

    **Risposta:** Sono due service connection, cioè due permessi che la pipeline usa per entrare in un servizio esterno, e servono per due scopi diversi. `sc-azure-ud13-15` è di tipo Azure Resource Manager e serve a gestire le risorse Azure, per esempio creare l'ACR in UD13. `sc-acr-ud14` è di tipo Docker Registry e serve solo a far autenticare il task `Docker@2` verso l'ACR per fare il push dell'immagine. Tenerle separate aiuta anche a capire dove cercare un errore: se il push su ACR dà `401` o `403` guardo `sc-acr-ud14`, se fallisce la gestione delle risorse guardo quella ARM.

---

6. **Domanda:** Perché l'admin user dell'ACR rimane disabilitato?

    **Risposta:** Perché la connessione verso ACR usa Workload Identity Federation, quindi non c'è nessuna password da salvare né nel YAML né altrove. Se non ci sono username e password da usare, l'admin user non serve, e tenerlo spento evita di avere credenziali del registry che qualcuno potrebbe rubare. Nel lab l'ho controllato con `az acr list`: `Admin` risulta `False`.

---

7. **Domanda:** Qual è l'effetto del trigger sul branch `main`?

    **Risposta:** Un nuovo commit su `main`, per esempio dopo il merge di una Pull Request, avvia da solo una nuova run della pipeline CI. In UD13 avevo messo `trigger: none` e la lanciavo io a mano, in UD14 invece la CI parte da sola quando il codice arriva su `main`.

---

8. **Domanda:** Perché due Job Microsoft-hosted distinti effettuano entrambi il checkout del repository?

    **Risposta:** Perché ogni Job Microsoft-hosted parte su una VM temporanea, che può essere diversa da quella dell'altro Job. Quindi `PythonTests` e `DockerBuild` non si trovano i file già pronti e ciascuno deve scaricare il repository con `checkout: self`. Non è un lavoro doppio inutile: sono due macchine che non condividono niente.

---

9. **Domanda:** Che cosa significa che un Job Microsoft-hosted riceve un ambiente temporaneo?

    **Risposta:** Significa che ogni Job riceve una VM nuova, gestita da Microsoft e non da me, che poi viene buttata via. Un Job non può quindi contare sui file lasciati dal Job precedente, come succederebbe invece sul mio WSL2 che non si azzera. Nel lab `PythonTests` e `DockerBuild` sono due Job diversi e per questo ciascuno fa il proprio checkout.

---

10. **Domanda:** Qual è la differenza fra responsabilità dell'Agent e responsabilità della service connection?

    **Risposta:** L'Agent è la macchina che esegue i task, la service connection è l'identità con cui quei task entrano nel servizio esterno. Serve per capire dov'è un problema: se manca `docker` è un problema dell'Agent, se `docker` c'è ma il push su ACR viene rifiutato è un problema di identità e permessi, cioè della service connection.

---

11. **Domanda:** Perché verifichiamo `python3 --version` e `docker --version` nei Job?

    **Risposta:** Perché mi fanno capire subito se un errore è dell'applicazione o dell'ambiente in cui gira la pipeline. Se il Job non trova `docker`, non ha senso andare a guardare la service connection verso ACR, perché non è ancora arrivato al punto di autenticarsi. Nel lab nel log ho letto Python 3.12.3 e Docker 28.0.4.

---

12. **Domanda:** Quando utilizziamo il file YAML self-hosted di fallback?

    **Risposta:** Quando non posso usare i Microsoft-hosted Agent, per esempio per grant, billing o policy esterne. In quel caso uso `azure-pipelines-ci-selfhosted.yml`, che fa la stessa CI ma sul pool `pool-ud09-wsl`, e devo avere `run.sh` acceso nel WSL2. Nel lab non è servito, perché il Microsoft-hosted aveva 1 parallel job gratuito.

---

13. **Domanda:** A cosa serve `workspace.clean: all` nel fallback self-hosted?

    **Risposta:** Serve a cancellare tutta l'area di lavoro del Job prima che parta. Sul self-hosted, cioè il mio WSL2, i file restano da una run all'altra, e senza pulizia la pipeline potrebbe sembrare corretta solo perché trova file rimasti da prima. Sul Microsoft-hosted non serve, perché la VM è nuova a ogni Job: infatti nel file principale c'è solo il `clean: true` del checkout.

---

14. **Domanda:** Che cosa fa `Docker@2` con `buildAndPush`?

    **Risposta:** Fa tre cose di seguito in un solo passo: costruisce l'immagine dal Dockerfile, le mette il tag e la pubblica nell'ACR. Per autenticarsi non uso un `docker login` con username e password scritti nel YAML, ma la service connection `sc-acr-ud14`. Nel lab il risultato è stata l'immagine `catalog-backend` con il tag 7, che ho ritrovato in ACR con `az acr repository show-tags`.

---

15. **Domanda:** In quale ordine conviene leggere i log quando una pipeline fallisce?

    **Risposta:** Dall'alto verso il basso: Stage, Job, Step, comando e infine il messaggio di errore. Così restringo subito il campo invece di leggere il log come un unico blocco. Nel lab sarebbe: lo stage Test o BuildPush, poi il Job PythonTests o DockerBuild, poi lo step, per esempio Run Python tests o Build and push to ACR.

---

16. **Domanda:** Perché un errore nei test non deve portarci immediatamente a controllare ACR?

    **Risposta:** Perché se falliscono i test la pipeline non è ancora arrivata al push: lo stage BuildPush non parte, quindi ACR e la service connection non c'entrano niente. Se fallisce un test Python guardo il codice e i test. ACR diventa importante solo se la build Docker riesce ma il push risponde `401` o `403`.

---

17. **Domanda:** Che cosa dimostra il test failure intenzionale del laboratorio autonomo?

    **Risposta:**

---

18. **Domanda:** Perché non eliminiamo ACR e immagini al termine della UD14?

    **Risposta:** Perché l'immagine costruita dalla CI è quella che UD15 deve prendere e distribuire. Se cancello l'ACR o il Resource Group `rg-ud13-15-delivery` perdo `catalog-backend:7` e devo rifare la CI. La CI finisce proprio dove inizia la distribuzione, e per questo l'output di UD14 è l'input di UD15.

---

19. **Domanda:** In che modo la UD14 prepara direttamente il lavoro della UD15?

    **Risposta:** Produce l'immagine che UD15 deve distribuire. La CI di UD14 verifica il codice, costruisce l'immagine e la pubblica in ACR con un tag che identifica la run, nel lab `catalog-backend:7`. UD15 parte da quell'immagine per la distribuzione, e per questo ACR, immagini e service connection restano al loro posto. Il punto in cui finisce la CI è quello in cui comincia la Continuous Delivery.

---
