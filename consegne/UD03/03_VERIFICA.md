# Consegna UD03 — Verifica

## Parte A — Scelta singola

Per le domande 1–8 riporta risposta e motivazione.

**Domanda 1**: Un utente accede al portale ma non può leggere un resource group. Quale affermazione è corretta?
- A. L'autenticazione è fallita
- B. L'autenticazione è riuscita, ma manca un'autorizzazione applicabile
- C. Il tenant non esiste
- D. Deve ricevere Global Administrator

**Risposta**: B. Ha fatto login con successo, l'autenticazione è ok. Sul resource group però non ha nessuna assegnazione di ruolo che gli permetta la lettura: manca l'autorizzazione, non l'accesso.

---

**Domanda 2**: Quale elemento non appartiene alla role assignment Azure?
- A. Principal
- B. Role definition
- C. Scope
- D. Password

**Risposta**: D. Una role assignment è fatta da principal, role definition e scope. La password riguarda l'autenticazione, non la role assignment.

---

**Domanda 3**: Un team deve soltanto consultare un resource group. Qual è la scelta minima?
- A. Owner sulla sottoscrizione
- B. Contributor sul resource group
- C. Reader sul resource group
- D. Global Administrator

**Risposta**: C. Deve solo consultare, quindi basta Reader, e sullo scope minimo necessario: il resource group, non la sottoscrizione.

---

**Domanda 4**: Un ruolo assegnato alla sottoscrizione rispetto a un resource group figlio è normalmente:
- A. eliminato
- B. ereditato
- C. convertito in ruolo Entra
- D. valido solo per Cost Management

**Risposta**: B. Un ruolo assegnato alla sottoscrizione si propaga automaticamente ai resource group sotto di essa. Se poi c'è anche un'assegnazione diretta sul resource group, le due si sommano.

---

**Domanda 5**: Quale ruolo può gestire risorse ma normalmente non creare role assignment?
- A. Reader
- B. Contributor
- C. Owner
- D. User Administrator

**Risposta**: B. Contributor può leggere e modificare le risorse, ma non può assegnare ruoli: quel permesso serve Owner o Role Based Access Control Administrator. Owner può fare tutto, incluso assegnare ruoli, quindi non è la risposta minima. User Administrator è un ruolo Microsoft Entra, non un ruolo Azure per la gestione risorse.

---

**Domanda 6**: Un lock `CanNotDelete` applicato a un resource group:
- A. impedisce anche ogni lettura
- B. sostituisce Azure RBAC
- C. impedisce l'eliminazione finché applicabile
- D. elimina automaticamente il gruppo a scadenza

**Risposta**: C. Blocca solo l'eliminazione, non la lettura, non sostituisce RBAC e non ha scadenza automatica.

---

**Domanda 7**: Un budget Azure al 100%:
- A. arresta automaticamente tutte le risorse
- B. genera una condizione di notifica, ma non costituisce un tetto automatico
- C. assegna Reader al team FinOps
- D. impedisce nuovi deployment in ogni sottoscrizione

**Risposta**: B. Il budget è solo un confronto con notifica, non blocca mai la spesa in automatico.

---

**Domanda 8**: Dove si gestisce normalmente la creazione di un utente cloud?
- A. Azure RBAC sul resource group
- B. Microsoft Entra ID con ruolo appropriato
- C. Tag del resource group
- D. Resource lock

**Risposta**: B. Creare utenti è gestione dell'identità nel tenant, non una questione di RBAC su risorse.

## Parte B — Risposte brevi

**Domanda 9**: Spiega perché assegnare ruoli a un gruppo è spesso preferibile alle assegnazioni individuali.

**Risposta**: Basta aggiungere o togliere una persona dal gruppo, il ruolo resta assegnato al gruppo e si applica a chi ne fa parte. Non serve ricreare o cancellare una role assignment per ogni singola persona ogni volta.

---

**Domanda 10**: Distingui ruolo Microsoft Entra e ruolo Azure con un esempio per ciascuno.

**Risposta**: I ruoli Microsoft Entra riguardano gli oggetti della directory: utenti, gruppi, domini. Esempio: User Administrator, che crea e gestisce utenti nel tenant. I ruoli Azure riguardano le risorse Azure tramite RBAC. Esempio: Reader, che legge una risorsa senza modificarla. Sono due sistemi separati, uno non dà automaticamente permessi nell'altro.

---

**Domanda 11**: Un utente ha Reader sul resource group e Contributor ereditato dalla sottoscrizione. Qual è l'accesso effettivo e perché?

**Risposta**: L'accesso effettivo è Contributor: legge e modifica le risorse del resource group. I permessi si sommano, il Reader diretto non riduce niente, resta assorbito dal Contributor più ampio ereditato. Non può comunque assegnare ruoli ad altri, perché serve Owner o Role Based Access Control Administrator.

---

**Domanda 12**: Elenca in ordine almeno quattro controlli per diagnosticare `AuthorizationFailed`.

**Risposta**: Quando un accesso non torna, prima capisco quale identità sta operando, poi in quale tenant e sottoscrizione, quale azione specifica è stata negata, e su quale scope.

---

**Domanda 13**: Spiega la differenza tra tag `deleteAfter`, lock `CanNotDelete` e budget.

**Risposta**: Il tag `deleteAfter` è solo informativo, non fa nulla da solo. Il lock `CanNotDelete` blocca davvero l'eliminazione, a prescindere dal ruolo RBAC di chi la richiede. Il budget è una soglia di spesa: se la superi arriva solo una notifica, non blocca niente.

## Parte C — Caso situazionale

Un tecnico deve consultare una VNet in `rg-network-prod`. Riceve Contributor sull'intera sottoscrizione. Successivamente non riesce ad assegnare Reader a un collega e, tentando il cleanup, riceve `ScopeLocked`.

**Domanda 14**: Individua almeno due scelte o interpretazioni errate.

**Risposta**: Primo errore, gli serve solo consultare la VNet ma gli danno Contributor, che permette anche di modificare. Secondo errore, lo scope è l'intera sottoscrizione invece del solo resource group `rg-network-prod` dove si trova la VNet.

---

**Domanda 15**: Proponi il ruolo e lo scope iniziali più appropriati.

**Risposta**: Reader sul resource group `rg-network-prod`. Basta per consultare la VNet, senza permessi di modifica né uno scope più ampio del necessario.

---

**Domanda 16**: Spiega separatamente perché non riesce ad assegnare il ruolo e perché non riesce a eliminare lo scope.

**Risposta**: Non riesce ad assegnare Reader al collega perché Contributor non ha il permesso `roleAssignments/write`, serve Owner o Role Based Access Control Administrator. Non riesce a eliminare lo scope perché c'è un lock `CanNotDelete`, che blocca l'eliminazione a chiunque, indipendentemente dal ruolo RBAC posseduto.

Controlla e prepara soltanto il file della verifica:

```bash
git diff -- consegne/UD03/03_VERIFICA.md
git add consegne/UD03/03_VERIFICA.md
git diff --cached -- consegne/UD03/03_VERIFICA.md
```
