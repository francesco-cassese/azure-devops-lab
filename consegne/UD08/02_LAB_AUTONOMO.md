# UD08 — Consegna laboratorio autonomo

## Baseline

| Test | Esito |
|---|---|
| health | 200, `{"status":"ok",...}`, testato prima di toccare qualsiasi cosa |
| products | 200, count = 4, tutti i prodotti tornavano bene |

## Errore introdotto

| Elemento | Valore |
|---|---|
| configurazione modificata | `api_prefix` in `config.json`, cambiato da `/api` a `/api-v2` |
| endpoint funzionante | `/api-v2/products` → 200 |
| endpoint non funzionante | `/api/products` → 404 (quello generico "file not found" del server, non il 404 dell'app) |
| comportamento frontend | tabella vuota e "Errore: HTTP 404" a schermo — il JS chiama `fetch("/api/products")` fisso, non legge `config.json` |

## Diagnosi

| Domanda | Risposta |
|---|---|
| il backend è avviato? | sì |
| `/health` funziona? | sì, sempre — non dipende dal prefisso API, è un path fisso |
| quale endpoint prodotti funziona? | `/api-v2/products` |
| quale endpoint usa il frontend? | `/api/products`, scritto fisso nel JS di `index.html` |
| rete, backend spento o contratto incoerente? | contratto/configurazione incoerente tra frontend e backend |

## Fix

| Elemento | Valore |
|---|---|
| causa | `api_prefix` cambiato in `config.json`, ma il frontend continua a chiamare `/api` per conto suo |
| fix | rimesso `"api_prefix": "/api"` |
| environment aggiunto | sì, `"environment": "local"` — serviva perché il solo fix riportava il file identico a `main`, senza niente da committare |

## Test finali

| Test | Esito |
|---|---|
| `/health` | 200 |
| `/api/products` | 200, count = 4 |
| `/api/products/P001` | 200 |
| `/api/products/XXX` | 404, `product_not_found`, corretto perché quel prodotto non esiste |
| browser | tutto a posto, 4 prodotti con stato LOW/OK |

## Git

| Passaggio | Dettaglio |
|---|---|
| branch | `fix/ud08-api-prefix` |
| `git diff` verificato | prima era vuoto (il fix riportava il file identico a main), poi ho visto solo la modifica a `config.json` dopo aver aggiunto `environment=local` |
| commit | `b99854d`, "fix: restore API contract and mark local environment" |
| push | `git push -u origin fix/ud08-api-prefix` |
| PR | #2, https://github.com/francesco-cassese/azure-devops-lab/pull/2 |
| `gh pr diff` verificato | sì, un solo file modificato, niente segreti |
| merge | Squash and merge, branch eliminata sia in locale che da remoto |
| main sincronizzata | sì, fast-forward automatico dopo il merge, confermato con `git log` |

## Distinzione

| Tipo di PR | Come l'ho gestita |
|---|---|
| review collaborativa (lab guidato) | una seconda persona reale ha letto il diff e mi ha chiesto una correzione prima di approvare |
| auto-verifica PR individuale (questo lab) | qui il lavoro era mio, quindi ho controllato io stesso il diff con `gh pr diff` prima del merge, senza dichiarare una review fatta da qualcun altro |
