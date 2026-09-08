# Consegna UD02 — Verifica

## Parte A — Scelte operative

Per le domande 1–8 riporta risposta e motivazione.

1. **Risposta:** B<br>
   **Motivazione:** serve controllo completo del sistema operativo per installare un componente non supportato da un servizio gestito, e questo lo offre solo IaaS.

2. **Risposta:** C<br>
   **Motivazione:** con App Service Microsoft gestisce hardware, virtualizzazione, sistema operativo e runtime; al cliente restano configurazione dell'app, identità, accessi e dati.

3. **Risposta:** C<br>
   **Motivazione:** il resource group è un contenitore logico, non un confine fisico, e raggruppa risorse che condividono ciclo di vita e governance.

4. **Risposta:** B<br>
   **Motivazione:** la località del resource group riguarda solo dove Azure salva i suoi metadati, non obbliga le risorse al suo interno alla stessa region.

5. **Risposta:** B<br>
   **Motivazione:** `az account show` conferma la sottoscrizione attiva prima di creare qualcosa, evitando di lavorare nel contesto sbagliato.

6. **Risposta:** C<br>
   **Motivazione:** `stcea02a7f9` usa solo lettere minuscole e numeri, il vincolo di naming per uno storage account; le altre opzioni hanno maiuscole, underscore o spazi non ammessi.

7. **Risposta:** B<br>
   **Motivazione:** il tag descrive solo un'intenzione, serve una procedura o una policy che lo legga e agisca: l'eliminazione non è automatica.

8. **Risposta:** C<br>
   **Motivazione:** `az group exists` risponde `false` solo quando Azure conferma che il resource group non esiste più; il prompt che torna libero non lo garantisce, perché l'eliminazione è asincrona.

## Parte B — Risposte brevi

9. Un'azienda tiene i dati sensibili sui propri server (privato) e il sito pubblico su Azure per i picchi di traffico (pubblico): i due comunicano tra loro, ed è questo a renderlo ibrido.

10. Il tenant contiene le identità, la sottoscrizione (dentro il tenant) gestisce fatturazione e accesso, il resource group (dentro la sottoscrizione) raggruppa le risorse. Ogni risorsa appartiene a una sola sottoscrizione e un solo resource group.

11. La region è l'area geografica dove scelgo di far girare le risorse. L'availability zone è un gruppo di datacenter dentro la stessa region con alimentazione e rete indipendenti, per restare operativo se una zona si guasta.

12. Un'azione nel portale non è ripetibile in automatico: due persone possono cliccare cose diverse senza accorgersene. Un comando CLI si può salvare e riusare, per questo ogni azione fatta da portale nei laboratori viene riverificata da riga di comando.

13. Perché i tag applicati al resource group non vengono ereditati automaticamente dalle risorse al suo interno: vanno impostati esplicitamente su ciascuna, altrimenti restano senza.

## Parte C — Interpretazione tecnica

1. Nell'ID si riconoscono, in ordine: la sottoscrizione (qui anonimizzata con `<omitted>`), il resource group `rg-cea-test`, il provider `Microsoft.Storage`, il tipo `storageAccounts` e il nome `stceatest01`.

2. Località `italynorth`, tag `environment=lab` e `unit=UD02`.

3. `az storage account show --name stceatest01 --resource-group rg-cea-test`: se la risorsa appartiene davvero a quel resource group il comando restituisce i dettagli, altrimenti dà errore.

4. `az group delete --name rg-cea-test --yes --no-wait`, che elimina il resource group e tutto quello che contiene in un solo comando.

5. `az group exists --name rg-cea-test`, che deve rispondere `false`.
