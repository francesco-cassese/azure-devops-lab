# Consegna UD03 — Laboratorio guidato

## Contesto anonimizzato

- sottoscrizione e tenant verificati: sottoscrizione già abilitata da UD01/UD02, confermata con `az account show`, nessun nuovo login necessario.

- percorso Entra eseguito: A. I pulsanti "New user" e "New group" erano cliccabili, e provando davvero a creare l'utente l'operazione è andata a buon fine, quindi ho proseguito su questo percorso.

- resource group temporaneo: `rg-cea-identity-2df2ba`, `italynorth`, creato da CLI con i tag richiesti (`course`, `unit=UD03`, `environment=lab`, `deleteAfter`).

## Identità e assegnazione RBAC

| Principal anonimizzato | Ruolo | Scope | Diretta/ereditata | Motivo |
|---|---|---|---|---|
| Gruppo `grp-cea-readers-2df2ba` | Reader | Resource group `rg-cea-identity-2df2ba` | Diretta | Deve poter consultare le risorse del progetto, non modificarle |
| Account personale | Owner | Sottoscrizione | Ereditata | Ruolo già presente sulla sottoscrizione da prima di questo laboratorio, non l'ho creato io qui |

Ho creato un utente cloud temporaneo (`cea-lab-2df2ba`, alias non personale) e un gruppo di sicurezza (`grp-cea-readers-2df2ba`, membership Assigned), aggiunto l'utente come membro e verificato in Members che comparisse. Poi ho assegnato Reader al gruppo sul resource group da Access control (IAM).

L'autorizzazione necessaria: creare utente e gruppo richiede un ruolo amministrativo Microsoft Entra appropriato (es. User Administrator); assegnare Reader richiede il permesso Azure RBAC `roleAssignments/write` sullo scope del resource group.

Accesso effettivo osservato, verificato sia da CLI (`az role assignment list --include-inherited`) che da portale (Check access): il gruppo ha Reader diretto sul resource group, io ho Owner ereditato dalla sottoscrizione. Le due cose non si annullano a vicenda, si sommano: se io fossi anche membro del gruppo, il mio accesso effettivo resterebbe comunque Owner (il più ampio), non Reader.

Evidenza anonimizzata (subscription ID rimosso):

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

## Governance e costi

- tag: `course=cloud-engineer-academy`, `unit=UD03`, `environment=lab`, `deleteAfter=<omesso>`, gli stessi applicati al resource group in creazione. Servono per inventario e governance, non autorizzano né bloccano nulla da soli.

- lock: creato `lock-cea-delete` (tipo `CanNotDelete`) sul resource group. Per verificarne davvero l'effetto ho provato a eliminare il resource group con `az group delete --name "$LAB_RG" --yes`: comando fallito con errore `ScopeLocked`, e `az group exists` ha confermato `true`. Il lock ha bloccato l'eliminazione anche a me, che pure ho Owner: RBAC e lock lavorano su piani indipendenti.

- Cost Analysis: "No cost reported during this period" per il mese corrente, normale visto che il resource group non contiene risorse a consumo.

- budget: creato `budget-cea-2df2ba`, mensile, 5€, soglia di alert all'80%, notifica sulla mia email (il portale l'ha reso obbligatorio per poter impostare la soglia). Spesa registrata al momento: 0€.

- perché il budget non blocca la spesa: è solo un confronto con notifica. Se la spesa superasse la soglia, arriverebbe un'email, ma nessuna risorsa verrebbe spenta o eliminata da sola: toccherebbe comunque a me intervenire.

## Cleanup

Registra rimozione degli oggetti temporanei e verifica finale del resource group.

## Rilevanza professionale

In questo laboratorio le tre cose sono rimaste ben distinte. L'autenticazione era il login già attivo, non più in discussione una volta verificato. L'autorizzazione RBAC ha deciso chi può fare cosa: il gruppo poteva solo leggere, io potevo modificare ed eliminare perché Owner ereditato. Il blocco di governance (il lock) ha agito su un piano diverso: ha impedito l'eliminazione anche a me, che secondo RBAC ne avevo pieno diritto. In pratica: l'autenticazione dice chi sei, l'autorizzazione RBAC dice cosa puoi fare in base al tuo ruolo, il blocco di governance dice cosa è permesso su quella risorsa indipendentemente da chi lo chiede. Sono tre controlli che si sommano, superarne uno non basta a superare gli altri.
