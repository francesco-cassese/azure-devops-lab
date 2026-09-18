# UD10 — Consegna laboratorio autonomo

## Baseline

| Campo | Valore |
|---|---|
| compose ps | backend Up (healthy), frontend Up, entrambi già in esecuzione da prima |
| health | 200 OK |

## Errore

| Campo | Valore |
|---|---|
| variabile | LOW_STOCK_THRESHOLD |
| valore errato | "not-a-number" |
| stato backend | Exited (1), il frontend invece è rimasto Up perché era già acceso da prima |
| log/errore | `ValueError: LOW_STOCK_THRESHOLD deve essere un intero, ricevuto: 'not-a-number'`, causata da `int(raw)` che non riesce a convertire la stringa in numero |

## Diagnosi

| Campo | Valore |
|---|---|
| Sintomo | il backend non parte più, esce subito con Exited (1) |
| Risultato atteso | il backend doveva partire normale e diventare healthy come prima |
| Evidenza | il log mostra `ValueError: LOW_STOCK_THRESHOLD deve essere un intero, ricevuto: 'not-a-number'`, e `docker compose config` conferma lo stesso valore nella configurazione |
| Ipotesi | il codice prova a leggere `LOW_STOCK_THRESHOLD` e a trasformarla subito in un numero intero appena parte, e se non ci riesce si ferma con un errore invece di continuare con un valore sbagliato |
| Causa | ho scritto "not-a-number" al posto di un numero nel `compose.yaml`, per la variabile `LOW_STOCK_THRESHOLD` |

## Fix

| Campo | Valore |
|---|---|
| modifica minima | rimesso `LOW_STOCK_THRESHOLD: "5"` nel `compose.yaml`, nient'altro toccato |
| rebuild necessario? | no |
| motivazione | il valore sbagliato era solo scritto nel file, letto quando il container parte. Bastava farlo ripartire con il valore giusto, non serviva rifare tutta l'immagine da capo |

## Test

| Campo | Valore |
|---|---|
| backend healthy | sì |
| health | 200 OK |
| products | 200 OK, count 4, P002 e P004 LOW come prima dell'errore |
| browser | prodotti visibili, confermato |

## Modifica conservata

| Campo | Valore |
|---|---|
| APP_ENV | aggiunta `APP_ENV: "local-docker"` al backend nel compose.yaml |
| compose config | c'è, si vede anche nella versione finale del file |
| test | tutto tornato a posto, il backend è di nuovo su e sta bene |

## Git

| Campo | Valore |
|---|---|
| branch | `fix/ud10-invalid-threshold`, creato da `main` aggiornato |
| commit | `ce2f5fe`, "fix: validate Docker runtime configuration" |
| PR | #3, https://github.com/francesco-cassese/azure-devops-lab/pull/3 |
| diff verificato | sì, limitato a `compose.yaml`, solo l'aggiunta di `APP_ENV` |
| merge | squash and merge, `main` aggiornato a `82ac492`, branch locale e remoto eliminati |


## Passaggio alla verifica

- stack mantenuto attivo: sì
