# UD11 — Consegna laboratorio guidato

## Preflight

| Campo | Valore |
|---|---|
| Azure | OK, `az account show` risponde con la subscription "Azure subscription 1" |
| Docker | OK, Client e Server alla stessa versione 29.8.0, daemon raggiungibile |
| containerapp extension | installata, versione 1.3.0b5 |
| Microsoft.App | all'inizio era NotRegistered, l'ho registrato io con `az provider register`, ora è Registered |
| Microsoft.OperationalInsights | già Registered |

## ACR

| Campo | Valore |
|---|---|
| nome | acr1789980304ud11 |
| SKU | Basic |
| login server | acr1789980304ud11.azurecr.io, restituito da Azure nell'output di `az acr create` |
| repository | catalog-backend |
| tag v1 | v1 |
| tag v2 | v2 |
| admin user abilitato | NO |

## v1

| Campo | Valore |
|---|---|
| local test | OK, image `catalog-backend:ud11-v1`, `/health` su 127.0.0.1:18000 ha risposto status ok, service catalog-backend, version v1 |
| push | OK, `acr1789980304ud11.azurecr.io/catalog-backend:v1` è presente in ACR, l'ho verificato con `az acr repository show-tags` |
| ACR tag | v1 |
| ACA environment | acaenv-ud11, stato Succeeded |
| Container App | catalog-api-ud11 |
| managed identity | SystemAssigned |
| registry identity | il login server acr1789980304ud11.azurecr.io, con identità `system` |
| ingress | external |
| target port | 8000 |
| FQDN | catalog-api-ud11.icydesert-a7f3fa04.italynorth.azurecontainerapps.io |
| health | OK, `/health` risponde 200 |
| version | v1 |
| revision | catalog-api-ud11--v1, attiva e Healthy con 1 replica |
| logs | il backend dice "Catalog backend v1 listening on http://0.0.0.0:8000 threshold=5", poi ci sono le richieste GET /health e GET /api/products, entrambe 200 |

## v2

| Campo | Valore |
|---|---|
| Dockerfile version | APP_VERSION=v2, cambiato da v1 |
| local test | OK, image `catalog-backend:ud11-v2`, `/health` su 127.0.0.1:18001 ha risposto status ok, service catalog-backend, version v2 |
| push | OK, `acr1789980304ud11.azurecr.io/catalog-backend:v2`, è stato caricato un solo layer nuovo, tutti gli altri erano già in ACR |
| ACR tag | v2, ora in ACR ci sono sia v2 che v1 |
| update | OK, `az containerapp update` con image `catalog-backend:v2`, APP_VERSION=v2 e revision-suffix v2 |
| revision | catalog-api-ud11--v2, attiva |
| health | OK, `/health` risponde 200 |
| version | v2 |

## Scaling

| Campo | Valore |
|---|---|
| minReplicas | 0 |
| maxReplicas | 1 |
| scale-to-zero possibile | sì, perché minReplicas è 0: se non arriva traffico l'app può scendere a zero repliche, e la prima richiesta dopo può essere più lenta (cold start) |
