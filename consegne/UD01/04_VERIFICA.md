# Verifica — UD01

## Parte A — Scelte operative

### 1
In PowerShell `git --version` restituisce `2.53.0`, mentre nel terminale Ubuntu restituisce `2.43.0`. Qual è la spiegazione più corretta?

A. Una delle due installazioni è necessariamente danneggiata.        
B. Windows e Ubuntu possono possedere installazioni distinte di Git.
C. WSL converte automaticamente la versione Linux in quella Windows.
D. GitHub decide quale versione visualizzare.

**Risposta: B**

### 2
Quale comando mostra se la distribuzione Ubuntu sta usando WSL 1 o WSL 2?

A. `wsl --version`
B. `uname -r`
C. `wsl --list --verbose`
D. `cat /etc/os-release`

**Risposta: C**

### 3
Perché il progetto viene conservato in `~/workspace`?

A. Per impedire a Windows di leggere i file.
B. Perché Git funziona soltanto nella home Linux.
C. Per lavorare nel file system Linux, più adatto al successivo workflow con Docker e bind mount.
D. Perché `/mnt/c` non è mai accessibile da WSL.

**Risposta: C**

### 4
Git è presente e la sua versione è compatibile. Qual è l'azione corretta?

A. Reinstallarlo comunque per rendere uguali tutte le postazioni.
B. Rimuoverlo e installare sempre l'ultima versione disponibile.
C. Verificarne il funzionamento e proseguire senza reinstallazione.
D. Installare una seconda copia nella stessa distribuzione.

**Risposta: C**

### 5
Dopo `git commit` la pagina GitHub non mostra la modifica. Quale spiegazione è più probabile?

A. Il commit esiste localmente, ma non è ancora stato eseguito `git push`.
B. `git commit` elimina sempre il remote.
C. GitHub aggiorna i repository soltanto una volta al giorno.
D. È obbligatorio reinstallare Git.

**Risposta: A**

### 6
Qual è il controllo più diretto per capire quali file entreranno nel prossimo commit?

A. `git status` dopo `git add`
B. `pwd`
C. `az account show`
D. `wsl --status`

**Risposta: A**

### 7
Durante `az login --use-device-code` il terminale mostra un codice temporaneo. Che cosa devi fare?

A. Inserirlo nel README per dimostrare il login.
B. Condividerlo con il gruppo per accelerare il laboratorio.
C. Usarlo nella pagina di autenticazione e non conservarlo nel repository.
D. Trasformarlo in una variabile Git.

**Risposta: C**

### 8
Quale indizio dimostra meglio che VS Code sta operando dentro Ubuntu?

A. Il tema scuro dell'editor.
B. L'indicatore `WSL: Ubuntu` e un terminale con percorso Linux.
C. La presenza del browser Edge.
D. Il file possiede estensione `.md`.

**Risposta: B**

### 9
Perché il docente deve essere aggiunto come collaboratore al repository personale pubblico?

A. Perché senza invito non può visualizzare un repository pubblico.
B. Per ricevere la password GitHub del partecipante.
C. Per partecipare alle attività di scrittura, revisione e collaborazione previste dal percorso.
D. Per diventare proprietario dell'account del partecipante.

**Risposta: C**

## Parte B — Risposte brevi

### 10
Spiega in non più di quattro righe la differenza fra Git e GitHub.

**Risposta:**
Git è il programma installato sul tuo computer che tiene traccia delle modifiche ai file, funziona anche senza internet. GitHub invece è un sito che ospita online i progetti Git, e permette ad altre persone di vederli o collaborare.

### 11
Scrivi la sequenza minima di comandi che useresti per osservare le modifiche, preparare un singolo file, creare un commit e inviarlo al remote.

**Risposta:**
```
git status
git add <file>
git commit -m "messaggio"
git push
```

### 12
Si propone di eseguire immediatamente `wsl --update` su tutte le postazioni. Quali due controlli devono precedere la decisione?

**Risposta:**
Prima guardo con wsl --status che versione ha ogni PC, e controllo se sta già funzionando bene. Se funziona, non lo tocco, aggiornare "a caso" potrebbe rompere qualcosa che andava bene prima.

### 13
Il comando `code .` apre VS Code, ma il terminale integrato mostra un percorso `C:\Users\...`. Quale problema sospetti e quale verifica esegui?

**Risposta:**
Sospetto che non sono davvero collegato a Ubuntu, ma sto lavorando sul lato Windows, probabilmente ho lanciato code . da PowerShell invece che da un terminale Ubuntu. Controllo l'indicatore in basso a sinistra: se non dice WSL: Ubuntu, confermo il problema, e riprovo aprendo la cartella da dentro Ubuntu.

### 14
Hai pubblicato per errore un vero token in un commit e poi hai cancellato la riga con un secondo commit. Perché il problema non è risolto?

**Risposta:**
Perché il token resta comunque visibile nella cronologia dei commit precedenti, chiunque può tornare indietro e vederlo, anche se il file attuale non lo mostra più. Cancellarlo con un nuovo commit non lo fa sparire dalla storia. Il token va considerato compromesso e va revocato/rigenerato alla fonte, non solo tolto dal file.


