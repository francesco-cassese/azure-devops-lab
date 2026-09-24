# UD13 — Verifica

1. **Domanda:** Perché lo state locale non è ideale in un team?

    **Risposta:** Perché lo state sta sul computer di una persona: se due colleghi applicano modifiche nello stesso momento rischiano di sovrascriverlo e non si sa più quale sia quello giusto. In un team serve uno state remoto, con il locking che impedisce di usarlo in due contemporaneamente.

---

2. **Domanda:** Che differenza c'è tra stage, job e step?

    **Risposta:** Sono tre livelli, uno dentro l'altro. Lo stage è una fase (per esempio Validate o Deploy), il job è un insieme di step eseguito da un agent (per esempio ValidateIaC), lo step è una singola operazione, come un checkout, uno script o un task.

---

3. **Domanda:** Che cosa rappresenta `checkout: self`?

    **Risposta:** `checkout: self` dice alla pipeline di scaricare il repository che la contiene, e lo mette nell'area di lavoro dell'agent. Per questo nel YAML uso percorsi che partono dal repository, come `infra/terraform`.

---

4. **Domanda:** Perché la service connection è limitata a `rg-ud13-15-delivery`?

    **Risposta:** Perché una service connection deve avere solo i permessi che le servono, è il principio del minimo privilegio. Quella del lab, `sc-azure-ud13-15`, lavora soltanto su `rg-ud13-15-delivery` e non su tutta la subscription: se venisse compromessa, il danno resterebbe in quel Resource Group.

---

5. **Domanda:** Perché usiamo Workload Identity Federation?

    **Risposta:** Perché con la Workload Identity Federation non serve un client secret: Azure DevOps presenta a Microsoft Entra un'identità firmata e riceve un permesso di breve durata. Nella pipeline non c'è niente di duraturo da custodire o da rubare.

---

6. **Domanda:** Perché in pipeline Terraform viene validato ma non applicato?

    **Risposta:** Perché la pipeline Terraform si ferma a `fmt`, `init -backend=false` e `validate`: non fa `terraform apply`. Lo state remoto in UD13 è solo un concetto studiato, non configurato. A distribuire in modo automatico, per ora, è solo Bicep, che crea l'ACR.

---

7. **Domanda:** Quale risorsa deve sopravvivere a UD13 e perché?

    **Risposta:** L'ACR, che sta nel Resource Group `rg-ud13-15-delivery`. UD14 fa build e push dell'immagine nello stesso ACR e UD15 fa il pull con le Container Apps, quindi eliminarlo romperebbe la progressione.

---

8. **Domanda:** Se `az bicep lint` fallisce per un file inesistente, quale classe di problema stiamo diagnosticando?

    **Risposta:** Un problema di percorso, cioè di filesystem del repository: non riguarda Azure, il pool, l'Agent, l'autenticazione GitHub né la service connection. Nel lab il lint ha dato "Could not find file ... delivery-NON-ESISTE.bicep" perché quel file non esiste nella cartella del checkout.

---

9. **Domanda:** Perché la prima pipeline UD13 usa il self-hosted Agent?

    **Risposta:** Per vedere in pratica che Terraform, Azure CLI e Bicep usati dalla pipeline sono quelli installati sul mio WSL2: il job gira sull'Agent, non nel terminale che uso a mano.

---

10. **Domanda:** A che cosa serve `workspace: clean: all`?

    **Risposta:** Prima di ogni job svuota l'area di lavoro dell'agent. Un self-hosted tiene i file da un'esecuzione all'altra, e senza questa pulizia potrebbe passare una pipeline che funziona solo grazie a file rimasti da prima.

---

11. **Domanda:** Distingui la GitHub App dalla Azure Resource Manager service connection.

    **Risposta:** La GitHub App dà ad Azure Pipelines l'accesso al repository, per leggerlo con il checkout. La service connection `sc-azure-ud13-15` dà invece accesso alle risorse Azure tramite Workload Identity Federation. Sono due problemi di autenticazione diversi.

---

12. **Domanda:** Perché non usiamo `~/workspace/azure-devops-lab` dentro il YAML?

    **Risposta:** Perché quel percorso è la copia che uso io a mano, mentre la pipeline lavora sulla copia scaricata dall'agent con il checkout, in un'altra cartella. Nel YAML uso percorsi relativi al repository, come `infra/terraform`, oppure la variabile `$(Build.SourcesDirectory)`.

---

13. **Domanda:** Che cosa cambierà quando in UD14 useremo `vmImage: ubuntu-latest`?

    **Risposta:** Con `vmImage: ubuntu-latest` il job non girerebbe più sul mio WSL2 ma su una macchina virtuale nuova data da Azure Pipelines. La pipeline resta simile, ma ogni job parte da zero, mentre sul WSL2 file e tool restano.