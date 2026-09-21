# UD11 — Verifica individuale

## Parte A — Scelta singola

1. **Domanda:** In `myacr.example/catalog-backend:v2`, `catalog-backend` è:<br>
   - A. registry
   - B. repository
   - C. revision
   - D. environment

   **Risposta:** B. **catalog-backend** è il **repository**, cioè il posto che raggruppa tutte le versioni della stessa immagine, tipo v1 e v2. Il **registry** è la parte prima della barra, `myacr.example`, e `v2` è il **tag**.

---

2. **Domanda:** Per ottenere il login server ACR corretto è preferibile:<br>
   - A. costruirlo sempre come `<name>.azurecr.io`
   - B. leggerlo con `az acr show --query loginServer`
   - C. usare `localhost`
   - D. usare l'ID subscription

   **Risposta:** B. il **login server** si legge direttamente dalla risorsa con `az acr show --query loginServer`, così si usa il valore vero che restituisce Azure senza doverlo indovinare partendo dal nome.

---

3. **Domanda:** `az acr login --name` richiede:<br>
   - A. il nome della risorsa ACR
   - B. sempre il login server completo
   - C. la password admin
   - D. il nome della revision

   **Risposta:** A. `az acr login` vuole solo il **nome** della risorsa ACR, per esempio `acr1789980304ud11`, e usa l'accesso già fatto con `az login` per autenticare Docker, quindi non serve nessuna password.

---

4. **Domanda:** Una Container Apps revision è:<br>
   - A. una VM
   - B. uno snapshot immutabile di una versione/configurazione della app
   - C. una replica
   - D. un repository ACR

   **Risposta:** B. è una "foto" della configurazione dell'app in un certo momento, con dentro l'**image**, le variabili d'ambiente, CPU e memoria, e una volta creata non si modifica più. Se cambia qualcosa di questi elementi Azure crea una nuova **revision**.

---

5. **Domanda:** Una replica è:<br>
   - A. una istanza in esecuzione di una revision
   - B. un tag ACR
   - C. un Resource Group
   - D. una service connection

   **Risposta:** A. la **replica** è la copia che gira davvero, cioè il container acceso che esegue una **revision**. Una revision può avere più repliche oppure nessuna se scala a zero.

---

6. **Domanda:** Per permettere a una Container App di leggere un ACR privato senza password si può usare:<br>
   - A. managed identity
   - B. tag Git
   - C. public IP
   - D. Log Analytics

   **Risposta:** A. la **managed identity** è un'identità che Azure crea e gestisce da solo per la Container App, e nasce e muore insieme a lei. Le si assegna il ruolo **AcrPull** sul registry e così può scaricare le immagini senza nessuna password.

---

7. **Domanda:** `AcrPull` fornisce:<br>
   - A. autorizzazione a eliminare subscription
   - B. pull delle immagini dal registry nel modello RBAC appropriato
   - C. RDP
   - D. gestione DNS

   **Risposta:** B. **AcrPull** permette solo di leggere e scaricare (**pull**) le immagini dal registry, che è il minimo che serve alla Container App per partire, senza poterne caricare o cancellare. Vale quando il registry usa il modello **RBAC Registry Permissions**.

---

8. **Domanda:** Con `minReplicas=0`:<br>
   - A. la app viene eliminata
   - B. la app può scalare a zero repliche quando non necessarie
   - C. ACR viene eliminato
   - D. non esiste ingress

   **Risposta:** B. quando non arrivano richieste l'app può scendere a **zero repliche**, così non consuma **compute** per niente. L'app e il registry restano lì, e appena arriva una richiesta riparte una replica.

---

## Parte B — Risposte brevi

9. **Domanda:** Distingui tag e digest.<br>

   **Risposta:** un **tag** è un'etichetta leggibile messa su un'immagine, tipo `v1` o `v2`, ma non è legata al contenuto, quindi nel tempo lo stesso tag può essere riassegnato e puntare a un'immagine diversa. Il **digest** invece è un identificativo del tipo `sha256:...` calcolato dal contenuto stesso, quindi se il contenuto cambia cambia anche il digest, e un digest punta sempre alla stessa identica immagine. Il tag è comodo da leggere e va bene per seguire le versioni, il digest è più sicuro quando serve essere certi di quale immagine si sta distribuendo.

---

10. **Domanda:** Distingui Container Apps Environment, Container App, revision e replica.<br>

    **Risposta:** l'**Environment** è l'ambiente condiviso in cui vivono una o più Container App, cioè lo spazio dove vengono eseguite. La **Container App** è l'applicazione vera e propria, con la sua configurazione fatta di image, variabili d'ambiente, ingress e identità. Ogni volta che cambia una parte di quella configurazione, tipo l'image, Azure crea una **revision**, cioè una versione fissa della app. La **replica** è l'istanza che sta girando davvero di una revision, e ce ne può essere una, più di una o nessuna se **minReplicas** è 0. Quindi sono una dentro l'altra, l'Environment contiene le app, ogni app ha le sue revision e ogni revision ha le sue repliche.

---

11. **Domanda:** Perché il corso usa managed identity invece di ACR admin credentials?<br>

    **Risposta:** perché le **credenziali admin** sono uno username e una password fissi, cioè segreti che qualcuno deve custodire e cambiare ogni tanto, e se finiscono nel posto sbagliato chiunque li può usare con tutti i permessi sul registry. Con la **managed identity** invece non c'è nessuna password da salvare o far ruotare, ci pensa Azure.

---

12. **Domanda:** Perché una nuova image normalmente produce una nuova revision?<br>

    **Risposta:** perché l'**image** fa parte della configurazione di una **revision**, e una revision una volta creata non si modifica più. Quindi se cambia l'image Azure non può aggiornare quella vecchia, ma crea uno "snapshot" nuovo che rispecchia la configurazione attuale, tipo con la v2 al posto della v1.

---

13. **Domanda:** Che cosa deve coincidere tra backend e ingress target port?<br>

    **Risposta:** la porta su cui il backend ascolta davvero dentro il container e il **target port** dell'ingress. Se il backend ascolta sulla 8000 anche il target port deve essere 8000, altrimenti l'ingress manda le richieste a una porta dove non c'è nessuno e il FQDN dà errore anche se la revision risulta healthy.

---

14. **Domanda:** Elenca almeno cinque controlli per una Container App non raggiungibile.<br>

    **Risposta:** per prima cosa guardo se l'**ingress** è attivo ed è **external**, altrimenti da fuori non si arriva. Poi controllo il **target port**, che deve essere uguale alla porta su cui l'app ascolta davvero. Successivamente guardo la **revision** attiva con `az containerapp revision list`, per vedere se è healthy e quale image usa, e se c'è almeno una **replica** in esecuzione. Poi leggo i **log** con `az containerapp logs show`, per vedere cosa scrive l'app e su quale porta dice di ascoltare. Se la revision non parte controllo che l'image con quel tag esista in ACR e che la **managed identity** abbia il ruolo **AcrPull**, e per ultime le variabili d'ambiente, perché un valore sbagliato può far fallire l'app.

---

15. **Domanda:** Perché il laboratorio UD11 esegue manualmente build, push e deployment invece di partire subito da una pipeline?<br>

    **Risposta:** perché prima di automatizzare bisogna capire cosa fanno i vari passaggi, se parto subito da una **pipeline** e si rompe qualcosa non so dove andare a guardare. Facendo **build**, **push** e **deployment** a mano vedo ogni passo uno alla volta, tipo chi carica l'immagine, chi la scarica, su quale porta gira l'app e cosa cambia quando aggiorno la versione, così quando poi lo faccio fare alla pipeline so cosa sta facendo e, se qualcosa non va, capisco dove.

---

16. **Domanda:** Se un registry è configurato in modalità RBAC+ABAC, perché non puoi dare per scontato che `AcrPull` sia il ruolo corretto?<br>

    **Risposta:** perché il ruolo giusto dipende da come è configurato il registry, e **AcrPull** vale nella modalità **RBAC Registry Permissions**, dove il permesso si dà sul registry intero. Con **RBAC+ABAC** invece i permessi si possono dare anche per singolo repository, e in quella modalità i ruoli vecchi come **AcrPull**, **AcrPush** e **AcrDelete** non si usano più per accedere ai repository, si usano ruoli nuovi tipo **Container Registry Repository Reader** per leggere e **Container Registry Repository Writer** per scrivere. Quindi se do **AcrPull** a un registry in RBAC+ABAC il ruolo risulta assegnato ma l'app non riesce comunque a scaricare l'immagine, per questo prima di dare un ruolo controllo in quale modalità è il registry.

---

17. **Domanda:** In che modo il lavoro manuale di UD11 prepara UD14 e UD15?<br>

    **Risposta:** perché i passaggi fatti a mano sono gli stessi che poi farà la pipeline, in UD14 l'**Agent** farà test, **build** e **push** su ACR, in UD15 farà il **deployment** sulla Container App e lo **smoke test**. Farli prima a mano fa capire cosa deve avere la pipeline per funzionare, tipo l'identità per il push e la porta giusta.

---

18. **Domanda:** Distingui system-assigned e user-assigned managed identity.<br>

    **Risposta:** la **system-assigned** nasce insieme a una risorsa, tipo la Container App, ed è legata a lei, quindi quando la risorsa viene eliminata sparisce anche l'identità. La **user-assigned** è invece una risorsa a parte, si può creare prima e riusare, e la sua vita non dipende da una risorsa sola.

---

## Parte C — Scenario

> ACR contiene `catalog-backend:v2`. La revision corrente è Healthy. I log mostrano `listening on 0.0.0.0:8000`. L'ingress è external ma `targetPort=9000`. Il FQDN restituisce errore.

15. **Domanda:** Qual è la causa più probabile e qual è la correzione minima?<br>

    **Risposta:** il **target port** dell'ingress è 9000 mentre l'app ascolta sulla 8000, come dicono i log, quindi le richieste arrivano a una porta dove non c'è nessuno anche se la **revision** è healthy. La correzione minima è cambiare solo il target port a 8000, lasciando l'ingress external e senza ricostruire l'immagine.

---

16. **Domanda:** Quali verifiche eseguiresti dopo la correzione prima di dichiarare risolto il problema?<br>

    **Risposta:** controllo che il FQDN risponda con `curl` e dia **200**, per esempio su `/health`, poi che la **revision** sia healthy e attiva con `az containerapp revision list` e che nei **log** non ci siano errori. Se serve provo anche un endpoint vero dell'app, tipo `/api/products`, per essere sicuro che risponda davvero.

---

## Cleanup finale

- resource list verificata: sì, prima di eliminare, c'erano 4 risorse, il registry `acr1789980304ud11`, il workspace Log Analytics creato in automatico, l'Environment `acaenv-ud11` e la Container App `catalog-api-ud11`, tutte in `italynorth` e tutte del lab
- Resource Group eliminato: sì, `rg-ud11-containers`, ci ha messo parecchio perché l'Environment è stata l'ultima risorsa a sparire (è rimasto un po' in `ScheduledForDelete`), ma senza nessun errore
- `az group exists` = false: sì, con il nome scritto per intero ha risposto `false`
- immagini Docker locali UD11 rimosse: sì, prima i due tag `catalog-backend:ud11-v1` e `catalog-backend:ud11-v2`, poi i due col nome del registry (`.../catalog-backend:v1` e `v2`), e alla fine `docker image ls` è vuoto
- prune globale usato: NO
