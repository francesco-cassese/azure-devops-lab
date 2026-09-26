# UD15 — Verifica finale

1. **Domanda:** Scenario 1. La pipeline mostra `IaC succeeded`, `Test succeeded`, `BuildPush succeeded`, `Deploy succeeded`, `Smoke failed`. Terraform ha applicato `target_port = 9999` mentre l'applicazione ascolta sulla porta `8000`. Qual è la causa più probabile?

    **Risposta:** La causa è che il `target_port` della Container App è 9999 mentre l'app ascolta sulla 8000. L'ingress manda il traffico a una porta dove l'app non ascolta, quindi la revision nuova non diventa pronta e Azure continua a servire quella vecchia. Terraform ha applicato senza errori perché Azure accetta la configurazione, ma lo smoke test trova la versione sbagliata. È quello che è successo nel mio lab autonomo.

---

2. **Domanda:** Scenario 1. Quali componenti non modificheresti?

    **Risposta:** Non modificherei la service connection `sc-azure-ud13-15`, i ruoli `AcrPush` e `AcrPull`, la managed identity `id-ud15-acrpull`, lo Storage dello state e l'Agent. Gli stage `IaC`, `Test`, `BuildPush` e `Deploy` sono andati bene, quindi questi pezzi funzionavano già. Il problema era solo il target port e nel lab ho cambiato solo quello, rimettendo `8000`.

---

3. **Domanda:** Scenario 2. Lo stage `IaC` fallisce durante `terraform init` con un errore 403 sul Blob Storage dello state. Quale autorizzazione controlli?

    **Risposta:** Controllo il ruolo `Storage Blob Data Contributor` sul container `tfstate` per l'identità di `sc-azure-ud13-15`. Un errore 403 vuol dire che l'accesso è negato, quindi di solito manca questo permesso. Lo verifico con `az role assignment list` sullo scope del container. Se il ruolo è stato assegnato da poco, aspetto un po' perché può metterci tempo ad arrivare.

---

4. **Domanda:** Scenario 2. Perché non devi spostare lo state nel repository come soluzione?

    **Risposta:** Perché il problema è un permesso mancante, non il posto dove sta lo state. Nel repository ogni job lo scaricherebbe con il checkout e, con `workspace: clean: all`, ogni volta ripartirebbe da zero. In più si perderebbe il locking di Azure Storage, che impedisce a due modifiche di sovrascriversi. Lo state deve restare remoto e va sistemato il ruolo.

---

5. **Domanda:** Scenario 3. Lo stage `BuildPush` fallisce durante `az acr login` o `docker push`. Quale service connection e quale ruolo controlli?

    **Risposta:** Controllo la service connection `sc-azure-ud13-15`, che è l'unica usata dalla pipeline, e il ruolo `AcrPush` sull'ACR per la sua identità. Senza `AcrPush` la pipeline non può scrivere nel registry. Lo verifico con `az role assignment list --role AcrPush` sullo scope dell'ACR. Nel mio lab l'elenco aveva due assegnazioni e una era quella di questa connessione.

---

6. **Domanda:** Scenario 3. Perché non abiliti l'admin user dell'ACR?

    **Risposta:** Perché la pipeline entra nel registry con l'identità di `sc-azure-ud13-15` e non con utente e password, quindi l'admin user non serve. Tenerlo spento evita di avere credenziali del registry che qualcuno potrebbe rubare. Nei controlli iniziali ho verificato che `Admin` fosse `False`. Il problema si risolve con il ruolo giusto, non abilitando un accesso più largo.

---

7. **Domanda:** Scenario 4. `terraform apply` riesce, ma `/health` restituisce una versione differente dal Build ID atteso. Quali elementi confronti per ricostruire la release?

    **Risposta:** Confronto il Build ID della run in Azure DevOps, il tag dell'immagine in ACR, la variabile `APP_VERSION` della Container App e la versione che risponde `/health`. Dovrebbero essere tutti lo stesso numero, perché il Build ID è usato sia come tag sia come `APP_VERSION`. Se cambia, vedo a che punto della catena il numero è diverso. Nel lab autonomo la run era la 26 ma `/health` rispondeva 21, cioè la revision vecchia.

---

8. **Domanda:** Distingui Continuous Integration e Continuous Delivery.

    **Risposta:** La Continuous Integration controlla il codice: se supera i test, se l'immagine si costruisce e se può essere pubblicata. La Continuous Delivery aggiunge la distribuzione: controlla che l'infrastruttura sia coerente, che l'applicazione parta, che l'endpoint risponda e che la versione in esecuzione sia quella attesa. Nel lab l'ultimo stage, lo smoke test, chiama `/health` proprio per questo.

---

9. **Domanda:** Perché UD15 utilizza uno state remoto?

    **Risposta:** Perché Terraform deve ricordarsi quali risorse gestisce e lo state locale sarebbe fragile in pipeline. Ogni job ha `workspace: clean: all`, quindi l'area di lavoro viene cancellata e uno state locale andrebbe perso. Lo state remoto in Azure Storage resta, permette a job e run diverse di lavorare sulla stessa infrastruttura e ha il locking. Nel lab è il file `ud15.tfstate` nel container `tfstate`.

---

10. **Domanda:** Perché lo Storage Account dello state viene preparato prima del laboratorio?

    **Risposta:** Perché Terraform non può usare come backend una risorsa che non esiste ancora. Per questo lo Storage Account e il container `tfstate` si creano una sola volta prima, nei controlli iniziali, e poi la pipeline li usa. Nel mio lab il primo controllo ha risposto `ResourceNotFound` e li ho creati io.

---

11. **Domanda:** Come si autentica Terraform nella pipeline?

    **Risposta:** Non si autentica da solo: usa la sessione Azure CLI già aperta. I comandi Terraform girano dentro `AzureCLI@2`, che apre la sessione con `sc-azure-ud13-15` tramite Workload Identity Federation, e nello script ci sono `ARM_USE_CLI=true` e `ARM_USE_AZUREAD=true`. Per questo nei file `.tf` non ci sono password.

---

12. **Domanda:** Quali risorse sono data source e quali sono gestite da Terraform?

    **Risposta:** Sono data source, cioè lette e non gestite, il Resource Group, l'Azure Container Registry e la managed identity `id-ud15-acrpull`, perché esistono già. Sono gestiti da Terraform il Container Apps Environment e la Container App, e finiscono nello state `ud15.tfstate`. Nel lab il piano diceva `2 to add`, proprio queste due.

---

13. **Domanda:** Perché il piano viene eseguito anche prima della build?

    **Risposta:** Per controllare la configurazione Terraform prima di perdere tempo con test e build. Lo stage iniziale fa `init`, `fmt -check`, `validate` e `plan`, quindi se c'è un errore la pipeline si ferma subito. Il piano può già usare il nuovo Build ID come tag anche se l'immagine non è ancora pubblicata, e in quello stage non distribuisce niente.

---

14. **Domanda:** Perché viene ricreato nello stage Deploy?

    **Risposta:** Perché nel frattempo lo stage `BuildPush` ha pubblicato l'immagine e lo stato è cambiato rispetto al primo piano. Nello stage Deploy si fa quindi un piano nuovo sullo stato aggiornato e si applica quello, così non si applica un piano fatto prima.

---

15. **Domanda:** Perché la pipeline utilizza `AzureCLI@2` invece di `Docker@2`?

    **Risposta:** Perché `Docker@2` per accedere a un registry richiede una Docker Registry service connection, cioè una seconda connessione, e in UD15 vogliamo usare solo `sc-azure-ud13-15`. Con `AzureCLI@2` facciamo dentro la stessa sessione `az acr login`, `docker build` e `docker push`. `Docker@2` non è sbagliato, è solo una scelta per avere una connessione sola.

---

16. **Domanda:** Quale ruolo ha la pipeline sull'ACR?

    **Risposta:** Ha `AcrPush`, il ruolo che permette di scrivere nel registry. Serve perché la pipeline pubblica l'immagine con `docker push`. Nel lab l'ho assegnato al Service Principal di `sc-azure-ud13-15`.

---

17. **Domanda:** Quale ruolo ha la managed identity della Container App?

    **Risposta:** Ha `AcrPull`, che permette solo di leggere le immagini. La Container App deve solo scaricare l'immagine quando parte, non pubblicarla, e per questo ha un'identità sua, `id-ud15-acrpull`, diversa da quella della pipeline. Nel lab ho controllato con `az role assignment list` che `AcrPull` fosse assegnato sull'ACR.

---

18. **Domanda:** Perché `workspace: clean: all` non deve cancellare lo state della delivery?

    **Risposta:** Perché lo state non sta nell'area di lavoro dell'Agent ma in Azure Storage, e `clean: all` cancella solo l'area di lavoro locale del job. Per questo lo state resta anche se ogni job riparte da zero. Se lo state fosse locale, invece, verrebbe cancellato a ogni job.

---

19. **Domanda:** Che cosa viene eliminato da `terraform destroy` alla fine?

    **Risposta:** Vengono eliminate le risorse gestite dallo state di UD15, cioè la Container App e il Container Apps Environment. Non vengono eliminati l'ACR, la managed identity, lo Storage dello state e il Resource Group, perché non fanno parte di quello state. Si rimuovono dopo con un comando a parte.

---

## Cleanup finale

| Campo | Valore |
|---|---|
| pipeline Terraform destroy | Pipeline `azure-devops-lab-cleanup`, run verde di circa 13 minuti. Il piano diceva `Plan: 0 to add, 0 to change, 2 to destroy.`, cioè le due risorse dello state UD15 |
| Container App rimossa | Sì, il log della run dice `Destruction complete after 11s` |
| Environment rimosso | Sì, ma ci ha messo di più: mentre aspettavo era in `ScheduledForDelete` e la run è finita solo dopo circa 13 minuti |
| Resource Group eliminato | Sì, `az group delete --name rg-ud13-15-delivery --yes`. Poi `az group exists` con il nome scritto per intero ha risposto `false` |
| service connection rimosse | `sc-azure-ud13-15` e `sc-acr-ud14`. Da terminale resta solo la connessione GitHub, che ho tenuto. `sc-acr-ud14` per un po' sembrava ancora presente nel portale, ma era la lista non aggiornata |
| Agent deregistrato | Sì, `./config.sh remove` ha risposto `Succeeded: Removing agent from the server` e in `pool-ud09-wsl` l'Agent non c'è più |
| repository conservato | Sì, i file Terraform, gli YAML e le consegne restano nel repository |
