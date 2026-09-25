# UD15 — Consegna LAB autonomo

| Campo | Valore |
|---|---|
| branch errore | `fix/ud15-target-port`, commit `test: introduce wrong target port`, Pull Request #6 |
| target port errato | `9999` (invece di `8000`) |
| differenza nel Terraform plan | `~ target_port = 8000 -> 9999` e `Plan: 0 to add, 1 to change, 0 to destroy.` Cioè Terraform cambia una sola cosa nella Container App |
| IaC | verde, 51s |
| Test | verde, 8s |
| BuildPush | verde, 25s |
| Deploy | verde, 1m 15s. Terraform ha applicato la modifica senza errori |
| Smoke | rosso, 1m 6s. `/health` rispondeva, ma con `version: 21` invece di 26 (il Build ID della run), cioè la versione vecchia |
| evidenza ingress | `az containerapp ingress show`: `TargetPort 9999` |
| evidenza log | `az containerapp logs show`: `backend 26 listening on 0.0.0.0:8000`, cioè l'app ascolta sulla porta 8000 |
| causa | L'ingress manda il traffico alla porta 9999 ma l'app ascolta sulla 8000. La nuova revision non diventa pronta e Azure continua a servire quella vecchia (versione 21), quindi lo smoke test trova la versione sbagliata |
| correzione minima | Rimettere `targetPort: '8000'` nel file della pipeline con una nuova Pull Request, senza cambiare altro |
| branch correzione | `fix/ud15-target-port-correct`, commit `fix: restore container app target port` |
| run finale | `#20260925.7` su `main`, Build ID 31 |
| smoke finale | verde, 41s. `/health` risponde `status: ok` con `version: 31` e la porta è di nuovo `8000` |
