# UD12 — Verifica individuale

## Parte A — Scelta singola

1. **Domanda:** In un approccio dichiarativo si descrive principalmente:<br>
   - A. la sequenza esatta di click
   - B. lo stato desiderato
   - C. soltanto il comando di cleanup
   - D. il log della VM

   **Risposta:** B. Nel dichiarativo descrivo lo stato finale che voglio, tipo "storage in West Europe, LRS, TLS 1.2", e lascio che sia lo strumento a decidere le azioni. Nell'imperativo, come con Azure CLI fino a UD11, decidevo io l'ordine dei passaggi.

---

2. **Domanda:** Bicep viene distribuito tramite:<br>
   - A. Azure Resource Manager
   - B. GitHub Pages
   - C. Docker Engine
   - D. DNS

   **Risposta:** A. Bicep è solo il file che scrivo, poi è Azure Resource Manager a leggerlo e a chiedere al Resource Provider giusto (`Microsoft.Storage` nel mio caso) di creare davvero la risorsa.

---

3. **Domanda:** `az deployment group what-if` serve principalmente a:<br>
   - A. eliminare il Resource Group
   - B. prevedere le modifiche di un deployment
   - C. creare il Terraform state
   - D. avviare l'agent

   **Risposta:** B. What-if confronta quello che esiste già con quello che il template descrive e mi mostra le modifiche previste, senza applicarle. Il deployment vero arriva solo dopo, con `az deployment group create`.

---

4. **Domanda:** `terraform init`:<br>
   - A. crea sempre risorse Azure
   - B. prepara la directory e i provider
   - C. elimina lo state
   - D. esegue il destroy

   **Risposta:** B. init prepara la cartella e scarica il provider, AzureRM nel mio caso, creando `.terraform/` e il lock file. Non crea ancora nessuna risorsa su Azure.

---

5. **Domanda:** `terraform validate`:<br>
   - A. sostituisce sempre `plan`
   - B. controlla la configurazione senza applicare risorse
   - C. elimina le risorse non valide
   - D. crea un ACR

   **Risposta:** B. validate controlla solo che il codice sia scritto bene e coerente, senza guardare cosa c'è davvero su Azure. Quello lo fa plan dopo.

---

6. **Domanda:** Il Terraform state serve principalmente a:<br>
   - A. memorizzare il PAT dell'agent
   - B. collegare gli oggetti Terraform alle risorse gestite
   - C. sostituire Git
   - D. memorizzare Dockerfile

   **Risposta:** B. Lo state collega quello che scrivo nel codice, tipo `azurerm_storage_account.lab`, alla risorsa vera su Azure, così Terraform sa sempre a cosa si riferisce.

---

7. **Domanda:** `terraform destroy`:<br>
   - A. elimina anche i file `.tf`
   - B. rimuove le risorse gestite dalla configurazione/state
   - C. disinstalla Terraform
   - D. elimina l'organizzazione Azure DevOps

   **Risposta:** B. destroy elimina le risorse gestite dallo state, non i file `.tf`. Mi è successo proprio così nel lab autonomo: risorse eliminate, codice rimasto nel repository.

---

8. **Domanda:** Dopo UD12 dobbiamo conservare:<br>
   - A. soltanto il Resource Group Bicep
   - B. codice IaC, strumenti e agent configurato
   - C. tutti i Resource Group temporanei
   - D. il file `terraform.tfstate` in GitHub

   **Risposta:** B. Le risorse Azure di laboratorio le ho eliminate appena finito. Quello che deve restare è il codice IaC, gli strumenti in WSL2 e l'agent configurato, perché mi servono ancora nelle prossime UD.

## Parte B — Risposte brevi

9. **Domanda:** Distingui approccio imperativo e dichiarativo.<br>

   **Risposta:** con l'imperativo sono io a dettare la sequenza di azioni, tipo con Azure CLI dicevo prima crea il Resource Group, poi crea lo Storage Account, poi imposta questa proprietà, in un ordine preciso che dovevo gestire io. Dichiarativo invece vuol dire descrivere solo lo stato finale desiderato, il blocco `resource` in Bicep o `azurerm_storage_account` in Terraform, e lasciare che sia lo strumento a capire da solo quali passaggi servono.

---

10. **Domanda:** Perché è utile separare parametri e definizione delle risorse?<br>

    **Risposta:** perché tenendo i valori fuori dal blocco della risorsa posso riusare lo stesso file cambiando solo cosa gli passo, senza toccare la logica. Nel mio `main.bicep` `storageName` non aveva default, quindi lo fornivo io ogni volta, mentre `location` sì (`resourceGroup().location`): potrei distribuire lo stesso template in un'altra regione o con un altro nome senza riscrivere una riga della risorsa. Lo stesso discorso vale per Terraform con `variables.tf` e le `TF_VAR_...`: se nome o regione fossero scritti fissi dentro `main.tf`, ogni ambiente diverso richiederebbe un file diverso.

---

11. **Domanda:** Distingui Bicep What-If e Terraform Plan.<br>

    **Risposta:** hanno lo stesso obbiettivo, mi fanno vedere le modifiche previste senza applicarle davvero. Ma il meccanismo è diverso: what-if appartiene ad ARM e confronta lo stato reale delle risorse Azure con il template Bicep. `terraform plan` invece è di Terraform e mette insieme configurazione, state locale e quello che legge tramite il provider, per questo può ragionare anche su dipendenze fra risorse che sta già gestendo, non solo su cosa creare da zero.

---

12. **Domanda:** Perché il Terraform state non deve essere committato come un normale sorgente?<br>

    **Risposta:** perché `terraform.tfstate` non è un log, è la fotografia delle risorse reali che Terraform gestisce: contiene id, proprietà e a volte anche valori che non vorrei girare in chiaro su un repository condiviso.

---

13. **Domanda:** Distingui `terraform validate`, `plan` e `apply`.<br>

    **Risposta:** validate guarda solo il codice in sé, senza sapere niente di Azure. plan invece interroga davvero Azure tramite il provider e mi dice cosa farebbe: `Plan: 2 to add, 0 to change, 0 to destroy` era quello che mi aspettavo al primo apply, un Resource Group e uno Storage Account nuovi. apply è il passaggio che esegue per davvero quelle azioni, ed è per questo che nel lab salvavo sempre il piano con `terraform plan -out=ud12.tfplan` prima di fare `terraform apply ud12.tfplan`: così sono sicuro di applicare esattamente quello che avevo già controllato.

---

14. **Domanda:** Perché in questa UD distruggiamo le risorse Azure ma conserviamo i file IaC?<br>

    **Risposta:** le risorse Azure che creo in laboratorio hanno senso solo per il tempo dell'esercitazione, tenerle accese dopo vorrebbe dire pagare per niente. Il codice IaC invece ha un ciclo di vita molto più lungo, resta nel repository e verrà riusato ed esteso nelle prossime UD. Sono due cose con tempi diversi, e distruggere le risorse senza toccare il codice è proprio il punto di avere l'infrastruttura descritta a parte invece che solo dentro al Portale.

## Parte C — Scenario

> Un collega modifica `main.tf`. `terraform validate` riesce. `terraform plan` mostra `1 to add, 0 to change, 2 to destroy`, ma il collega si aspettava soltanto l'aggiunta di un tag.

15. **Domanda:** Deve eseguire immediatamente `terraform apply`? Spiega il perché.<br>

    **Risposta:** no. Che validate sia passato mi dice solo che il file è scritto in modo corretto e coerente, non che il piano faccia quello che mi aspetto. Qui il piano dice `2 to destroy` mentre il collega pensava di aggiungere solo un tag, quindi c'è una differenza che va spiegata prima di applicare, non dopo. Mi è capitato di persona nel lab guidato: la location dello Storage Account nel mio primo `main.tf` ereditava da `azurerm_resource_group.lab.location` invece di essere un parametro a sé, e quando ho dovuto cambiare regione il piano non si è limitato a modificare il Resource Group, ha voluto ricreare anche lo Storage Account. Un `to destroy` inatteso è sempre un segnale da controllare prima, mai da ignorare.

---

16. **Domanda:** Quali controlli dovrebbe fare prima di applicare qualsiasi modifica?<br>

    **Risposta:** prima leggo tutto l'output di `plan`, non il riepilogo numerico, per vedere quali risorse esatte verrebbero distrutte e perché Terraform pensa di doverlo fare. Poi guardo il `git diff` di `main.tf` per capire cosa è cambiato davvero rispetto a prima, magari il collega ha toccato più di quello che pensa. Controllo anche le dipendenze fra risorse, perché come mi è successo a me un cambiamento apparentemente innocuo su una risorsa, la location del Resource Group, può forzare la ricreazione di un'altra che dipende da lei, lo Storage Account. Solo quando il piano coincide esattamente con quello che ci si aspettava, tag in più e nient'altro, ha senso fare apply.

---

17. **Domanda:** Perché installare Terraform in WSL2 prepara il self-hosted Agent ma non garantisce nulla sul Microsoft-hosted Agent?<br>

    **Risposta:** il self-hosted agent gira dentro il mio WSL2, che è una macchina persistente: tutto quello che installo lì, Terraform, Bicep, Azure CLI, resta a disposizione dell'agent finché non lo rimuovo io. È per questo che installarli ora prepara concretamente le pipeline future su quel pool. Il Microsoft-hosted invece assegna a ogni Job una VM nuova preparata da Microsoft con un'immagine tipo `ubuntu-latest`, e quella macchina non ha nessun rapporto con il mio WSL2: quello che installo io in locale non esiste su quella VM, quindi deve verificare o installare da sé gli strumenti che gli servono, indipendentemente da cosa ho fatto io.

---

18. **Domanda:** Perché un Job Microsoft-hosted non deve dipendere da file creati dal Job precedente?<br>

    **Risposta:** perché ogni Job Microsoft-hosted parte su una macchina temporanea diversa, che viene rilasciata alla fine del Job. Se il Job A scrive un file sul disco della sua VM e il Job B si aspettasse di trovarlo lì, non lo troverebbe, perché il Job B gira su una VM completamente nuova che non sa nulla di quello che è successo prima. Le informazioni tra Job vanno passate in altri modi, non contando su file lasciati in giro sulla macchina.

---

19. **Domanda:** Perché è utile verificare `terraform version`, `az version` e `az bicep version` all'interno di una pipeline?<br>

    **Risposta:** perché le versioni disponibili non sono garantite per sempre: su self-hosted dipendono da cosa e quando ho installato io in WSL2, su Microsoft-hosted dipendono dall'immagine che Microsoft mantiene e aggiorna nel tempo. Se la pipeline verifica queste versioni all'inizio, un problema o uno strumento mancante emerge subito con un messaggio chiaro, invece di far fallire un passo più avanti con un errore che sembra tutt'altro.

---

20. **Domanda:** Qual è il vantaggio e quale il rischio di usare `ubuntu-latest` rispetto a un'immagine versionata?<br>

    **Risposta:** il vantaggio di `ubuntu-latest` è che ricevo sempre l'immagine più recente, patch e strumenti aggiornati, senza doverla gestire io. Il rischio è proprio che sia "latest": può cambiare contenuto da un giorno all'altro senza che io abbia toccato la mia pipeline, quindi qualcosa che funzionava ieri potrebbe rompersi oggi per un cambiamento nell'immagine, non nel mio codice. Un'immagine versionata tipo `ubuntu-22.04` è più prevedibile e riproducibile nel tempo, il compromesso è che poi tocca a me decidere quando aggiornarla.

---

## Gate 2

- agent Online: sì, `run.sh` riavviato il 23/09/2026, output `2026-09-23 15:16:07Z: Listening for Jobs`
- Terraform disponibile: sì, v1.16.3
- Azure CLI/Bicep disponibile: sì, Azure CLI 2.90.0 / Bicep CLI 0.47.16
- Git/Python/Docker disponibili: sì, Git 2.43.0 / Python 3.12.3 / Docker 29.8.0

## Gate 2A — self-hosted

- Agent Online: sì (`wsl-ud09-francesco`, `run.sh` riavviato, `Listening for Jobs`)
- Terraform: v1.16.3
- Azure CLI: 2.90.0
- Bicep: 0.47.16
- Git: 2.43.0
- Python: 3.12.3
- Docker: 29.8.0

## Gate 2B — Microsoft-hosted

- stato: MICROSOFT_HOSTED_READY 
