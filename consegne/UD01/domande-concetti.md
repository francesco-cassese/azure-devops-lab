# Domande di consolidamento sezione 1

**Perché il deployment manuale precede la pipeline CD?**

Perché prima devi capire davvero cosa fa un deployment — cosa succede, come verifichi che sia riuscito, come risolvi un errore — facendolo a mano. Se salti subito alla pipeline automatica, ti limiti a copiare comandi senza capirli, e se qualcosa si rompe non sai come diagnosticarlo.

---

**Quale differenza di responsabilità esiste tra ACR e Azure Container Apps?**
 
**ACR** conserva le versioni dell'applicazione containerizzata — è il magazzino. 

**Azure Container Apps** invece la esegue davvero in Azure, rendendola disponibile agli utenti. Uno conserva, l'altro esegue.

---

**Perché GitHub rimane il repository remoto anche quando vengono introdotte Azure Pipelines?**

Perché Azure Pipelines può leggere direttamente da GitHub, senza bisogno di un repository separato (Azure Repos). Usare GitHub anche per le pipeline evita di duplicare il codice in due posti diversi e mantiene continuità con il lavoro già iniziato fin dall'UD01.

---

- **Quale vantaggio didattico offre l'uso continuativo del Catalogo prodotti?**

Usare sempre la stessa applicazione permette di vedere chiaramente cosa cambia davvero da una fase all'altra del corso: il codice resta lo stesso, mentre cambiano l'ambiente, come viene distribuito e quanto è automatizzato. Permette anche di confrontare direttamente il **fare le cose a mano** con il **farle tramite pipeline**.

---

**In quale punto del percorso l'infrastruttura diventa descritta come codice?**

Nel quarto modulo (UD12–UD15), dopo aver imparato a creare e distribuire le risorse manualmente. Si introduce Bicep e Terraform per descrivere l'infrastruttura come codice, invece di crearla a mano ogni volta.

---

**Quali elementi deve contenere un'evidenza tecnica utile?**

Un'evidenza utile deve spiegare: cosa si voleva ottenere, cosa è stato fatto per ottenerlo, come è stato verificato il risultato, e se c'è stato un problema, come è stato diagnosticato. Non basta uno screenshot, serve il contesto che lo rende comprensibile a chi legge.

---

**Quali strumenti sono esplicitamente esclusi dal percorso?**

Kubernetes, Jenkins, SonarQube, Ansible, Prometheus e Grafana sono esclusi dal percorso

---

**Perché una versione più recente non determina automaticamente un aggiornamento?**

Avere una versione più recente non significa che sia la scelta giusta: prima va controllato se funziona bene con quello che stai già facendo, perché uno script o una configurazione potrebbe essere stata scritta per una versione precedente e comportarsi diversamente con quella nuova. Per questo si testa la compatibilità prima di decidere, invece di aggiornare "perché è più nuovo", proprio come su un server aziendale, dove un aggiornamento non pensato può rompere qualcosa che funzionava.

# Domande di controllo prima del laboratorio

**Perché git --version può restituire due risultati diversi in PowerShell e in Ubuntu?**

Perché Windows e Ubuntu sono due sistemi separati, ognuno con la propria installazione di Git. Non è un errore: sono semplicemente due copie indipendenti, installate in momenti diversi, quindi possono avere versioni diverse.

---

**Quale comando distingue una distribuzione WSL 1 da una WSL 2?**

```
wsl --list --verbose
```

Nella colonna VERSION mostra se ogni distribuzione installata usa WSL 1 o WSL 2 — `wsl --version` invece dà solo la versione del componente WSL in generale, non distingue le distribuzioni.

---

**Perché conserveremo i progetti in ~/workspace e non principalmente in /mnt/c?**

Perché in ~/workspace i file sono "dentro" Linux e tutto va più veloce. /mnt/c invece è il disco di Windows visto da Linux, quindi è più lento — e più avanti, quando useremo Docker, funziona meglio se i file sono nella cartella Linux vera.

---

**Che differenza c'è fra configurare l'autore di un commit e autenticarsi su GitHub?**

Sono due cose diverse. Configurare user.name/user.email serve solo a scrivere "chi ha fatto questa modifica" dentro al commit — è come firmare un foglio, chiunque può scrivere qualsiasi nome. Autenticarsi su GitHub invece dimostra davvero che sei tu, e serve per avere il permesso di fare push verso il repository.

---

**Perché eseguire git status sia prima sia dopo git add?**

Il primo git status mostra cosa è cambiato prima di scegliere cosa aggiungere. Il secondo, dopo git add, serve a controllare che sia stato aggiunto davvero solo quello che volevi — così eviti di dimenticare un file o di includerne uno per errore nel commit.