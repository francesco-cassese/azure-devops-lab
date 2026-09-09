# Consegna UD03 — Rinforzo pomeriggio (Microsoft Learn)

## Modulo 1 — Understand Microsoft Entra ID

1. **Domanda:** Tenant Entra ID e subscription Azure sono la stessa cosa?<br>

   **Risposta:** No, non sono la stessa cosa. Il tenant è dove sta chi può accedere, utenti e gruppi. La sottoscrizione invece è dove stanno le risorse vere, tipo VM o storage, ed è legata alla fatturazione. Una sottoscrizione sta sempre dentro un solo tenant, ma un tenant può avere più sottoscrizioni dentro.

---

2. **Domanda:** Qual è il ruolo di Microsoft Entra ID?<br>

   **Risposta:** Il suo ruolo è gestire identità e accessi nel cloud. In pratica controlla chi sei (login) e cosa puoi fare, per utenti, gruppi e app. Dà anche cose come il login unico (SSO) e l'autenticazione a più fattori.

---

3. **Domanda:** Qual è la differenza generale tra Microsoft Entra ID e Active Directory Domain Services?<br>

   **Risposta:** AD DS è il vecchio sistema, installato su un server che gestisco io, pensato per i computer in azienda. Entra ID invece è nel cloud, lo gestisce Microsoft, ed è pensato per le app web. Cambiano anche i protocolli sotto: niente Kerberos o LDAP, ma cose come OAuth.

---

4. **Domanda:** Perché un'applicazione cloud può utilizzare Microsoft Entra ID?<br>

   **Risposta:** Perché così l'app non deve gestirsi da sola login e password: si appoggia a Entra ID per far fare l'accesso agli utenti. In più permette il login unico, con lo stesso account su più app collegate allo stesso tenant.

---

## Modulo 2 — Create, configure, and manage identities

**Domanda:** Hai 12 sistemisti che devono ricevere gli stessi permessi su un Resource Group. Quale soluzione è preferibile?

A. 12 assegnazioni separate agli utenti
B. Creare un gruppo e assegnare il ruolo al gruppo

**Risposta:** B. Con un gruppo il ruolo si assegna una sola volta: aggiungere o togliere un sistemista significa aggiungerlo o toglierlo dal gruppo, senza creare o rimuovere 12 role assignment separate ogni volta che cambia qualcuno.

---

## Modulo 4 — Azure Policy: laboratorio Governance Baseline

Ho creato il resource group `rg-ud03-policy` in `italynorth` dal portale. Prima di assegnarle, sono andato a vedere come sono fatte le due policy built-in che mi servivano: **Allowed locations** (ha un parametro per le region ammesse e uno per l'effetto, di default `Deny`) e **Require a tag and its value on resources** (ha i parametri per nome e valore del tag, ma qui l'effetto è `deny` fisso, non lo puoi cambiare).

Ho provato a creare una Initiative custom per raggruppare le due policy, ma il portale non mi caricava nessuna policy built-in nella ricerca, nemmeno con termini generici o campo vuoto, nemmeno dopo un refresh della pagina. Sembrava un problema del portale in quel momento, non qualcosa che dipendeva da come cercavo. Ho seguito quindi il fallback indicato dal foglio: ho assegnato le due policy singolarmente sullo stesso resource group, senza passare da un'Initiative.

- **Allowed locations**: assegnata su `rg-ud03-policy`, con `italynorth` come region autorizzata.
- **Require a tag and its value on resources**: assegnata su `rg-ud03-policy`, con `Tag name = Environment` e `Tag value = Training`.

### Test di conformità

**Test A** — `vnet-test01`, region autorizzata, tag assente. Previsione: dovrebbe fallire, la policy sul tag ha effetto `deny`, blocca la creazione se manca il tag richiesto, non la crea semplicemente senza tag. Confermato: `Deployment validation failed... policy violation`.

**Test B** — `vnet-test02`, tag corretto, region non autorizzata. Previsione: dovrebbe fallire comunque, stavolta per la policy sulle region, non per il tag. Confermato: `Deployment validation failed... policy violation`.

**Test C** — `vnet-test03`, region autorizzata, tag corretto. Previsione: nessuna policy dovrebbe scattare, creazione riuscita. Confermato: la VNet è stata creata senza errori.

Cleanup: eliminato il resource group `rg-ud03-policy` (rimuove insieme le tre VNet di test e le policy assignment collegate, nessun lock presente in questo laboratorio).

### RBAC vs Policy

**Domanda:** Un utente è Owner del Resource Group. Una Policy consente solo determinate regioni. L'utente prova a distribuire una risorsa in una regione non consentita. Il fatto che l'utente sia Owner gli consente di ignorare automaticamente la Policy?

**Risposta:** No, non la può ignorare. Owner è RBAC, decide solo chi può provare a fare cosa. La Policy invece decide se quella configurazione è permessa, e vale per tutti allo stesso modo, anche per chi ha Owner. Sono due controlli separati: uno ti dà il permesso di provarci, l'altro controlla se quello che stai facendo va bene. L'ho visto anche nel test B del laboratorio: la policy ha bloccato la region sbagliata senza guardare che ruolo avevo.

---

## Quiz finale – stile AZ-104

1. Un utente ha Reader su un Resource Group ma Contributor sulla subscription che lo contiene. Quali autorizzazioni effettive possiede sul Resource Group?

   - A. Solo Reader
   - B. Contributor
   - C. Owner
   - D. Nessuna

   **Risposta:** B. I permessi si sommano, vince il più ampio: qui è Contributor.

2. Un tecnico deve creare e modificare VM, dischi e reti ma non deve assegnare ruoli RBAC.

   - A. Reader
   - B. Contributor
   - C. Owner
   - D. Global Administrator

   **Risposta:** B. Contributor modifica le risorse ma non assegna ruoli, è proprio quello che serve qui.

3. Quale componente Azure RBAC identifica chi riceve le autorizzazioni?

   - A. Scope
   - B. Role definition
   - C. Security principal
   - D. Resource Lock

   **Risposta:** C. Security principal è il chi. Role definition è il cosa, mi confondo facile tra i due.

4. Quale componente Azure RBAC definisce quali operazioni sono consentite?

   - A. Role definition
   - B. Tenant
   - C. Management Group
   - D. Security principal

   **Risposta:** A. Role definition dice cosa si può fare.

5. L'organizzazione deve impedire la distribuzione di risorse al di fuori delle regioni autorizzate.

   - A. Azure RBAC
   - B. Azure Policy
   - C. Resource Lock
   - D. NSG

   **Risposta:** B. È la policy Allowed locations, l'ho provata sopra nel laboratorio.

6. Una risorsa critica di produzione non deve essere eliminata accidentalmente.

   - A. Reader
   - B. Policy con Audit
   - C. Resource Lock CanNotDelete
   - D. Budget

   **Risposta:** C. Il lock blocca l'eliminazione a tutti, anche a chi ha il ruolo giusto.

7. Un Resource Group ha un lock CanNotDelete.

   - A. Non può essere modificato né eliminato
   - B. Può essere modificato ma non eliminato
   - C. Può essere eliminato dagli Owner
   - D. Sono bloccate solo modifiche di rete

   **Risposta:** B. CanNotDelete blocca solo l'eliminazione, le modifiche si possono ancora fare.

8. È stato impostato un Budget mensile di 100 euro. Cosa accade normalmente superando 100 euro?

   - A. Azure arresta tutte le VM
   - B. Azure elimina alcune risorse
   - C. Il Budget può generare avvisi, ma non blocca automaticamente la spesa
   - D. La subscription viene sospesa immediatamente

   **Risposta:** C. Il budget avvisa, non blocca la spesa.

9. Un utente deve visualizzare le risorse di un Resource Group senza modificarle.

   - A. Reader
   - B. Contributor
   - C. Owner
   - D. User Access Administrator

   **Risposta:** A. Reader è sola lettura.

10. Quale descrizione distingue correttamente RBAC e Policy?

    - A. RBAC controlla la rete e Policy gli utenti
    - B. RBAC stabilisce chi può eseguire operazioni; Policy stabilisce quali configurazioni sono consentite
    - C. RBAC si applica solo alle VM
    - D. Sono la stessa funzionalità

    **Risposta:** B. Chi può agire (RBAC) e cosa è permesso configurare (Policy) sono due cose diverse.

---

# Riferimenti ufficiali

- Learning path AZ-104 – Manage identities and governance in Azure
  https://learn.microsoft.com/en-us/training/paths/az-104-manage-identities-governance/

- Study guide AZ-104
  https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-104

- Azure Policy initiatives
  https://learn.microsoft.com/en-us/training/modules/sovereignty-policy-initiatives/
