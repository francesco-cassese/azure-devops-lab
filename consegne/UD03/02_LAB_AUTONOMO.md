# Consegna UD03 — Laboratorio autonomo

## Analisi dell'accesso

| Principal anonimizzato | Ruolo | Scope | Origine | Accesso effettivo |
|---|---|---|---|---|
| Gruppo dedicato al team FinOps (proposto) | Reader | Resource group `LAB_RG` | Diretta (da assegnare) | Solo lettura di costi e risorse, nessuna modifica |
| Gruppo `grp-cea-readers-2df2ba` | Reader | Resource group `rg-cea-identity-2df2ba` | Diretta | Solo lettura, verificato con `az role assignment list --include-inherited` e Check access |
| Account personale | Owner | Sottoscrizione | Ereditata | Lettura, modifica ed eliminazione risorse, gestione accessi |

Per il team FinOps darei Reader sul resource group, non su tutta la sottoscrizione. Devono solo consultare costi e risorse di un ambiente, non modificare né gestire accessi. Contributor permetterebbe di modificare ed eliminare risorse, Owner anche di gestire gli accessi di altri: darebbero permessi che non servono, e se qualcosa va storto (errore o account rubato) il danno sarebbe più grande del necessario.

L'assegnazione Reader del laboratorio guidato non riduce il mio Owner ereditato. Reader ce l'ha il gruppo, Owner ce l'ho io con il mio account personale: sono due identità diverse, il gruppo e io non siamo la stessa cosa, quindi qui non c'è nemmeno sovrapposizione. Se il mio account fosse stato membro del gruppo, avrei avuto Reader e Owner insieme, e Reader non mi avrebbe tolto niente di Owner: i permessi RBAC si sommano sempre, non si sottraggono mai, che siano diretti o ereditati.

Evidenza anonimizzata:

```json
[
  {
    "PrincipalType": "User",
    "Role": "Owner",
    "Scope": "/subscriptions/<omitted>"
  },
  {
    "PrincipalType": "User",
    "Role": "Owner",
    "Scope": "/subscriptions/<omitted>"
  },
  {
    "PrincipalType": "Group",
    "Role": "Reader",
    "Scope": "/subscriptions/<omitted>/resourceGroups/rg-cea-identity-2df2ba"
  }
]
```

## Diagnosi dei casi

### Caso A

```text
Please run 'az login' to setup account.
```

**Sintomo**: la CLI risponde così a un comando qualsiasi, senza nemmeno provare a leggere le risorse.

**Causa probabile**: non c'è una sessione Azure CLI attiva su questa macchina. O non ho mai fatto login, o la sessione precedente è scaduta.

**Verifica**: `az account show`. Se non sono loggato fallisce anche questo, invece di restituirmi subscription e utente.

**Correzione**: `az login --use-device-code`, quello che uso sempre su WSL: mostra un sito e un codice temporaneo, apro il sito nel browser e inserisco lì il codice, senza scrivere password nel terminale.

**Risultato atteso**: rifacendo `az account show` vedo nome e id della subscription, l'utente collegato e lo stato `Enabled`, senza errori.

### Caso B

```text
AuthorizationFailed ... Microsoft.Authorization/roleAssignments/write
```

**Sintomo**: il comando fallisce mentre provo ad assegnare un ruolo a qualcuno.

**Causa probabile**: sono loggato, quindi qui non è un problema di accesso ma di permesso specifico. Assegnare un ruolo richiede `roleAssignments/write`, e dalla tabella dei ruoli fondamentali solo Owner e Role Based Access Control Administrator ce l'hanno. Se sullo scope ho solo Reader o Contributor, è normale che fallisca.

**Verifica**: `az role assignment list --scope "$RG_SCOPE" --include-inherited --output table`, per vedere che ruolo ho davvero su quello scope.

**Correzione**: non risolvo dandomi Owner tanto per sbloccare in fretta. Chiedo a chi ha già Owner o Role Based Access Control Administrator su quello scope di assegnarmi solo il ruolo che mi serve, sullo scope giusto.

**Risultato atteso**: rifacendo `az role assignment list` vedo la nuova assegnazione, e l'operazione che prima falliva adesso funziona.

### Caso C

```text
ScopeLocked: The scope is locked and can't be deleted.
```

**Sintomo**: provo a eliminare una risorsa o un resource group e il comando fallisce con questo errore.

**Causa probabile**: sullo scope c'è un lock `CanNotDelete`. Blocca l'eliminazione a chiunque, anche a chi ha Owner: l'ho verificato io stesso nel laboratorio guidato, provando a eliminare il resource group con Owner attivo e ottenendo comunque `ScopeLocked`.

**Verifica**: `az lock list --resource-group "$LAB_RG" --output table` mostra il lock presente.

**Correzione**: `az lock delete` per togliere il lock, solo dopo procedo con l'eliminazione se serve davvero.

**Risultato atteso**: `az lock list` torna vuoto, e a quel punto l'eliminazione riesce. `az group show --name "$LAB_RG" --output table` invece funziona anche con il lock ancora attivo, perché legge soltanto, non elimina né modifica.

## Budget, lock e cleanup

Il laboratorio guidato mi ha mostrato tre controlli distinti, che qui uso solo per ragionare, senza creare o modificare altri oggetti oltre a quelli già esistenti.

Il ruolo RBAC dice cosa può fare un principal. Il gruppo `grp-cea-readers-2df2ba` ha Reader: può solo leggere, non modificare né eliminare.

Il lock è un controllo diverso, non dipende dal ruolo. Sul resource group `rg-cea-identity-2df2ba` c'è `lock-cea-delete`, tipo `CanNotDelete`. Nel laboratorio guidato ho provato a eliminare il resource group con Owner attivo, e ho comunque ricevuto `ScopeLocked`: il lock blocca l'eliminazione a chiunque, anche a chi ha Owner.

Il budget invece non blocca niente. `budget-cea-2df2ba` confronta la spesa con una soglia, 5€ al mese, alert all'80%, e manda solo una notifica via email quando la superi. Nessuna risorsa viene spenta o cancellata da sola.

Checklist di cleanup, in ordine:

- rimuovere il budget
- rimuovere l'assegnazione Reader al gruppo
- rimuovere il lock `CanNotDelete`
- rimuovere utente e gruppo temporanei
- eliminare il resource group con `az group delete --name "$LAB_RG" --yes`
- verificare con `az group exists --name "$LAB_RG"` che risulti `false`

Il lock va tolto prima di eliminare il resource group, altrimenti l'eliminazione fallisce con `ScopeLocked`. Budget e assegnazione Reader non bloccano l'eliminazione, ma li tolgo comunque per primi per non lasciare riferimenti a un resource group che sto per cancellare.

## Risultato finale

- output anonimizzati utilizzati: l'evidenza JSON in "Analisi dell'accesso" (`az role assignment list --include-inherited`, subscription id omesso)
- cleanup verificato: rimossi in ordine il lock `lock-cea-delete`, il budget `budget-cea-2df2ba`, l'assegnazione Reader del gruppo, l'utente `cea-lab-2df2ba` e il gruppo `grp-cea-readers-2df2ba`, infine il resource group `rg-cea-identity-2df2ba`. Confermato con `az group exists --name "$LAB_RG"` che risulta `false`.
- hash abbreviato e messaggio del commit: `5e65321`, "Completa laboratorio identita accessi e governance"
