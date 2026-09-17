# UD09 — Verifica individuale

## Parte A — Scelta singola

1. **Domanda:** DevOps è principalmente:<br>
   - A. un prodotto Microsoft
   - B. un insieme di cultura, pratiche e tecnologie che collegano sviluppo, delivery e operation
   - C. un sinonimo di Docker
   - D. un linguaggio YAML

   **Risposta:** B. non è un prodotto da comprare, è un modo di lavorare: abitudini e pratiche che uniscono chi scrive il codice, chi lo consegna e chi lo tiene acceso dopo.

---

2. **Domanda:** Agile e DevOps:<br>
   - A. sono esattamente la stessa cosa
   - B. sono incompatibili
   - C. Agile riguarda soprattutto lavoro iterativo/adattivo; DevOps estende il flusso a delivery e operation
   - D. DevOps sostituisce il Version Control

   **Risposta:** C. **Agile** organizza il lavoro a piccoli passi, **DevOps** allunga quello stesso ritmo fino al rilascio e a dopo, quando il software è già acceso e in funzione.

---

3. **Domanda:** Un backlog è:<br>
   - A. un elenco ordinato di lavoro da realizzare
   - B. un file di log
   - C. un container registry
   - D. un Agent Pool

   **Risposta:** A. è la lista del lavoro da fare, ma in ordine di importanza, non buttata lì a caso.

---

4. **Domanda:** Continuous Integration significa principalmente:<br>
   - A. distribuire automaticamente ogni commit in produzione
   - B. integrare frequentemente e verificare automaticamente build/test
   - C. creare una VM
   - D. fare code review senza test

   **Risposta:** B. vuol dire unire spesso le modifiche di tutti e farle controllare subito da build e test automatici, invece di lasciarle isolate per settimane e ritrovarsi tutti i problemi insieme alla fine.

---

5. **Domanda:** Un artifact è:<br>
   - A. soltanto codice sorgente
   - B. un risultato di build destinato a una fase successiva
   - C. un utente Azure DevOps
   - D. una permission

   **Risposta:** B. è quello che resta dopo aver trasformato il codice in qualcosa di pronto, tipo un pacchetto o un'immagine, e quella stessa cosa passa avanti senza essere rifatta ogni volta.

---

6. **Domanda:** Continuous Deployment si distingue dalla Continuous Delivery perché:<br>
   - A. non usa pipeline
   - B. può portare automaticamente in produzione ogni modifica che supera i gate previsti
   - C. non esegue test
   - D. richiede sempre un deployment manuale

   **Risposta:** B. con la **Continuous Delivery** il software è pronto ma serve ancora un ok manuale, con la **Continuous Deployment** quell'ultimo passo parte da solo se tutti i controlli sono andati bene.

---

7. **Domanda:** Un container registry conserva principalmente:<br>
   - A. User Story
   - B. container image
   - C. sprint
   - D. log KQL

   **Risposta:** B. è il magazzino dove finiscono le immagini già costruite, pronte da prendere e far partire su un'altra macchina.

---

8. **Domanda:** Un orchestrator serve principalmente a:<br>
   - A. gestire scheduling, repliche, scaling e lifecycle di workload containerizzati
   - B. creare commit Git
   - C. scrivere User Story
   - D. generare PAT

   **Risposta:** A. decide dove far girare i container, quante copie tenerne accese e cosa fare se uno si blocca, cose che a mano diventano ingestibili appena i container sono tanti.

---

9. **Domanda:** Azure Boards supporta principalmente:<br>
   - A. planning e tracking del lavoro
   - B. container image
   - C. gestione NSG
   - D. DNS

   **Risposta:** A. è dove si tiene traccia del lavoro da fare e di quanto è avanti, non uno strumento che esegue niente.

---

10. **Domanda:** Nel nostro percorso il repository sorgente rimane:<br>
    - A. Azure Repos
    - B. GitHub
    - C. Azure Artifacts
    - D. Log Analytics

    **Risposta:** B. il codice resta in un solo posto, così non ci sono due copie che con il tempo diventano diverse senza che nessuno se ne accorga.

---

11. **Domanda:** Un agent è:<br>
    - A. la capacità/licenza di concorrenza
    - B. il processo/macchina che esegue un job
    - C. un backlog
    - D. un Work Item

    **Risposta:** B. è la macchina che esegue davvero i comandi scritti nella pipeline, non quella che decide quando o come farlo.

---

12. **Domanda:** Un parallel job rappresenta:<br>
    - A. la capacità di eseguire job contemporaneamente
    - B. la versione dell'agent
    - C. una branch
    - D. un container

    **Risposta:** A. dice quanti lavori possono girare insieme nello stesso momento. Con un solo parallel job si va avanti comunque uno alla volta, anche avendo tante macchine pronte.

---

## Parte B — Risposte brevi

13. **Domanda:** Distingui Scrum e Kanban.<br>

    **Risposta:** **Scrum** divide il lavoro in blocchi di tempo fissi e ripetuti, gli sprint, alla fine dei quali il gruppo controlla il risultato e si adatta per il prossimo; dentro ci sono ruoli precisi, tipo chi ordina le priorità e chi realizza il lavoro. **Kanban** non ha questi blocchi di tempo, mostra il lavoro che scorre in continuo su una bacheca a colonne (da fare, in corso, fatto) e usa un limite preciso, il **WIP limit**, per non far accumulare troppe cose aperte insieme in una colonna.

---

14. **Domanda:** Distingui Epic, Feature, User Story e Task.<br>

    **Risposta:** l'**Epic** è un'iniziativa grande, troppo ampia per essere realizzata in un'unica volta. La **Feature** è una capacità concreta del prodotto dentro quell'Epic, un pezzo più piccolo e già gestibile. La **User Story** racconta un bisogno specifico visto dal punto di vista di chi userà la cosa. Il **Task** è l'attività tecnica precisa che serve per realizzare quella Story. Vanno in ordine: prima l'Epic, poi le Feature che lo compongono, poi le User Story dentro ogni Feature, poi i Task dentro ogni Story.

---

15. **Domanda:** Distingui build e artifact.<br>

    **Risposta:** la **build** è il processo che trasforma il codice sorgente in qualcosa che si può eseguire o distribuire, tipo una compilazione o la costruzione di un'immagine: è un'azione che succede. L'**artifact** è l'output preciso di quel processo, la cosa concreta pensata per essere usata nella fase dopo, senza doverla ricostruire di nuovo diversa a ogni passaggio.

---

16. **Domanda:** Distingui unit test, integration test e smoke test.<br>

    **Risposta:** lo **unit test** controlla un pezzo piccolo e isolato di codice, tipo una singola funzione o metodo, senza tirare in mezzo il resto del sistema. L'**integration test** controlla se più pezzi messi insieme funzionano bene tra loro, tipo l'API che parla davvero con il database. Lo **smoke test** invece non è un controllo approfondito: è veloce e viene fatto appena dopo il rilascio, solo per verificare che il servizio sia raggiungibile e che le funzioni essenziali rispondano.

---

17. **Domanda:** Che cosa significa shift-left?<br>

    **Risposta:** **shift-left** vuol dire spostare i controlli il più presto possibile dentro il ciclo di sviluppo: prima sul PC di chi scrive il codice, poi nella revisione della modifica, poi nei controlli automatici, poi nell'ambiente di test, invece di scoprire l'errore solo alla fine in produzione. Un errore trovato prima è più facile da individuare, costa meno e rischia meno.

---

18. **Domanda:** Distingui Stage, Job e Step.<br>

    **Risposta:** lo **Stage** è una fase logica della pipeline, tipo test, build o rilascio. Il **Job** è l'insieme di step che viene eseguito da un agent dentro quello Stage. Lo **Step** è la singola operazione, una dopo l'altra, dentro il Job, tipo lanciare un comando specifico. Vanno in ordine: Pipeline, poi Stage, poi Job, poi Step.

---

19. **Domanda:** Distingui Azure Repos, Azure Pipelines, Azure Test Plans e Azure Artifacts.<br>

    **Risposta:** **Azure Repos** tiene il codice con branch, Pull Request e review, come repository Git della piattaforma. **Azure Pipelines** automatizza build, test, packaging e deployment. **Azure Test Plans** gestisce i test manuali ed esplorativi, quindi fatti a mano da una persona, diverso dai test automatici che girano dentro una pipeline. **Azure Artifacts** conserva pacchetti già pronti da riusare (tipo NuGet o npm), diverso da un magazzino di immagini container come l'Azure Container Registry.

---

20. **Domanda:** Distingui Organization, Project, Agent Pool e Agent.<br>

    **Risposta:** l'**Organization** è il contenitore amministrativo più alto, con dentro utenti, billing e le impostazioni di sicurezza. Il **Project** è lo spazio di lavoro dentro l'Organization, che collega Boards, Repos, Pipelines e gli altri servizi. L'**Agent Pool** è il raggruppamento organizzativo di più agent, a cui una pipeline si rivolge quando deve far eseguire un job. L'**Agent** è la singola macchina o processo dentro quel pool che esegue davvero il lavoro.

---

21. **Domanda:** Distingui Microsoft-hosted e self-hosted Agent.<br>

    **Risposta:** il **Microsoft-hosted** agent riceve un ambiente appena preparato da Microsoft per ogni job, con i tool già installati, e viene poi rimosso: comodo perché non richiede manutenzione, ma un job non può contare su file lasciati da un job precedente. Il **self-hosted** agent gira invece su una macchina che gestiamo noi, quindi resta persistente e possiamo installarci sopra esattamente i tool che servono, ma tocca a noi occuparci di patch, sicurezza e disponibilità.

---

22. **Domanda:** Perché `Grant access permission to all pipelines` non è la scelta predefinita consigliabile?<br>

    **Risposta:** perché quell'opzione darebbe accesso alla connessione a qualsiasi pipeline del progetto, comprese quelle create dopo e mai controllate per quello scopo. Il criterio giusto è autorizzare esplicitamente solo le pipeline che devono davvero usare quella connessione, così se una di loro viene compromessa il danno resta limitato a lei e non si estende a tutte.

---

23. **Domanda:** Perché il PAT di registrazione dell'agent può essere revocato dopo la configurazione?<br>

    **Risposta:** perché il PAT serve solo nel momento della registrazione, quando l'agent viene collegato per la prima volta al pool. Da quel momento in poi l'agent resta collegato con la registrazione già fatta, non con quel token, quindi revocarlo dopo non tocca il suo funzionamento quotidiano.

---

24. **Domanda:** Azure Pipelines e Azure Pipelines Agent sono la stessa cosa? Spiega la differenza.<br>

    **Risposta:** no, sono due cose diverse anche se il nome si assomiglia. **Azure Pipelines** è la piattaforma che orchestra il lavoro, cioè decide quando e su quale agent un job deve partire. L'**Azure Pipelines Agent** è il componente che esegue materialmente i comandi di quel job, sull'agent scelto. Uno organizza il lavoro, l'altro lo fa girare davvero.

---

25. **Domanda:** Associa correttamente:<br>

    ```text
    Azure Pipelines
    Jenkins
    GitHub Actions
    GitLab CI/CD
    ```

    con:

    ```text
    Azure Pipelines Agent
    Jenkins Agent
    Runner
    GitLab Runner
    ```

    **Risposta:**
    | Piattaforma | Chi esegue davvero il lavoro |
    |---|---|
    | Azure Pipelines | Azure Pipelines Agent |
    | Jenkins | Jenkins Agent |
    | GitHub Actions | Runner |
    | GitLab CI/CD | GitLab Runner |

---

26. **Domanda:** Perché Jenkins viene citato nella UD09 anche se non lo utilizzeremo operativamente?<br>

    **Risposta:** perché la sua architettura mostra lo stesso schema che troviamo in Azure Pipelines: un **Jenkins Controller** che orchestra e assegna il lavoro, e uno o più **Jenkins Agent** che lo eseguono materialmente, proprio come Azure Pipelines si appoggia all'Azure Pipelines Agent. Questo fa capire che pipeline, job, agent, build, test e deployment sono concetti DevOps generali, non caratteristiche esclusive di un singolo prodotto Microsoft.

---

27. **Domanda:** Quali compiti svolgerà concretamente un Agent nelle UD13–UD15?<br>

    **Risposta:** in UD13 esegue le validazioni dell'infrastruttura scritta come codice, tipo `terraform validate`, e i primi job di pipeline. In UD14 lancia i test del programma e costruisce l'immagine Docker, per poi caricarla nel magazzino container. In UD15 si occupa lui stesso del deployment della pipeline integrata, delle verifiche e dello smoke test finale sul servizio appena rilasciato.

---

28. **Domanda:** Perché prepariamo sia self-hosted sia Microsoft-hosted?<br>

    **Risposta:** perché il self-hosted viene configurato per primo apposta, dato che è quello più controllabile direttamente e fa capire fisicamente dove finiscono per girare i job. Il Microsoft-hosted viene invece verificato e abilitato per avere anche l'opzione gestita da Microsoft, senza doversi occupare della manutenzione della macchina. Preparare entrambi permette poi di usarli e confrontarli in modo consapevole nelle unità successive, invece di conoscerne solo uno dei due.

---

## Parte C — Scenario

> Il portale mostra `agent-wsl-01 Offline`. La registrazione era stata completata correttamente e il PAT è già stato revocato. In WSL2 nessun processo `run.sh` è attivo.

29. **Domanda:** Qual è la prima causa da verificare e quale azione eseguiresti?<br>

    **Risposta:** la prima cosa da controllare è proprio quella scritta nello scenario, cioè che il processo che tiene collegato l'agent non sta più girando. Il token revocato non conta, serviva solo per la registrazione iniziale. L'azione giusta è rientrare nella cartella dell'agent, far ripartire quel processo e controllare sul portale che torni online.

---

30. **Domanda:** Perché non creeresti subito un nuovo PAT e non riconfigureresti l'agent?<br>

    **Risposta:** perché quel token serviva solo una volta, per la registrazione, e qui il problema non è l'accesso ma solo un processo fermo. Rifare la registrazione sarebbe una reazione esagerata, e rischierebbe di rovinare una configurazione che funzionava già bene, per risolvere qualcosa che basta far ripartire.

---

## Parte D — Mappa finale

| Area | Strumento del percorso |
|---|---|
| Planning | Azure Boards |
| Version Control | GitHub |
| CI/CD | Azure Pipelines |
| Container | Docker |
| Registry | Azure Container Registry (ACR) |
| IaC | Bicep + Terraform |
| Runtime | Azure Container Apps |
| Monitoring | Azure Monitor |
