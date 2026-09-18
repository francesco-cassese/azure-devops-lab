# UD10 — Consegna laboratorio guidato

## Preflight

| Campo | Valore |
|---|---|
| `docker version` | 29.8.0 |
| `docker compose version` | v5.5.1 |
| daemon | raggiungibile , `docker info` ha risposto con l'intera sezione Server |
| WSL2 | confermato , Kernel Version: 6.18.33.2-microsoft-standard-WSL2 |
| Docker da WSL2 | OK |
| Self-hosted future Docker readiness | OK |
| RESULT | OK |

## Build backend

| Campo | Valore |
|---|---|
| image | catalog-backend |
| tag | ud10 |
| build context | `.` (la cartella `catalogo-prodotti`) |
| Dockerfile | `docker/backend.Dockerfile` |
| layer/history osservati | ho trovato tutti i pezzi del mio Dockerfile, nell'ordine in cui erano stati scritti. Poi c'erano altre righe più vecchie, di settimane fa, che non erano mie: sono quelle usate per creare l'immagine di python da cui sono partito io |

## Container singolo

| Campo | Valore |
|---|---|
| nome | catalog-backend-ud10 |
| porta | 127.0.0.1:8000, quindi si vede solo dal mio pc |
| health | 200 OK, il servizio risulta su |
| products | 200 OK, 4 prodotti, 2 segnati LOW perché sotto la soglia di 5 |
| log | il container dice che ascolta su 0.0.0.0:8000 con soglia 5 |
| environment verificato | LOW_STOCK_THRESHOLD=5, APP_PORT=8000, RUNTIME_DIR=/runtime; solo la prima l'ho passata io col run, le altre due erano già di default nell'image |

## Compose

| Campo | Valore |
|---|---|
| backend | catalogo-prodotti-backend-1, nessuna porta pubblicata sull'host, solo 8000/tcp interno |
| frontend | catalogo-prodotti-frontend-1, pubblicata su 127.0.0.1:8080 |
| rete | catalogo-prodotti_catalog-net, bridge |
| volume | catalogo-prodotti_catalog-runtime |
| frontend URL | http://127.0.0.1:8080/ |
| backend healthy | sì, diventato healthy dopo circa 3.8s dall'avvio |
| `/health` | 200 OK, risposto da nginx ma il body arriva dal backend |
| `/api/products` | 200 OK, count 4 |
| P001 | 200 OK |
| XXX | 404 |

## Networking

| Campo | Valore |
|---|---|
| `backend` risolto dal frontend | sì, ha dato l'indirizzo 172.18.0.2, e la chiamata a `http://backend:8000/health` ha risposto ok |
| `localhost:8000` dal frontend | fallito, connection refused |
| spiegazione | dentro un container, "localhost" vuol dire se stesso, non gli altri. Quindi il frontend cercando localhost:8000 sta guardando dentro se stesso, dove non c'è niente su quella porta perché lì gira solo nginx sulla 80. Per parlare con l'altro container devo chiamarlo con il suo nome, cioè "backend", e docker capisce da solo a quale indirizzo corrisponde |

## Environment

| Campo | Valore |
|---|---|
| threshold iniziale | 5 |
| threshold temporaneo | 10, cambiato solo nel compose.yaml |
| effetto osservato | P001 (stock 8) è passato da OK a LOW, senza toccare codice o immagine, solo rifacendo `docker compose up -d` |
| valore ripristinato | rimesso a 5 nel compose.yaml e rifatto `docker compose up -d`, P001 tornato OK |

## Volume

| Campo | Valore |
|---|---|
| counter before | chiamato 3 volte, arrivato a 3 |
| counter after recreate | dopo down e up è ripartito da 4, non da 0 |
| persistenza PASS/FAIL | PASS |
| volume | catalog-runtime, non toccato dal down (rimossi solo container e rete) |

## Lifecycle

| Campo | Valore |
|---|---|
| restart test | riavviato solo il backend con `docker compose restart backend`, è tornato su da solo, il frontend non è stato toccato |
| log backend | soprattutto richieste GET /health con 200, più una GET /api/counter, tutto normale |
| log frontend | nginx partito senza errori, loggata una richiesta GET /api/counter |

## Git

| Campo | Valore |
|---|---|
| commit | `007a4b9`, "feat: containerize product catalog with Docker Compose", 12 file cambiati |
| push/PR | ho pushato direttamente su `main`|
