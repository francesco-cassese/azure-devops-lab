# Evidenza — Preparazione dell'ambiente e metodo di lavoro

## Ambiente verificato

La postazione utilizza Windows con WSL 2 e una distribuzione Ubuntu supportata. I progetti sono conservati nel filesystem Linux e vengono aperti con Visual Studio Code tramite l'estensione WSL.

| Componente | Versione o stato pubblicabile | Verifica eseguita |
|---|---|---|
| WSL | versione 2, distribuzione Ubuntu-24.04 | `wsl --status`, `wsl --list --verbose` |
| Ubuntu | 24.04.4 LTS (kernel WSL2) | `cat /etc/os-release`, `uname -r` |
| Visual Studio Code | 1.136.1, estensione `ms-vscode-remote.remote-wsl` installata | `code --version`, `code --list-extensions`, apertura cartella WSL con indicatore `WSL: Ubuntu` |
| Git in Ubuntu | 2.43.0 | `git --version` |
| Azure CLI | 2.90.0 | `az version`, `az login --use-device-code`, `az account show --output table` |

## Workflow completato

Ho clonato il repository pubblico del corso (`corso-azure-devops`) in `~/workspace` per ricevere i materiali, e separatamente ho creato e clonato il mio repository personale `azure-devops-lab` (pubblico, con solo README iniziale). Con `git remote -v` ho verificato che i due repository puntassero a URL distinti, per non mescolare mai i materiali del corso con il mio lavoro. Nel repository personale ho creato le cartelle `evidenze` e `laboratori/UD01`, copiando il template di evidenza dal repository del corso e compilandolo con le versioni verificate degli strumenti (WSL, Ubuntu, VS Code, Git, Azure CLI). Ho quindi controllato lo stato con `git status`, aggiunto solo i file specifici con `git add` (evitando `git add .`), verificato le modifiche in staging e pubblicato il tutto con `git commit` seguito da `git push` verso il mio repository personale su GitHub.

## Verifica finale

Ultimo commit visibile su GitHub: sì, verificato

Stato dell'invito al docente (`inviato` oppure `accettato`): accettato

```text
a3c9802 Completa setup ed evidenza dell'UD01
```

Problema incontrato o possibile: la sezione 13 della guida richiede di eseguire `chmod +x` sullo script diagnostico direttamente dentro `corso-azure-devops` (repository che altrove viene trattato come di sola lettura). Il cambio di permessi è stato registrato da Git come una modifica al file, anche senza toccarne il contenuto.

Prima verifica diagnostica: `git status --short` nel repository del corso, che mostrava `M` sul file dello script. Risolto con `git checkout -- <percorso file>` per riportarlo allo stato originale prima del prossimo `git pull`.

## Controllo sicurezza

- [x] Non sono presenti password, token, chiavi o codici temporanei.
- [x] Non sono presenti e-mail o nomi utente non necessari.
- [x] Non sono presenti subscription ID o tenant ID.
- [x] Gli screenshot eventuali sono stati controllati e ritagliati.
- [x] Gli output riportati sono limitati alle informazioni utili.
