# UD11 — Consegna laboratorio autonomo

## Baseline

| Campo | Valore |
|---|---|
| status | OK, `/health` risponde con status ok e service catalog-backend, l'app è raggiungibile e funziona |
| version | v2 |
| target port | 8000 |

## Errore

| Campo | Valore |
|---|---|
| nuovo target port | 9999 |
| sintomo | `upstream connect error or disconnect/reset before headers. retried and the latest reset reason: remote connection failure, transport failure reason: delayed connect error: Connection refused`, cioè l'ingress non riesce a collegarsi al backend e la connessione viene rifiutata |
| HTTP/timeout | HTTP/2 503, quindi è arrivata una risposta di errore e non si tratta di un timeout |

## Evidenze

| Campo | Valore |
|---|---|
| running status | Running, l'app risulta accesa |
| revision | `catalog-api-ud11--v2`, sempre la stessa di prima dell'errore, cambiare la porta non ne ha creata una nuova |
| health | Healthy, la revision risulta sana |
| log listen port | 8000, il backend dice `Catalog backend v2 listening on http://0.0.0.0:8000`, ed è partito senza errori |
| ingress target port | 9999, quindi diversa dalla 8000 su cui ascolta il backend |

**Domanda:** Il backend risulta avviato su quale porta?

**Risposta:** il backend risulta attivo sulla porta 8000

## Diagnosi

| Campo | Valore |
|---|---|
| Sintomo | `/health` risponde 503 con "connection refused" invece del solito 200 con status ok |
| Risultato atteso | `/health` con status ok e version v2, come nella baseline |
| Evidenza | il backend nei log ascolta sulla 8000 e la revision è Running e Healthy, ma l'ingress ha target port 9999, e nei log non compare nessuna richiesta dopo la baseline, quindi le richieste si fermano prima di arrivare al container |
| Ipotesi | l'ingress sta mandando le richieste a una porta diversa da quella su cui ascolta l'app |
| Causa | il target port era stato messo a 9999 invece di 8000 |
| Correzione minima | rimettere il target port a 8000, senza toccare image, revision o identità |

## Verifica

| Campo | Valore |
|---|---|
| target port | 8000, riportato da 9999 al valore su cui ascolta il backend |
| health | OK, `/health` risponde di nuovo con status ok e service catalog-backend, come nella baseline |
| version | v2, la stessa di prima dell'errore |

## Domande

1. **Domanda:** Era necessario creare una nuova image?

    **Risposta:** no, l'image era giusta e il backend partiva e ascoltava sulla 8000, il problema stava solo nella porta a cui l'**ingress** mandava le richieste, quindi bastava cambiare quell'impostazione.

---

2. **Domanda:** Era necessario fare push di v3?

    **Risposta:** no, il codice e l'image non sono cambiati, quindi non c'era niente di nuovo da pubblicare in **ACR**.

---

3. **Domanda:** Il problema era ACR, managed identity o ingress?

    **Risposta:** l'**ingress**. L'image era già stata scaricata e l'app risultava Running e Healthy, quindi **ACR** e **managed identity** avevano già fatto il loro lavoro, il guasto stava solo nel **target port**.

---

4. **Domanda:** Quale evidenza ha identificato la causa?

    **Risposta:** il confronto tra la porta che il backend dichiarava nei log, la 8000, e il **target port** dell'ingress, la 9999, che non coincidevano, insieme al fatto che nei log non arrivava nessuna richiesta dopo la baseline.

---

5. **Domanda:** Perché modificare più impostazioni contemporaneamente sarebbe stato un errore metodologico?

    **Risposta:** perché se cambio più cose insieme e poi funziona non so quale modifica ha risolto il problema, e rischio anche di crearne altri, mentre cambiandone una alla volta capisco subito cosa ha effetto.

---

## Passaggio alla verifica

- target port ripristinato a 8000: sì, rimesso a 8000 con `az containerapp ingress update`
- health v2 nuovamente OK: sì, `/health` risponde di nuovo con status ok e version v2
- Resource Group mantenuto disponibile: sì
