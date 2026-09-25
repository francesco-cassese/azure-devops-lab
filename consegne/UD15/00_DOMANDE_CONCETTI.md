# UD15 — Domande concetti

## 1. Qual è la differenza tra CI e Continuous Delivery?

**Risposta:** La CI controlla se il codice supera i test, se l'immagine si costruisce senza intoppi e se può essere pubblicata. La Continuous Delivery controlla anche la distribuzione: se l'artefatto può essere distribuito, se l'infrastruttura è coerente, se l'applicazione parte, se l'endpoint risponde e se la versione in esecuzione è quella attesa. In pratica la CI si ferma quando l'immagine è pronta, mentre la Continuous Delivery arriva fino a controllare che l'app in funzione risponda. Nel lab l'ultimo stage, lo smoke test, chiama `/health` proprio per questo.

---

## 2. Quale service connection utilizza la pipeline UD15?

**Risposta:** Usa soltanto `sc-azure-ud13-15`, una service connection di tipo Azure Resource Manager basata su Workload Identity Federation, cioè senza password o client secret salvati nel repository. È l'unica identità della pipeline: dentro `AzureCLI@2` la usano sia `az` sia Terraform e Docker.

---

## 3. Perché la pipeline non utilizza `Docker@2`?

**Risposta:** Non usiamo `Docker@2` perché per accedere a un registry richiede una Docker Registry service connection, cioè una seconda connessione, e qui vogliamo usare solo quella ARM. Non è che `Docker@2` sia sbagliato, è solo una scelta per avere una connessione sola. Al suo posto, dentro `AzureCLI@2`, facciamo `az acr login`, poi `docker build` e `docker push`.

---

## 4. Quale ruolo deve avere l'identità della pipeline sull'ACR?

**Risposta:** Deve avere `AcrPush`, il ruolo che permette di scrivere nel registry. Serve perché la pipeline pubblica l'immagine con `docker push`. Nel lab l'ho assegnato al Service Principal di `sc-azure-ud13-15`.

---

## 5. Perché Terraform usa uno state remoto?

**Risposta:** Perché Terraform deve ricordarsi quali risorse gestisce, e lo fa con lo state. Ogni job ha `workspace: clean: all`, cioè l'area di lavoro viene cancellata a ogni job, quindi uno state locale andrebbe perso. Con lo state remoto invece resta, e job e run diverse lavorano sulla stessa infrastruttura. In più Azure Storage lo blocca mentre qualcuno lo usa (locking), così due modifiche non si sovrascrivono.

---

## 6. Dove viene conservato lo state UD15?

**Risposta:** In Azure Storage, nel container `tfstate`, dentro il file `ud15.tfstate`. Lo conserva il backend `azurerm` di Terraform, in Blob Storage. Dopo lo stage Deploy ho controllato dal portale che il file `ud15.tfstate` ci fosse.

---

## 7. Quale ruolo permette alla pipeline di utilizzare lo state Blob?

**Risposta:** Il ruolo `Storage Blob Data Contributor`, che permette di leggere e scrivere i blob. Serve perché la pipeline deve leggere lo state prima di ogni piano e riscriverlo dopo l'apply. Nel lab l'ho assegnato al Service Principal di `sc-azure-ud13-15` solo sul container `tfstate`, non su tutto lo Storage Account, così la pipeline non può toccare gli altri container.

---

## 8. Come si autentica Terraform durante la pipeline?

**Risposta:** Non si autentica da solo: usa la sessione Azure CLI già aperta. I comandi Terraform girano dentro `AzureCLI@2`, che apre la sessione con `sc-azure-ud13-15` tramite Workload Identity Federation, e Terraform la riutilizza. Nello script della pipeline ci sono `ARM_USE_CLI=true` e `ARM_USE_AZUREAD=true` per dirglielo. Per questo nei file `.tf` non c'è nessuna password.

---

## 9. Quali risorse vengono lette come esistenti?

**Risposta:** Il Resource Group, l'Azure Container Registry e la managed identity `id-ud15-acrpull`. Sono state create prima, e Terraform le legge con i `data` source (in `main.tf`) senza gestirle. In questo modo non devono essere importate nello state di UD15.

---

## 10. Quali risorse vengono gestite da Terraform?

**Risposta:** Il Container Apps Environment e la Container App. Sono le uniche risorse nuove di UD15 e finiscono nello state `ud15.tfstate`. Nel lab il primo piano diceva `Plan: 2 to add`, cioè proprio queste due, e l'apply ha risposto `2 added`.

---

## 11. Perché la Container App utilizza una managed identity?

**Risposta:** Perché quando parte deve scaricare l'immagine dal registry privato, e la managed identity è il modo per farlo senza password. Ha una sua identità, `id-ud15-acrpull`, diversa da quella della pipeline: la pipeline pubblica, la Container App deve solo leggere. Così l'app in esecuzione non ha il permesso di scrivere nel registry, che non le serve.

---

## 12. Quale ruolo ha questa identità sull'ACR?

**Risposta:** Ha `AcrPull`, che permette solo di leggere le immagini. Nel lab l'ho assegnato a `id-ud15-acrpull` sull'ACR e ho controllato con `az role assignment list` che comparisse `AcrPull`. La differenza con la pipeline è quella tra `AcrPush` (scrivere) e `AcrPull` (leggere).

---

## 13. Perché viene eseguito `terraform plan` nello stage iniziale?

**Risposta:** Per controllare la configurazione Terraform prima di perdere tempo con test e build. Lo stage esegue `terraform init`, `fmt -check`, `validate` e `plan`, quindi se c'è un errore la pipeline si ferma subito. Il piano può già usare il nuovo Build ID come tag anche se l'immagine non è ancora stata pubblicata, e in questo stage non distribuisce niente. Nel lab `terraform fmt` aveva riscritto `providers.tf`: senza quella correzione `fmt -check` avrebbe fatto fallire lo stage.

---

## 14. Perché viene ricreato il piano nello stage Deploy?

**Risposta:** Perché nel frattempo lo stage `BuildPush` ha pubblicato l'immagine e lo stato è cambiato rispetto al primo piano. Nello stage Deploy si fa quindi un piano nuovo, sullo stato aggiornato, e si applica quello. Così si applica quello che serve adesso e non un piano fatto prima.

---

## 15. Che relazione esiste tra Build ID, tag e `APP_VERSION`?

**Risposta:** Sono lo stesso numero, `$(Build.BuildId)`, usato in tre posti: come tag dell'immagine, come variabile `APP_VERSION` della Container App e quindi nella risposta di `/health`. Serve per seguire tutta la release: run, Build ID, tag in ACR, Container App e `/health`. Nel lab guidato il Build ID era 19, l'immagine `catalog-backend:19` e `/health` rispondeva `version: 19`.

---

## 16. Perché uno smoke test può fallire dopo un apply riuscito?

**Risposta:** Perché un `terraform apply` riuscito dice solo che Azure ha accettato la configurazione, non che l'applicazione funzioni. Lo smoke test controlla davvero l'FQDN, `/health`, che la risposta sia riuscita e che la versione sia quella attesa. Nel lab autonomo lo stage Deploy era verde, ma lo smoke è fallito perché `/health` rispondeva `version: 21` invece della versione della run.

---

## 17. Perché `workspace: clean: all` rende importante lo state remoto?

**Risposta:** Perché `clean: all` cancella l'area di lavoro a ogni job, quindi un state locale sparirebbe. Con lo state su Blob Storage ogni job lo ritrova sempre uguale, senza dipendere dai file rimasti sull'Agent. Per questo lo stage Deploy, che parte da un'area pulita, sa lo stesso quali risorse esistono già.

---

## 18. Che cosa dimostra l'errore sulla target port?

**Risposta:** Dimostra che infrastruttura applicata e servizio funzionante sono due cose diverse. Nel lab autonomo ho cambiato `targetPort` da `8000` a `9999`: Terraform ha applicato la modifica senza errori (il piano diceva `target_port = 8000 -> 9999`) e lo stage Deploy era verde. Ma l'app ascolta sulla 8000, quindi la revision nuova non è diventata pronta e Azure ha continuato a servire quella vecchia. Lo smoke test se n'è accorto, perché la versione non era quella attesa.

---

## 19. Che cosa elimina `terraform destroy` a fine UD15?

**Risposta:** Elimina le risorse gestite dallo state di UD15, cioè la Container App e il Container Apps Environment. Non elimina l'ACR, la managed identity, lo Storage dello state e il Resource Group, perché non sono nello state UD15. Il Resource Group e le risorse condivise si rimuovono dopo, con un comando a parte.
