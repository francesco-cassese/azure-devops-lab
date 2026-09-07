# Nota operativa — UD01

La cartella di lavoro si trova nel filesystem Linux di WSL 2 ed è stata aperta con Visual Studio Code tramite l'estensione WSL.

Durante la verifica iniziale, aprendo Ubuntu partendo da una cartella Windows, il comando `pwd` restituiva un percorso sotto `/mnt/c/...` (filesystem Windows montato dentro Linux), non la home Linux nativa. Ho corretto con `cd ~` e poi creato la cartella di lavoro dedicata con `mkdir -p ~/workspace`.

Il controllo che ha dimostrato il corretto contesto di esecuzione è:

```bash
pwd
```

L'output indicava un percorso interno alla home Linux (non iniziava con `/mnt/c`), confermato anche nel test pratico di apertura di VS Code da Ubuntu, dove l'indicatore `WSL: Ubuntu` era visibile nella finestra.

**Nota per il futuro**: aprire sempre Ubuntu senza passare da una cartella Windows, così si parte direttamente in `/home/franc` e non in `/mnt/c`.
