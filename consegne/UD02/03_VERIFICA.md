# Consegna UD02 — Verifica

## Parte A — Scelte operative

Per le domande 1–8 riporta risposta e motivazione.

1. **Domanda:** un'applicazione aziendale richiede controllo completo del sistema operativo e installazione di un componente non supportato da un servizio gestito. Quale modello è più coerente?<br>

   A. SaaS  
   B. IaaS  
   C. PaaS senza configurazioni  
   D. Soltanto cloud privato<br>

   **Risposta:** B<br>

   **Motivazione:** serve controllo completo del sistema operativo per installare un componente non supportato da un servizio gestito, e questo lo offre solo IaaS.

---

2. **Domanda:** usando Azure App Service, quale responsabilità rimane normalmente al cliente?<br>

   A. Manutenzione dell'hardware fisico  
   B. Aggiornamento dell'hypervisor  
   C. Configurazione dell'applicazione, identità, accessi e dati  
   D. Alimentazione dei datacenter<br>

   **Risposta:** C<br>

   **Motivazione:** con App Service Microsoft gestisce hardware, virtualizzazione, sistema operativo e runtime; al cliente restano configurazione dell'app, identità, accessi e dati.

---

3. **Domanda:** quale affermazione descrive correttamente un resource group?<br>

   A. È sempre una rete privata  
   B. È il confine fisico di una availability zone  
   C. È un contenitore logico per risorse che possono condividere ciclo di vita e governance  
   D. Sostituisce la sottoscrizione<br>

   **Risposta:** C<br>

   **Motivazione:** il resource group è un contenitore logico, non un confine fisico, e raggruppa risorse che condividono ciclo di vita e governance.

---

4. **Domanda:** il resource group si trova in `italynorth`. Quale conclusione è corretta?<br>

   A. Tutte le risorse devono obbligatoriamente trovarsi in `italynorth`  
   B. La località indica dove Azure conserva i metadati del resource group; le risorse possono avere località proprie  
   C. Il resource group è automaticamente distribuito in tutte le zone italiane  
   D. La località non viene registrata da Azure<br>

   **Risposta:** B<br>

   **Motivazione:** la località del resource group riguarda solo dove Azure salva i suoi metadati, non obbliga le risorse al suo interno alla stessa region.

---

5. **Domanda:** prima di eseguire `az group create`, quale controllo riduce maggiormente il rischio di creare risorse nel contesto sbagliato?<br>

   A. `git status`  
   B. `az account show`  
   C. `pwd`  
   D. `docker ps`<br>

   **Risposta:** B<br>

   **Motivazione:** `az account show` conferma la sottoscrizione attiva prima di creare qualcosa, evitando di lavorare nel contesto sbagliato.

---

6. **Domanda:** quale nome è formalmente compatibile con uno storage account Azure?<br>

   A. `st-cea-UD02`  
   B. `Storage_CEA_02`  
   C. `stcea02a7f9`  
   D. `st cea 02`<br>

   **Risposta:** C<br>

   **Motivazione:** `stcea02a7f9` usa solo lettere minuscole e numeri, il vincolo di naming per uno storage account; le altre opzioni hanno maiuscole, underscore o spazi non ammessi.

---

7. **Domanda:** un tag `deleteAfter=2026-09-10` è stato applicato a una risorsa. Che cosa accade alla data indicata?<br>

   A. Azure elimina sempre automaticamente la risorsa  
   B. Il tag documenta l'intenzione, ma serve ancora una procedura o una policy che esegua l'eliminazione  
   C. La risorsa viene spostata in un'altra region  
   D. Il tag revoca tutte le autorizzazioni<br>

   **Risposta:** B<br>

   **Motivazione:** il tag descrive solo un'intenzione, serve una procedura o una policy che lo legga e agisca: l'eliminazione non è automatica.

---

8. **Domanda:** dopo `az group delete --no-wait`, quale controllo dimostra che il cleanup è realmente terminato?<br>

   A. Il terminale ha restituito il prompt  
   B. Il comando è presente nella history  
   C. `az group exists --name <NOME>` restituisce `false`  
   D. `git status` non mostra modifiche<br>

   **Risposta:** C<br>

   **Motivazione:** `az group exists` risponde `false` solo quando Azure conferma che il resource group non esiste più; il prompt che torna libero non lo garantisce, perché l'eliminazione è asincrona.

## Parte B — Risposte brevi

9. **Domanda:** spiega la differenza tra cloud pubblico, privato e ibrido usando un solo scenario aziendale.<br>

   **Risposta:** un'azienda tiene i dati sensibili sui propri server (privato) e il sito pubblico su Azure per i picchi di traffico (pubblico): i due comunicano tra loro, ed è questo a renderlo ibrido.

---

10. **Domanda:** descrivi la relazione fra tenant Microsoft Entra, sottoscrizione, resource group e risorsa.<br>

    **Risposta:** il tenant contiene le identità, la sottoscrizione (dentro il tenant) gestisce fatturazione e accesso, il resource group (dentro la sottoscrizione) raggruppa le risorse. Ogni risorsa appartiene a una sola sottoscrizione e un solo resource group.

---

11. **Domanda:** perché una availability zone non è sinonimo di region?<br>

    **Risposta:** la region è l'area geografica dove scelgo di far girare le risorse. L'availability zone è un gruppo di datacenter dentro la stessa region con alimentazione e rete indipendenti, per restare operativo se una zona si guasta.

---

12. **Domanda:** quale differenza operativa hai osservato tra Azure Portal e Azure CLI?<br>

    **Risposta:** un'azione nel portale non è ripetibile in automatico: due persone possono cliccare cose diverse senza accorgersene. Un comando CLI si può salvare e riusare, per questo ogni azione fatta da portale nei laboratori viene riverificata da riga di comando.

---

13. **Domanda:** perché i tag devono essere applicati esplicitamente anche alle risorse se sono già presenti sul resource group?<br>

    **Risposta:** perché i tag applicati al resource group non vengono ereditati automaticamente dalle risorse al suo interno: vanno impostati esplicitamente su ciascuna, altrimenti restano senza.

## Parte C — Interpretazione tecnica

Output anonimizzato osservato:

```json
{
  "id": "/subscriptions/<omitted>/resourceGroups/rg-cea-test/providers/Microsoft.Storage/storageAccounts/stceatest01",
  "location": "italynorth",
  "name": "stceatest01",
  "tags": {
    "environment": "lab",
    "unit": "UD02"
  },
  "type": "Microsoft.Storage/storageAccounts"
}
```

1. **Domanda:** sottoscrizione, resource group, provider, tipo e nome riconoscibili nell'ID.<br>

   **Risposta:** nell'ID si riconoscono, in ordine: la sottoscrizione (qui anonimizzata con `<omitted>`), il resource group `rg-cea-test`, il provider `Microsoft.Storage`, il tipo `storageAccounts` e il nome `stceatest01`.

---

2. **Domanda:** località e tag.<br>

   **Risposta:** località `italynorth`, tag `environment=lab` e `unit=UD02`.

---

3. **Domanda:** quale comando useresti per verificare che la risorsa appartenga realmente al resource group?<br>

   **Risposta:** `az storage account show --name stceatest01 --resource-group rg-cea-test`: se la risorsa appartiene davvero a quel resource group il comando restituisce i dettagli, altrimenti dà errore.

---

4. **Domanda:** quale operazione useresti per rimuovere l'intero ambiente se il resource group contiene soltanto risorse del laboratorio?<br>

   **Risposta:** `az group delete --name rg-cea-test --yes --no-wait`, che elimina il resource group e tutto quello che contiene in un solo comando.

---

5. **Domanda:** quale verifica eseguiresti dopo l'eliminazione?<br>

   **Risposta:** `az group exists --name rg-cea-test`, che deve rispondere `false`.
