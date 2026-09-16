# UD08 — Consegna laboratorio guidato

## Repository

| Campo | Risposta |
|---|---|
| repository | `francesco-cassese/azure-devops-lab` |
| branch principale | `main` |
| `gh auth status` verificato | sì, prima di iniziare, e mostrava il mio username giusto |
| working tree iniziale | pulito, `nothing to commit, working tree clean` |

## Collaborazione ricevuta sul mio repository

| Campo | Risposta |
|---|---|
| collaborator | `francescocassese26`, un secondo account mio creato apposta per simulare la collaborazione, dato che in quel momento non avevo un compagno di corso disponibile — il tutor mi ha detto che andava bene così |
| invito accettato | sì |
| branch contributor | `feature/ud08-collab-francescocassese26` |
| PR | #1, https://github.com/francesco-cassese/azure-devops-lab/pull/1 |
| prima review | Request changes, chiedeva di aggiungere una sezione "## Esito" con la frase "Review completata e modifica corretta." |
| nuovo commit dopo la review | sì, pushato sulla stessa branch, la PR si è aggiornata da sola senza doverne aprire una nuova |
| esito review finale | Approve |
| merge | Squash and merge |
| branch remota | eliminata dopo il merge |
| collaboratore rimosso | sì, appena controllato che il file fosse arrivato bene |

## Collaborazione eseguita sul repository altrui

| Campo | Risposta |
|---|---|
| repository | `francescocassese26/azure-devops-lab`, un fork del mio repository — B non aveva un repository suo dalle UD precedenti, quindi il fork è stato il modo più veloce per dargli comunque un repository vero su cui provare la collaborazione |
| branch | `feature/ud08-collab-francesco-cassese` |
| PR | #1, https://github.com/francescocassese26/azure-devops-lab/pull/1 |
| prima review ricevuta | Request changes, "Aggiungi in fondo la riga: Direzione inversa completata." |
| correzione | aggiunta la riga richiesta, nuovo commit pushato sulla stessa branch |
| merge | Squash and merge, poi B mi ha rimosso l'accesso |

## Conflitto locale

| Campo | Risposta |
|---|---|
| branch A | `lab/conflict-a`, `PORT=9000` |
| branch B | `lab/conflict-b`, `PORT=7000` |
| file | `ud08-conflict.txt` |
| marker osservati | `<<<<<<< HEAD` / `PORT=7000` / `=======` / `PORT=9000` / `>>>>>>> lab/conflict-a` |
| contenuto finale scelto | `PORT=8000`, cioè il valore chiesto dalla consegna |
| commit risoluzione | `lab: resolve port conflict` |
| cleanup | file temporaneo rimosso, entrambe le branch locali eliminate, push su main fatto |

## Catalogo prodotti

| Campo | Risposta |
|---|---|
| server avviato | sì, "Catalogo prodotti in ascolto su http://127.0.0.1:8000" |
| `/health` | 200, `{"status":"ok","service":"catalogo-prodotti","version":"1.0"}` |
| `/api/products` | 200, count = 4 |
| `/api/products/P001` | 200 |
| `/api/products/XXX` | 404, giusto così perché quel prodotto non esiste davvero |
| frontend nel browser | funziona, si vede la tabella con i 4 prodotti |
| prodotto in stato LOW | P002 (Monitor 27 UHD, stock 4) e P004 (Keyboard Business, stock 2), sono sotto la soglia `low_stock_threshold=5` che c'è in `config.json` |

## Architettura

| Campo | Risposta |
|---|---|
| frontend | `static/index.html` |
| backend/API | `server.py` |
| configurazione | `config.json` |
| dati | `data/products.json` |
| endpoint | `GET /health`, `GET /api/products`, `GET /api/products/<id>`, `GET /` |

## Baseline Git

| Campo | Risposta |
|---|---|
| commit | `7e5403f`, "feat: add local product catalog" |
| push/PR | ho pushato direttamente su `main`, niente PR: è il mio repository personale e `main` non ha nessuna protezione |
| stato finale main | aggiornata e allineata al remote, working tree pulito |
