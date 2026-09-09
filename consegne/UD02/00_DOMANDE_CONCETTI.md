# Consegna UD02 — Domande sui concetti

Per ciascuna domanda 1–8 riporta una risposta motivata.

1. **Domanda:** perché una macchina virtuale lascia al cliente più responsabilità operative rispetto ad App Service?<br>

   **Risposta:** con una VM (IaaS) Microsoft gestisce solo hardware e virtualizzazione: sistema operativo, aggiornamenti e software restano miei. Con App Service (PaaS) Microsoft gestisce anche sistema operativo e runtime, quindi mi occupo solo di codice e configurazione. La differenza sta lì: più livelli gestisce Microsoft, meno lavoro operativo resta a me, ma anche meno controllo diretto sul sistema.

---

2. **Domanda:** qual è la differenza tra tenant, sottoscrizione e resource group?<br>

   **Risposta:** il tenant contiene tutte le identità dell'organizzazione, cioè chi può accedere a cosa. Dentro il tenant c'è la sottoscrizione, che gestisce fatturazione, quote e accesso: un'organizzazione può averne più di una. Dentro la sottoscrizione c'è il resource group, che raggruppa risorse con lo stesso scopo: il mio, `rg-cea-ud02-e385bc0c`, contiene sia la VNet che lo storage account. Ogni risorsa sta sempre in una sola sottoscrizione e in un solo resource group.

---

3. **Domanda:** perché la località del resource group non obbliga tutte le risorse a usare la stessa region?<br>

   **Risposta:** la località del resource group indica solo dove Azure salva le informazioni sul contenitore stesso (i suoi metadati), non dove devono stare fisicamente le risorse al suo interno. Per questo potrei tecnicamente avere una risorsa in `italynorth` e un'altra in `westeurope` nello stesso resource group. Nel laboratorio ho usato comunque `italynorth` per tutto, per tenere il progetto semplice da seguire.

---

4. **Domanda:** quale differenza esiste tra una region e un'availability zone?<br>

   **Risposta:** la region è l'area geografica dove si trovano i datacenter, scelta in base a disponibilità del servizio, latenza e costo. L'availability zone è un gruppo di datacenter dentro la stessa region, con alimentazione e rete indipendenti tra loro: se una zona si guasta, le altre restano attive.

---

5. **Domanda:** perché `az account show` deve precedere la creazione di una risorsa?<br>

   **Risposta:** un comando di creazione esegue l'operazione nella sottoscrizione attiva in quel momento, senza controllare da solo se è quella giusta. Se non lo è, crea comunque una risorsa reale, ma nel posto sbagliato, magari con permessi o costi attribuiti a un progetto diverso. Controllare con `az account show` costa un secondo e evita un errore che altrimenti si scopre solo dopo.

---

6. **Domanda:** perché i tag non devono essere usati come meccanismo di sicurezza?<br>

   **Risposta:** i tag sono coppie chiave-valore leggibili e modificabili da chiunque abbia accesso alla risorsa, non sono un meccanismo di autorizzazione. Un tag serve per inventario, governance e analisi dei costi, ma non impedisce a nessuno di leggerlo o modificarlo. Per questo un tag non deve mai contenere dati sensibili.

---

7. **Domanda:** quale vantaggio offre Azure CLI rispetto alla sola operazione nel portale?<br>

   **Risposta:** un'azione fatta nel portale non è ripetibile in automatico: due persone possono cliccare cose leggermente diverse senza accorgersene. Un comando CLI invece si può salvare, riusare e mettere in uno script. Il portale è comodo per esplorare, la CLI per ripetere le cose in modo affidabile.

---

8. **Domanda:** perché l'esecuzione del comando di eliminazione non dimostra da sola che il cleanup sia concluso?<br>

   **Risposta:** `az group delete` avvia l'eliminazione ma non aspetta che finisca: il comando torna subito, Azure lavora dopo. Il cleanup è concluso solo quando controllo che la risorsa non esiste più, con `az group exists` che deve dire `false`. Senza quel controllo rischio di pensare finito un lavoro che sta ancora girando, con risorse ancora attive senza saperlo.
