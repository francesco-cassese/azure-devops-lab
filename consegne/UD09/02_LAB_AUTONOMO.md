# UD09 — Consegna laboratorio autonomo

## 1. Organization e Project

| Campo | Valore |
|---|---|
| Organization | azdo-francesco-01 |
| Project | az900-az104-devops |
| Visibility | Private |
| Source repository | francesco-cassese/azure-devops-lab |

1. **Domanda:** Perché il Project è privato?

    **Risposta:** perchè cosi solo chi è invitato può vedere il Project.

2. **Domanda:** Perché il source repository rimane GitHub?

    **Risposta:** perchè altrimenti avremmo la stessa versione della repository in due posti differenti, facendo cadere facilmente in errore su quale sia la versione definitiva.

## 2. Gruppi

| Gruppo | Scopo essenziale | Lo assegneresti a tutti? Perché? |
|---|---|---|
| Project Administrators | Può fare praticamente tutto nel progetto. | No, lo assegnerei solo a me in questo caso, per il principio di least privilege. |
| Contributors | Lavora normalmente al progetto, tipo scrivere codice. | Si, ai miei collaboratori, cioè chi lavora attivamente al progetto. |
| Readers | Può solo guardare, non modificare. | No, solo a chi deve controllare che non ci siano errori o dati sensibili, senza dargli la possibilità di modificare, altrimenti si rischia un disallineamento inconsapevole. |
| Build Administrators | Si occupa delle build e delle pipeline. | No, solo a chi gestisce il corretto funzionamento della pipeline. |

## 3. GitHub integration readiness

| Campo | Valore |
|---|---|
| repository | francesco-cassese/azure-devops-lab |
| private | no |
| gh auth | autenticato |
| git fetch | eseguito, nessun errore |

---

1. **Domanda:** Perché in UD09 non abbiamo creato una service connection GitHub OAuth/PAT?

    **Risposta:** perchè per le pipeline di Continuous Integration (CI) si usa la Azure Pipelines GitHub App, che si crea in automatico quando fai la prima pipeline e scegli il repository. Fare oggi anche una connessione OAuth o PAT a mano creerebbe un collegamento che poi non verrebbe più usato.

---

2. **Domanda:** Quale metodo useremo quando creeremo la prima pipeline GitHub?

    **Risposta:** useremo la Azure Pipelines GitHub App, quella consigliata per le pipeline di Continuous Integration (CI).

---

3. **Domanda:** Perché evitare di duplicare il repository in Azure Repos?

    **Risposta:** perchè avere lo stesso codice in due posti diversi crea confusione su quale sia la versione giusta, con il rischio che le due copie si disallineino nel tempo.

---

## 4. Parallel jobs

| Campo | Valore |
|---|---|
| Microsoft-hosted | 1 parallel job gratuito, fino a 1800 minuti al mese |
| self-hosted | 1 parallel job gratuito |

Scenario: Microsoft-hosted = 0, self-hosted = 1.

1. **Domanda:** Il corso è bloccato?

    **Risposta:** no, perchè per un Project privato il self-hosted ha un job garantito disponibile di base, non va abilitato come il Microsoft-hosted.

2. **Domanda:** Quanti job self-hosted possono essere eseguiti contemporaneamente con un solo parallel job?

    **Risposta:** 1.

3. **Domanda:** Registrare 3 agent aumenta automaticamente a 3 i job concorrenti?

    **Risposta:** no, con 1 parallel job ne gira comunque 1 alla volta anche se hai 3 agent Online. Agent e Parallel Job non sono la stessa cosa.

---

## 5. Agent audit

| Campo | Valore |
|---|---|
| pool | pool-ud09-wsl |
| agent | wsl-ud09-francesco |
| status | Online |
| version | 5.279.0 |
| Agent.OS | Linux |
| Agent.Version | 5.279.0 |
| git | /usr/bin/git |
| python | python3 presente, python no |

## 6. Registration authentication audit

| Campo | Valore |
|---|---|
| metodo | PAT |
| status PAT, se applicabile | revocato |

---

1. **Domanda:** Perché l'agent resta Online anche dopo la revoca del PAT?

    **Risposta:** il PAT serve solo la prima volta, per collegare l'agent al pool. Da quel momento l'agent ha un suo modo per parlare con Azure DevOps, che non dipende più dal PAT, per questo puoi toglierlo subito dopo senza problemi.

---

2. **Domanda:** Perché non serve un PAT Full access?

    **Risposta:** perchè serve solo a registrare l'agent nel pool, non a molto altro. Dargli il Full access non aggiungerebbe niente di utile, e se il token viene smarrito o rubato limiti i danni perchè può fare ben poco.

---

3. **Domanda:** Perché Device Code Flow è un fallback migliore rispetto ad allargare una policy PAT?

    **Risposta:** perchè riusciamo a registrare comunque l'agent senza toccare la policy PAT e senza creare falle di sicurezza inutili per tutta l'Organization.

---

## 7. Offline/Online

| Azione | Stato osservato |
|---|---|
| stop (Ctrl+C) | Offline |
| restart (./run.sh) | Online |

## 8. Troubleshooting

Scenario:

```text
Agent configurato ma Offline.
```

Costruisci una checklist nell'ordine:

- processo run.sh;
- rete/HTTPS;
- Organization URL;
- pool;
- directory agent/configurazione;
- diagnostica.

Comando disponibile:

    cd ~/azdo-agent
    ./run.sh --diagnostics

Non eseguire rimozione/re-registrazione come prima azione.

1. **Processo run.sh**: guardo se il terminale dell'agent è ancora aperto e se dice ancora che sta ascoltando lavori. Se si è chiuso o fermato è quasi sicuramente la causa, lo riaccendo e basta.

2. **Rete/HTTPS**: se riaccenderlo non basta, controllo se il PC riesce a collegarsi a internet verso Azure DevOps, prima di pensare che sia un problema dell'agent stesso.

3. **Organization URL**: controllo che l'indirizzo della mia Organization usato per la registrazione sia ancora giusto e non sia cambiato.

4. **Pool**: controllo che l'agent sia ancora dentro il pool giusto e che il pool esista ancora.

5. **Directory agent/configurazione**: controllo che la cartella dell'agent sul PC e i suoi file siano ancora dove devono essere, e non siano stati spostati o cancellati per sbaglio.

6. **Diagnostica**: se dopo tutto questo il problema c'è ancora, uso il comando di diagnostica dell'agent per capire meglio cosa non va, prima di pensare a cancellare e registrare tutto da capo.

## 9. Readiness

| Controllo | PASS/FAIL | Nota |
|---|---|---|
| Organization | PASS | azdo-francesco-01, collegata alla subscription |
| Private Project | PASS | az900-az104-devops, Private, Agile |
| GitHub integration readiness | PASS | repository verificato, nessuna connessione OAuth/PAT creata |
| Hosted status documentato | PASS | Microsoft-hosted READY, self-hosted disponibile |
| Self-hosted pool | PASS | pool-ud09-wsl creato dal Project |
| Agent Online | PASS | wsl-ud09-francesco, Online |
| PAT revocato / Device Code Flow | PASS | PAT revocato dopo la registrazione |
| Capability controllate | PASS | Agent.OS, Agent.Version, git, python verificati |
| Restart Online/Offline testato | PASS | testato in Attività 7 |
| Nessun segreto nel repository | PASS | verificato con git status |
