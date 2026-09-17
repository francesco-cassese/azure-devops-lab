# UD09 — Risposte domande concetti

1. **Domanda:** Perché DevOps non può essere ridotto a un prodotto?

    **Risposta:** perchè **DevOps** non è uno strumento che compri, è un modo di lavorare che mette insieme le persone, i processi e la tecnologia. Uno strumento come **Azure DevOps** aiuta, ma da solo non basta a fare DevOps.

---

2. **Domanda:** Quali sono le tre dimensioni principali che abbiamo associato a DevOps?

    **Risposta:** **Cultura**, **Processi** e **Tecnologia**.

---

3. **Domanda:** Perché il lifecycle DevOps è rappresentato come un ciclo?

    **Risposta:** perchè quando si arriva alla parte **MONITOR/FEEDBACK** non è la fine del progetto, li si raccolgono informazioni tipo bug, problemi di prestazioni, incident, richieste degli utenti e queste tornano indietro alla parte di **PLAN**, facendo ripartire il lavoro. Ed è per questo che viene rappresentata da un ciclo.

---

4. **Domanda:** Distingui Agile e DevOps.

    **Risposta:** **Agile** è il modo in cui un team organizza il lavoro, a piccoli pezzi e cambiando strada quando serve. **DevOps** va oltre e si occupa anche di cosa succede dopo, cioè test, rilascio, funzionamento in produzione e monitoraggio. Sono due cose diverse: un team può fare Agile senza rilasciare in automatico, e può avere automazione senza una vera cultura Agile dietro.

---

5. **Domanda:** Che cos'è un backlog?

    **Risposta:** è una lista ordinata di lavoro da fare. Contiene task, bug, miglioramenti e debito tecnico. Gli elementi dentro vengono descritti, messi in ordine di priorità, stimati e raffinati, poi scelti per le prossime iterazioni.

---

6. **Domanda:** Che cos'è uno sprint?

    **Risposta:** è un intervallo di tempo breve e fisso, che si ripete. Il team sceglie in anticipo un gruppo di elementi da realizzare in quel tempo, li completa, verifica il risultato e riceve feedback, che usa per decidere lo sprint successivo.

---

7. **Domanda:** Distingui Scrum e Kanban.

    **Risposta:** **Scrum** organizza il lavoro in sprint e ha tre ruoli, il **Product Owner** che gestisce il backlog e decide le priorità, lo **Scrum Master** che toglie di mezzo gli ostacoli al team, e il **Development Team** che fa il lavoro vero e proprio. **Kanban** invece non usa sprint, fa vedere il lavoro su una board con colonne tipo TO DO, IN PROGRESS, REVIEW, DONE, e ogni task è una card che si sposta. La cosa che conta di più in Kanban è che non puoi tenere troppe cose aperte insieme in una colonna (si chiama **WIP limit**), così si vede subito dove il lavoro si accumula e si blocca.

---

8. **Domanda:** Distingui Epic, Feature, User Story, Task e Bug.

    **Risposta:** l'**Epic** è un'iniziativa molto grande, tipo rifare tutto il sistema di pagamento di un sito. La **Feature** è un pezzo più piccolo dentro quella iniziativa, tipo aggiungere il pagamento con carta. La **User Story** parte dal punto di vista di chi usa il prodotto, tipo "come cliente voglio pagare con la carta per non dover usare il bonifico". Il **Task** è il singolo pezzo di lavoro tecnico per realizzarla, tipo scrivere la funzione che collega il pagamento al gestionale. Il **Bug** è un difetto, qualcosa che non funziona come dovrebbe. Non sono la stessa cosa, sono livelli via via più piccoli, dall'idea grande fino al compito singolo.

---

9. **Domanda:** A che cosa servono gli Acceptance Criteria?

    **Risposta:** servono a definire condizioni verificabili che dicono quando una funzionalità è completa. Per un endpoint possono essere: dato un catalogo con prodotti, quando chiamo GET /api/products, allora ricevo HTTP 200 e una lista JSON dei prodotti. Ogni User Story ha i suoi Acceptance Criteria specifici.

---

10. **Domanda:** Perché il Version Control è importante anche per IaC e pipeline YAML?

    **Risposta:** perchè così sai chi, quando e perchè ha cambiato la configurazione dell'infrastruttura o della pipeline, e puoi tornare a una versione precedente se serve.

---

11. **Domanda:** Distingui build e artifact.

    **Risposta:** la **build** è il processo che parte dal codice sorgente e lo trasforma in qualcosa di deployabile, e cambia in base alla tecnologia usata. L'**artifact** è il risultato finale di quella build, destinato alle fasi successive. Il vantaggio è riusare lo stesso artifact in test e produzione, senza rifare la build ogni volta in ogni ambiente.

---

12. **Domanda:** Distingui unit test, integration test e smoke test.

    **Risposta:** l'**unit test** verifica una piccola unità di codice isolata, tipo una classe, una funzione o un metodo. L'**integration test** verifica l'interazione tra più componenti, tipo API e database. Lo **smoke test** è un controllo rapido dopo il deploy, non guarda dentro il codice ma solo se il servizio è raggiungibile e se le funzioni essenziali rispondono, tipo un endpoint /health.

---

13. **Domanda:** Che cosa significa shift-left?

    **Risposta:** significa spostare i controlli il prima possibile per scovare eventuali bug il prima possibile nel ciclo di sviluppo, quindi già sul PC o nella Pull Request, invece che aspettare l'ambiente di test o in produzione. Un bug trovato prima costa meno tempo, è più facile da capirne la provenienza e si rischia meno.

---

14. **Domanda:** Definisci Continuous Integration.

    **Risposta:** è la pratica di integrare frequentemente le modifiche nel main, sottoponendole automaticamente a build e test. L'obiettivo è avere un feedback frequente sulle modifiche, non fare una build automatica dopo molto tempo.

---

15. **Domanda:** Distingui Stage, Job e Step.

    **Risposta:** lo **Stage** è una fase logica della pipeline, tipo Test, Build, Deploy, Smoke. Il **Job** è l'insieme degli step eseguiti su un agent, dentro uno Stage. Lo **Step** è una singola azione concreta, tipo eseguire un comando.

---

16. **Domanda:** Distingui Continuous Delivery e Continuous Deployment.

    **Risposta:** sono due modelli molto simili, cambia solo l'ultimo passaggio. Con la **Continuous Delivery**, una volta passati i test, l'artefatto è pronto per essere rilasciato ma serve ancora qualcuno che dia il via libera manualmente. Con il **Continuous Deployment** invece non serve nessuna approvazione, ogni modifica che passa i controlli va dritta in produzione da sola.

---

17. **Domanda:** Distingui Dockerfile, image e container.

    **Risposta:** il **Dockerfile** è il file con le istruzioni per costruire l'image. L'**image** è il risultato di quella costruzione, un pacchetto pronto con dentro tutto quello che serve, e non cambia più una volta creato. Il **container** è quell'image mandata in esecuzione, cioè l'app che gira davvero usando quel pacchetto come base.

---

18. **Domanda:** Che cos'è un registry?

    **Risposta:** è quello che conserva e distribuisce le image.

---

19. **Domanda:** Che problema risolve un orchestrator?

    **Risposta:** quando i container diventano tanti serve qualcuno che decida scheduling, repliche, self-healing, rolling update e scaling al posto tuo, invece di gestirli a mano uno per uno.

---

20. **Domanda:** Che cos'è Infrastructure as Code?

    **Risposta:** significa scrivere un file di testo che descrive l'infrastruttura che vuoi creare, tipo una VM o una rete, invece di crearla a mano cliccando nel portale Azure. Quel file lo salvi con Git come il codice, così sai chi l'ha scritto e quando, e se ti serve la stessa infrastruttura da un'altra parte basta rieseguirlo invece di rifare tutti i click a mano.

---

21. **Domanda:** Che cosa aggiunge DevSecOps al lifecycle?

    **Risposta:** integra la sicurezza dentro tutto il lifecycle, non solo come ultimo controllo prima del rilascio. Per esempio dare solo i permessi che servono, non lasciare token nei repository, controllare le dipendenze prima di usarle.

---

22. **Domanda:** Che cos'è una DevOps toolchain?

    **Risposta:** è un insieme coordinato di strumenti usati lungo il lifecycle, non uno strumento singolo che fa tutto da solo. Un esempio possibile è Azure Boards per il planning, GitHub per il codice, Azure Pipelines per il Continuous Integration, Docker per i container, Azure Container Registry, Bicep e Terraform per l'infrastruttura, Azure Container Apps e Azure Monitor. È solo una delle combinazioni possibili, non l'unica.

---

23. **Domanda:** Quali sono i cinque principali servizi Azure DevOps?

    **Risposta:** Azure Boards, Azure Repos, Azure Pipelines, Azure Test Plans, Azure Artifacts.

---

24. **Domanda:** A che cosa serve Azure Boards?

    **Risposta:** serve per il planning e il tracking del lavoro, offre Work Items, Backlogs, Boards, Sprints, Queries e Dashboards. Supporta diversi processi, tipo Basic, Agile, Scrum e CMMI, e la scelta del processo determina i tipi di Work Item e il workflow disponibili.

---

25. **Domanda:** Perché nel corso usiamo GitHub invece di Azure Repos?

    **Risposta:** per evitare di duplicare lo stesso codice in due sistemi diversi e rischiare che le due copie si disallineino nel tempo.

---

26. **Domanda:** Distingui Azure Test Plans e test automatici in pipeline.

    **Risposta:** Azure Test Plans gestisce test manuali ed esplorativi, cioè Test Plan, Test Suite, Test Case, esecuzioni e risultati fatti da una persona. I test automatici invece sono eseguiti senza intervento umano da una pipeline, tipo Azure Pipelines.

---

27. **Domanda:** Distingui Azure Artifacts e Azure Container Registry.

    **Risposta:** Azure Artifacts gestisce pacchetti di libreria, tipo NuGet, npm, Maven o Python. Azure Container Registry invece gestisce le image dei container Docker. Sono due registri diversi, uno per pacchetti software, l'altro per image.

---

28. **Domanda:** Distingui Organization e Project.

    **Risposta:** l'Organization è il livello amministrativo più alto e può contenere più Project al suo interno, con elementi condivisi tra tutti come utenti, fatturazione e Agent Pool. Il Project è invece lo spazio di lavoro di un singolo progetto, con Boards, Repos, Pipelines, Test Plans, Artifacts e permessi propri, distinti da quelli degli altri Project nella stessa Organization.

---

29. **Domanda:** Distingui Agent, Agent Pool e Parallel Job.

    **Risposta:** l'Agent è il processo o la macchina che esegue davvero un Job. L'Agent Pool è il gruppo di agent tra cui una pipeline può scegliere quello disponibile. Il Parallel Job è la capacità di eseguire più job insieme nello stesso momento, ed è un numero separato dagli agent registrati: avere più agent non aumenta da solo la concorrenza, serve anche una capacità di Parallel Job sufficiente.

---

30. **Domanda:** Distingui Microsoft-hosted e self-hosted Agent.

    **Risposta:** il **Microsoft-hosted** è preparato e gestito da Microsoft, con un ambiente nuovo e pulito a ogni Job, tool già installati e nessuna manutenzione da parte tua, ma l'ambiente sparisce alla fine del Job. Il **self-hosted** gira su una macchina che gestisci tu, l'ambiente resta persistente tra un Job e l'altro e hai il controllo sui tool installati, ma anche la responsabilità di patch, sicurezza e manutenzione.

---

31. **Domanda:** Che cos'è una Service Connection?

    **Risposta:** è un collegamento autenticato tra Azure DevOps e un sistema esterno, tipo GitHub, Azure Resource Manager o un container registry. Che la connessione esista non significa che qualsiasi pipeline possa usarla automaticamente, per questo di solito si evita di concederla a tutte le pipeline insieme.

---

32. **Domanda:** Perché il PAT di registrazione può essere revocato dopo che l'agent è Online?

    **Risposta:** perché serve solo alla registrazione iniziale dell'agent, non viene usato per i Job successivi. Una volta registrato e avviato, l'agent comunica in un altro modo, per questo il PAT può essere revocato senza che l'agent smetta di funzionare.

---

33. **Domanda:** Perché DevOps non coincide con Azure DevOps?

    **Risposta:** perché le pratiche DevOps non appartengono a un solo produttore. Concetti come Version Control, Continuous Integration, pipeline, artifact, Continuous Delivery e Infrastructure as Code si possono realizzare con strumenti diversi, Azure DevOps è solo una delle piattaforme possibili per farlo.

---

34. **Domanda:** Qual è la differenza tra Azure Pipelines e Azure Pipelines Agent?

    **Risposta:** **Azure Pipelines** è il servizio che organizza il lavoro, cioè decide cosa fare e quando. L'**Azure Pipelines Agent** è chi esegue davvero i Job. Sono due cose diverse: uno organizza, l'altro fa il lavoro materiale.

---

35. **Domanda:** Qual è la relazione concettuale tra Azure Pipelines Agent, Jenkins Agent, GitHub Runner e GitLab Runner?

    **Risposta:** fanno tutti la stessa cosa, ognuno per la propria piattaforma (Azure Pipelines, Jenkins, GitHub Actions, GitLab CI/CD): ricevono ed eseguono i Job che la pipeline gli assegna. Confrontare uno di questi con la piattaforma di un'altra, tipo Jenkins Agent contro Azure Pipelines, sarebbe come confrontare due cose che non stanno sullo stesso piano.

---

36. **Domanda:** Quali attività svolgerà concretamente l'Agent nelle UD13–UD15?

    **Risposta:** esegue validazioni IaC e i primi Job di pipeline, poi test, build e push dell'immagine Docker, e infine il deployment con le verifiche e lo smoke test della pipeline completa.

---

37. **Domanda:** Perché un Job Microsoft-hosted non dovrebbe dipendere da file lasciati dal Job precedente?

    **Risposta:** perché l'ambiente hosted viene ricreato pulito a ogni Job, quindi qualsiasi file lasciato lì da un Job precedente sparisce insieme all'ambiente. Un Job che si aspettasse di trovarlo fallirebbe in modo imprevedibile.

---

38. **Domanda:** Perché il WSL2 personale del corso non rappresenta la topologia self-hosted tipica di un team?

    **Risposta:** perché è una simulazione didattica, non vuol dire che ogni sviluppatore trasformi il proprio PC nel server di compilazione del team. In un'organizzazione reale gli sviluppatori fanno solo commit e push, e chi esegue davvero i Job è un **Agent Pool** aziendale gestito centralmente, con macchine dedicate come VM in cloud o server on-premises, non il computer personale di ciascuno.

---

39. **Domanda:** Come può essere organizzato un Agent Pool aziendale?

    **Risposta:** con più agent dedicati, tipo build-agent-01, build-agent-02, build-agent-03, che possono girare su VM Linux o Windows in cloud, VM on-premises o server fisici. La cosa decisiva non è dove si trova la macchina, ma chi la gestisce: un self-hosted Agent aziendale è infrastruttura gestita dall'organizzazione, non il PC di un singolo sviluppatore. Gli Agent Pool possono anche essere condivisi tra più progetti, in base ai permessi.

---

40. **Domanda:** Perché più Agent non implicano automaticamente più Job eseguibili in parallelo?

    **Risposta:** perché sono due cose diverse: 
    l'**Agent** è chi esegue il Job, il **Parallel Job** è quanti Job possono girare insieme nello stesso momento. Con 3 agent Online ma solo 1 parallel job, normalmente ne gira comunque 1 alla volta. Per avere più Job contemporanei servono sia più agent disponibili sia una capacità di Parallel Job sufficiente.

---
