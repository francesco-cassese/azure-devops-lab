# Verifica autonoma — UD01

Per controllare che Ubuntu stesse usando WSL 2 ho lanciato `wsl --list --verbose`: nella colonna `VERSION` c'è scritto `2` per Ubuntu-24.04, quindi va tutto bene.

Il mio repository personale si trova in `~/workspace/azure-devops-lab` — l'ho controllato sia con `pwd` che con `git rev-parse --show-toplevel`, e danno lo stesso risultato, quindi sono davvero nella cartella giusta e non finito per sbaglio in `/mnt/c`. Il remote è `https://github.com/francesco-cassese/azure-devops-lab.git` (visto con `git remote -v`, senza nessun token dentro l'URL, solo l'indirizzo).

Riguardo agli stati di Git: il **working tree** è la cartella con i file come sono adesso; con `git add` sposto le modifiche nella **staging area**, cioè le metto "in lista" per il prossimo commit; con `git commit` creo il **commit locale**, che però esiste solo sul mio computer; solo con `git push` arriva davvero sul **repository remoto** su GitHub. Se faccio commit ma non push, `git status -sb` me lo dice scrivendo `ahead`.

Per Azure ho controllato con `az version` che la CLI fosse installata, e con `az account show --output table` che il login fosse riuscito e vedessi la sottoscrizione giusta. Sono anche andato a controllare in Settings → Collaborators se il docente era stato invitato: risulta già accettato.

Un errore che ho già fatto io in questo laboratorio: se apri Ubuntu partendo da una cartella Windows, ti ritrovi con `pwd` che mostra un percorso dentro `/mnt/c/...` invece che nella home Linux. Basta lanciare `pwd` per capirlo subito, e si corregge con `cd ~`.