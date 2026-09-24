# UD13 — Domande concetti

1. **Domanda:** Perché lo state locale è accettabile in UD12 ma problematico in un team?

    **Risposta:** In UD12 lavoravo da solo e le risorse erano temporanee, quindi lo state sul mio computer bastava. In un team invece è un problema: se lo state sta su un solo computer e due colleghi applicano modifiche nello stesso momento, rischiano di sovrascriverlo e non si sa più quale state sia quello giusto. Per questo in un team si usa uno state remoto, con un blocco (il locking) che impedisce di usarlo in due contemporaneamente.

---

2. **Domanda:** A che cosa serve un backend remoto?

    **Risposta:** Serve a tenere lo state in un posto condiviso da tutto il team, per esempio su Azure Storage, invece che sul computer di una persona. In questo modo tutti usano lo stesso state e il blocco evita modifiche contemporanee. In UD13 l'abbiamo solo studiato: nella pipeline uso `init -backend=false`, quindi non lo configuro.

---

3. **Domanda:** Distingui stage, job e step.

    **Risposta:** Sono i livelli di una pipeline, uno dentro l'altro. Lo stage è una fase, per esempio Validate o Deploy. Dentro lo stage ci sono i job: un job è un gruppo di step che viene eseguito da un agent (nel lab, ValidateIaC). Lo step è la singola operazione, per esempio il checkout o uno script.

---

4. **Domanda:** Che cosa significa `checkout: self`?

    **Risposta:** Significa "recupera il repository che contiene la pipeline". Il repository viene messo nell'area di lavoro dell'agent, e per questo nei comandi della pipeline uso percorsi che partono dal repository, come `infra/terraform` e `infra/bicep`.

---

5. **Domanda:** Perché una pipeline self-hosted non deve assumere di trovarsi in `~/workspace/...`?

    **Risposta:** Perché quel percorso esiste solo sul mio computer, mentre la pipeline gira su un agent che potrebbe essere un'altra macchina, dove quella cartella non c'è. Un self-hosted poi non si azzera ogni volta come le macchine del cloud, e mi possono restare file vecchi che nascondono gli errori. Quindi dopo il checkout uso i percorsi del repository e le variabili della pipeline, come `$(Build.SourcesDirectory)`.

---

6. **Domanda:** A che cosa serve una service connection?

    **Risposta:** Serve alla pipeline per entrare in Azure senza usare il mio account personale. È come un'identità della pipeline, con permessi solo su quello che le serve. Nel lab ho creato `sc-azure-ud13-15`, senza client secret (Workload Identity Federation) e limitata al Resource Group `rg-ud13-15-delivery`, e la usa lo stage Deploy per creare l'ACR.

---

7. **Domanda:** Perché preferire Workload Identity Federation a un client secret?

    **Risposta:** Perché un client secret è come una chiave fisica: qualcuno la deve custodire, sostituire prima che scada e può essere rubata. Con la Workload Identity Federation invece Azure DevOps presenta a Microsoft Entra un'identità firmata, Entra la verifica e rilascia un permesso di breve durata. Così nella pipeline non c'è nessun secret da rubare.

---

8. **Domanda:** Perché limitiamo la service connection a un Resource Group?

    **Risposta:** Perché una service connection non deve avere più permessi del necessario, è il principio del minimo privilegio. Nel lab `sc-azure-ud13-15` può operare solo su `rg-ud13-15-delivery` e non sull'intera subscription, quindi se venisse compromessa il danno resterebbe dentro quel Resource Group.

---

9. **Domanda:** Perché Terraform viene validato ma non applicato dalla pipeline UD13?

    **Risposta:** Perché in UD13 la pipeline Terraform fa solo `fmt`, `init -backend=false` e `validate`, e non fa `terraform apply`. Lo state remoto in questa unità lo abbiamo solo studiato, non configurato. Il primo deployment automatico è quello di Bicep, che crea l'ACR.

---

10. **Domanda:** Perché l'ACR creato in UD13 non deve essere eliminato?

    **Risposta:** Perché UD14 fa build e push dell'immagine nello stesso ACR e UD15 fa il pull con le Container Apps. Eliminarlo dopo UD13 romperebbe la progressione: il Resource Group è un ambiente di delivery condiviso tra le tre unità.

---

11. **Domanda:** A che cosa serve `trigger: none`?

    **Risposta:** Serve a evitare che la pipeline parta da sola a ogni push. Nel lab l'ho usato perché volevo prima capirla e lanciarla a mano. In UD14 la CI verrà invece collegata a `main`.

---

12. **Domanda:** Qual è un ordine razionale per diagnosticare una pipeline che non parte correttamente?

    **Risposta:** Parto dall'alto e scendo: prima controllo se la pipeline è partita, poi se il job ha trovato un agent, se il checkout è riuscito, se il percorso è corretto, se il tool è disponibile, se la service connection è autorizzata e infine se i permessi Azure bastano. Così non cambio configurazioni a caso e non confondo un errore dell'agent con uno di Azure.

---

13. **Domanda:** Perché l'ACR UD13–UD15 fissa esplicitamente `LegacyRegistryPermissions`?

    **Risposta:** Perché così UD14 e UD15 usano i ruoli classici `AcrPull` e `AcrPush` e non dipendono da un valore predefinito del servizio che potrebbe cambiare.

---

14. **Domanda:** Perché UD13 usa deliberatamente il self-hosted Agent come prima pipeline?

    **Risposta:** Perché vogliamo vedere concretamente che i comandi della pipeline (Terraform, Azure CLI, Bicep) girano sul mio WSL2, cioè sull'Agent, e non nel mio terminale.

---

15. **Domanda:** A che cosa serve `workspace: clean: all` su un self-hosted Agent?

    **Risposta:** Chiede all'agent di pulire l'intera area di lavoro prima del job. Serve perché il self-hosted conserva i file, e senza pulizia la pipeline potrebbe sembrare corretta solo perché trova file rimasti da prima.

---

16. **Domanda:** Distingui `workspace: clean: all` e `checkout: self, clean: true`.

    **Risposta:** `workspace: clean: all` pulisce l'intera area di lavoro del job sull'agent. `checkout: self, clean: true` pulisce soltanto la copia Git del repository prima di scaricarlo di nuovo.

---

17. **Domanda:** Perché la pipeline non deve usare percorsi come `~/workspace/azure-devops-lab`?

    **Risposta:** Perché quel percorso è la copia che uso io a mano sul mio computer, mentre la pipeline lavora su una copia scaricata dall'Agent con il checkout, in un'altra cartella. Per questo nella pipeline uso percorsi che partono dal repository, come infra/terraform, oppure la variabile $(Build.SourcesDirectory), che contiene il percorso vero di quella copia.

---

18. **Domanda:** Che cosa cambierebbe passando da `pool-ud09-wsl` a `vmImage: ubuntu-latest`?

    **Risposta:** Cambierebbe dove gira il job: al posto del mio WSL2, Azure Pipelines darebbe al job una macchina virtuale nuova. I passaggi resterebbero gli stessi (checkout, Terraform, Bicep, Azure), ma ogni job partirebbe da zero, mentre sul mio WSL2 file e tool restano dopo ogni esecuzione.

---

19. **Domanda:** Perché la prima pipeline GitHub usa la Azure Pipelines GitHub App invece di creare un PAT manuale?

    **Risposta:** Perché la GitHub App non usa il mio account personale, come farebbero un PAT o l'OAuth. Nel lab l'ho installata solo sul repository del corso, così la pipeline può leggere quel repository e nient'altro.

---

20. **Domanda:** In produzione, che cosa rappresenterebbe `pool-ud09-wsl` rispetto a un vero Agent Pool aziendale?

    **Risposta:** Nel lab pool-ud09-wsl ha un solo Agent, il mio WSL2. In produzione sarebbe un insieme di macchine condivise dall'azienda (per esempio build-agent-01, 02 e 03), e il YAML indicherebbe il gruppo e non un computer preciso. Il mio WSL2 fa quindi da uno dei nodi del pool.

---

21. **Domanda:**  Perché un Pool con tre Agent non garantisce da solo tre Job paralleli?

    **Risposta:** Ogni agent esegue un job alla volta, quindi con tre agent potrei avere tre job insieme. Ma il parallelismo reale dipende anche dai Parallel Jobs dell'organizzazione, quindi avere tre agent non basta da solo a garantirlo.