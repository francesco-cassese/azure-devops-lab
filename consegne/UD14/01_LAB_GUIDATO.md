# UD14 — Consegna LAB guidato

| Campo | Valore |
|---|---|
| ACR | `acrud1315ayow4e4bcpd7c` |
| admin user | false |
| test locali | `Ran 3 tests in 0.000s`, `OK` |
| Docker build locale | Riuscito, immagine `catalog-backend:ud14-local`, `/health` risponde `ok` |
| `sc-acr-ud14` | Creata, tipo Docker Registry |
| WIF | Sì, Workload identity federation |
| YAML | `pipelines/azure-pipelines-ci.yml` (Microsoft-hosted, `UD14_AGENT_MODE=MICROSOFT_HOSTED`) |
| Stage Test | Riuscito |
| Stage BuildPush | Riuscito, il passo `Build and push to ACR` è durato 14 secondi |
| run CI | `#20260924.2`, verde, su Microsoft-hosted (`ubuntu-latest`) |
| Build ID | `7` |
| tag ACR | `catalog-backend:7` |
