# UD11 — Risposte alle domande sui concetti

1. **Domanda:** Distingui registry, repository, tag e digest.

    **Risposta:** Il **registry** è il posto dove vengono conservate le image, in Azure è **Azure Container Registry**, un registry privato che sta dentro la mia sottoscrizione. Dentro al registry, il **repository** raggruppa tutte le versioni della stessa image, per esempio catalog-backend. Ogni versione ha il suo **tag**, un'etichetta leggibile tipo v1 o v2, ma è solo un nome: posso riusarlo e farlo puntare a un contenuto diverso. Il **digest** invece non lo scelgo io, viene calcolato dal contenuto stesso: se il contenuto cambia, cambia anche il digest, quindi è più sicuro del tag quando devo essere certo di quale image sto usando.

---

2. **Domanda:** Perché non conviene basare una release solo sul tag `latest`?

    **Risposta:** Perché **latest** è un tag come tutti gli altri, non ha niente di speciale: Docker e Azure non controllano se sia davvero la versione più recente o quella approvata, quindi potrebbe puntare a qualcosa di diverso da quello che penso. Con **v1** e **v2** invece so sempre cosa sto distribuendo, e se mi chiedono quale image sta girando in una certa revision posso rispondere.

---

3. **Domanda:** Perché il login server ACR va letto dalla risorsa invece di costruirlo manualmente?

    **Risposta:** Perché il nome che do io alla risorsa e il **login server** non sono la stessa cosa: il login server è l'indirizzo che si usa davvero nei riferimenti alle image, e finisce con **.azurecr.io**. Se lo scrivo a mano rischio di sbagliare o di dare per scontato un formato, mentre leggendolo dalla risorsa con `az acr show --query loginServer` prendo il valore vero restituito da Azure.

---

4. **Domanda:** Qual è la differenza tra Container Apps Environment e Container App?

    **Risposta:** La **Container App** è l'applicazione vera e propria, quella che gira dentro un container. Il **Container Apps Environment** invece è l'ambiente in cui vivono una o più Container App, che lo condividono tra loro: non è l'applicazione, è lo spazio in cui viene eseguita.

---

5. **Domanda:** Distingui revision e replica.

    **Risposta:** La **revision** è una versione della Container App che rimane fissa: contiene la configurazione di quel momento, come l'image, le variabili d'ambiente o le regole di scaling, e se cambio una di queste cose Azure ne crea una nuova. La **replica** invece è l'istanza che sta girando davvero di quella revision: ce ne può essere una, più di una, o nessuna, per esempio quando **minReplicas** è 0 e nessuno sta usando l'app.

---

6. **Domanda:** A che cosa serve ingress?

    **Risposta:** L'**ingress** è la porta d'ingresso della Container App, serve a far arrivare le richieste da internet fino all'applicazione, e se è **external** si può raggiungere da fuori con un normale indirizzo web.

---

7. **Domanda:** Perché target port deve coincidere con la porta di ascolto dell'applicazione?

    **Risposta:** Perchè altrimenti la Container App esiste, la revision sembra funzionare, ma effettivamente sta puntando su una porta in cui nessuno è in ascolto, quindi l'URL non è raggiungibile. 

---

8. **Domanda:** Perché usare managed identity per il pull da ACR?

    **Risposta:** Perché il registry è privato, quindi la Container App deve dimostrare di poter scaricare l'image. Potrei usare username e password di ACR, ma sarebbero segreti da custodire e da cambiare ogni tanto. Con la **managed identity** invece l'app si autentica con un'identità gestita da Azure, senza nessuna password, e le do solo il ruolo **AcrPull**, cioè il permesso di scaricare le image, non di caricarle o cancellarle.

---

9. **Domanda:** A che cosa serve `AcrPull`?

    **Risposta:** **AcrPull** è un ruolo che permette solo di scaricare le image da un registry. Lo si dà all'identità della Container App, perché per far partire l'applicazione deve solo leggere l'image, non pubblicarne di nuove: il caricamento lo fa chi pubblica l'image, per esempio uno sviluppatore o una pipeline, quindi alla Container App non serve **AcrPush**.

---

10. **Domanda:** Che cosa succede tipicamente quando aggiorni l'image di una Container App?

    **Risposta:** Viene creata una nuova revision, perché l'image fa parte della configurazione della Container App e ogni volta che cambia Azure ne crea una nuova invece di modificare quella vecchia. Nella modalità con una sola revision attiva, la nuova prende il posto della precedente, che resta attiva finché la nuova non è pronta.

---

11. **Domanda:** Perché in UD11 eseguiamo manualmente operazioni che verranno automatizzate in UD14–UD15?

    **Risposta:** Perché prima di automatizzare una procedura bisogna capire cosa si sta automatizzando: chi fa il push, chi fa il pull, quale identità viene usata e cosa succede quando cambia l'image. Facendole a mano vedo ogni passaggio e posso controllarlo, così quando le farà una pipeline so cosa deve fare e dove guardare se qualcosa non funziona.

---

12. **Domanda:** Qual è la differenza fra RBAC Registry Permissions e RBAC+ABAC rispetto ai ruoli `AcrPull`/`AcrPush`?

    **Risposta:** Con **RBAC Registry Permissions**, la modalità classica, i permessi valgono per l'intero registry e si usano i ruoli **AcrPull** e **AcrPush**. Con **RBAC+ABAC** invece i permessi si possono decidere repository per repository, e in questo caso AcrPull e AcrPush non vengono usati per l'accesso ai repository, ma si usano ruoli più recenti come **Container Registry Repository Reader** e **Container Registry Repository Writer**. Quindi il ruolo giusto da assegnare dipende sempre da come è configurato il registry.

---

13. **Domanda:** Perché il self-hosted Agent di UD09 non è necessario per svolgere UD11, pur essendo collegato alla progressione del corso?

    **Risposta:** Perché i comandi li lancio io a mano dal terminale, quindi non serve nessun **Agent** che li faccia al posto mio. Servirà più avanti, quando queste operazioni verranno fatte in automatico da una pipeline.

---

14. **Domanda:** Distingui system-assigned e user-assigned managed identity.

    **Risposta:** La **system-assigned** appartiene a una sola risorsa, nasce insieme a lei e sparisce quando la risorsa viene eliminata. La **user-assigned** invece si crea a parte, posso usarla su più risorse e resta anche se ne elimino una.

---

15. **Domanda:** Che cosa significa scale-to-zero?

    **Risposta:** Vuol dire che quando nessuno usa la Container App può spegnersi del tutto, cioè scendere a zero repliche, e così non usa risorse di calcolo finché non arriva una nuova richiesta. Il registry e le altre risorse invece restano lì.

---

16. **Domanda:** Quali controlli eseguiresti se il FQDN restituisce errore dopo una nuova revision?

    **Risposta:** Prima controllo che l'**ingress** sia esterno e che la porta sia quella giusta, poi guardo se la **revision** è attiva e sana e se c'è almeno una replica accesa, e leggo i **log** per capire l'errore. Se non parte controllo anche che l'image sia nel registry, che l'identità abbia il permesso di scaricarla (**AcrPull**) e che le variabili siano giuste, andando in ordine così evito di cambiare cose a caso.

---
