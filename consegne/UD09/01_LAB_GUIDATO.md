# UD09 — Consegna laboratorio guidato

## Organization

| Campo | Valore |
|---|---|
| nome | azdo-francesco-01 |
| geography | Europe |
| Azure subscription collegata | sì |

## Project

| Campo | Valore |
|---|---|
| nome | az900-az104-devops |
| visibility | Private |
| version control | Git |
| process | Agile |

## Gruppi

| Gruppo | Funzione essenziale |
|---|---|
| Project Administrators | chi fa parte di questo gruppo può fare qualsiasi operazione sul progetto. |
| Contributors | chi fa parte di questo gruppo può aggiungere, modificare e cancellare elementi dentro il progetto. |
| Readers | chi fa parte di questo gruppo può solo vedere il progetto, senza modificarlo. |
| Build Administrators | chi fa parte di questo gruppo può creare, modificare e cancellare le build, gestire quelle in corso e quelle già finite. |

## GitHub

| Campo | Valore |
|---|---|
| repository | francesco-cassese/azure-devops-lab |
| repository privato | no |
| `gh auth status` | autenticato |
| `git fetch` | eseguito, nessun errore |
| connessione OAuth/PAT creata in UD09 | NO |
| metodo raccomandato per CI futura | Azure Pipelines GitHub App |

## Parallel jobs

| Campo | Valore |
|---|---|
| Microsoft-hosted | 1 parallel job gratuito, fino a 1800 minuti al mese |
| esito hosted | MICROSOFT_HOSTED_READY |
| self-hosted | 1 parallel job gratuito |
| billing verificato | sì |

## Agent Pool

| Campo | Valore |
|---|---|
| creato da Project settings | sì |
| nome | pool-ud09-wsl |
| tipo | Self-hosted |
| accesso automatico a tutte le pipeline | no |

## Autenticazione registrazione agent

| Campo | Valore |
|---|---|
| metodo usato | PAT |
| PAT name, se usato | ud09-agent-registration |
| PAT scope, se usato | Agent Pools - Read & manage |
| expiration | 30 days |
| inserito in file/repository | NO |
| PAT revocato, se usato | sì |

## Agent

| Campo | Valore |
|---|---|
| nome | wsl-ud09-francesco |
| pool | pool-ud09-wsl |
| OS | Linux (WSL2) |
| version | 5.279.0 |
| status | Online |
| modalità | self-hosted, avviato con ./run.sh |
| credenziale di registrazione chiusa e agent ancora Online | sì |

## Capability

| Campo | Valore |
|---|---|
| Agent.OS | Linux |
| Agent.Version | 5.279.0 |
| git | /usr/bin/git |
| python | python3 presente, python no |
| PATH verificato | sì |

## Readiness

| Ambito | Stato |
|---|---|
| Organization | azdo-francesco-01, collegata alla subscription |
| Project | az900-az104-devops, Private, Git, Agile |
| GitHub | francesco-cassese/azure-devops-lab, autenticazione verificata |
| hosted | MICROSOFT_HOSTED_READY |
| self-hosted | pronto, pool pool-ud09-wsl |
| agent | wsl-ud09-francesco, Online, PAT revocato, restart Offline/Online verificato |
| security | nessun segreto nella consegna o nel repository |
