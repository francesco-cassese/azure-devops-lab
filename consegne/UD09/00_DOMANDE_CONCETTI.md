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
