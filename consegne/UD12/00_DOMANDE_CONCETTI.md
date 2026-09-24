# UD12 — Domande sui concetti

Rispondere dopo avere studiato `00_CONCETTI.md`. Non limitarsi a definizioni di una riga: quando possibile aggiungere un piccolo esempio.

1. **Domanda:** Quale problema risolve l'Infrastructure as Code rispetto a una configurazione esclusivamente manuale?

    **Risposta:** Ci permette di salvare tramite file testuali tutte le caratteristiche scelte per lo storage account creato, così se dobbiamo ripetere più volte questo passaggio non dobbiamo ricordarci a memoria ogni carattestica usata per poterle re-inserire ma le abbiamo tutte salvate in un unico posto. 

---

2. **Domanda:** Spiega con parole semplici la differenza tra approccio imperativo e dichiarativo.

    **Risposta:** Se sto usando un approccio imperativo, come abbiamo fatto fino all'UD11, dico proprio al programma quali azioni deve compiere, per esempio: "Crea questo Resource Group" o "Verifica quest'altro", mentre se uso l'approccio dichiarativo io descrivo dettagliatamente le caratteristiche che dovrà avere l'infrastruttura dell'app" e il programma in base a questo determina da solo le azioni da compiere.  

---

3. **Domanda:** Perché continuiamo a usare Azure CLI anche se introduciamo IaC?

    **Risposta:** Azure CLI non smette di servire con Bicep e Terraform, cambia uso: da creare risorse a mano, a controllarle dopo. Non basta il "Succeeded" o "Apply complete" dello strumento IaC, quello conferma solo che il comando è andato a buon fine, non che la risorsa è davvero come volevo. Per questo la interrogo con Azure CLI, indipendente da chi l'ha creata: per esempio l'ho fatto nel lab usando `az storage account show` dopo il deployment Bicep e dopo l'apply Terraform, per controllare regione, SKU, TLS e tag.

---

4. **Domanda:** Che cos'è Bicep?

    **Risposta:** Bicep è un linguaggio dichiarativo progettato per descrivere risorse Azure, possiamo pensarlo come un modo più leggibile e compatto per descrivere ciò che ARM dovrà distribuire.

---

5. **Domanda:** Bicep sostituisce Azure Resource Manager?

    **Risposta:** No, Bicep non sostituisce Azure Resource Manager (ARM). Bicep è solo un modo più semplice e pulito per scrivere la configurazione dell'infrastruttura che viene tradotto in un template ARM.
    Ma è sempre ARM che si occupa di applicarlo su Azure.

---

6. **Domanda:** Che cosa significa param location string?

    **Risposta:** Significa che sto dichiarando un parametro chiamato `location` che accetta un valore di tipo testuale.

---

7. **Domanda:** A cosa serve un parametro?

    **Risposta:** Un parametro serve a rendere il codice flessibile e riutilizzabile, permettendoci di passare valori personalizzati dall'esterno ogni volta che distribuiamo l'infrastruttura, senza dover modificare il codice sorgente.

---

8. **Domanda:** A cosa servono @minLength e @maxLength?

    **Risposta:** Sono vincoli sulla lunghezza. Nel lab, ad esempio, li avevamo impostati a 3 e 24 per il nome dello Storage Account (storageName), quindi il valore passato al parametro non poteva essere né più corto di 3 caratteri né più lungo di 24.

---

9. **Domanda:** Nella riga resource storage 'Microsoft.Storage/storageAccounts@2023-05-01', che cosa significa storage?

    **Risposta:** storage è l'etichetta che diamo noi a quella specifica risorsa all'interno del codice Bicep, utile per poterla richiamare facilmente più avanti. Non è il nome che avrà su Azure, ma un nome interno al file.

---

10. **Domanda:** Che cosa significa Microsoft.Storage/storageAccounts?

    **Risposta:** Significa che stiamo specificando ad Azure cosa vogliamo creare: la prima parte (Microsoft.Storage) indica a quale famiglia di servizi affidarci, mentre la seconda (storageAccounts) individua l'oggetto esatto che vogliamo costruire.

---

11. **Domanda:** Che cosa significa @2023-05-01?

    **Risposta:** È la versione dell'API del servizio di Azure: serve a indicare ad ARM quale specifica edizione delle regole e delle funzionalità utilizzare per quella risorsa, garantendo che il codice sia compatibile con gli aggiornamenti di Microsoft.

---

12. **Domanda:** È la data di creazione dello Storage Account?

    **Risposta:** No, non è la data di creazione dello Storage Account, ma rappresenta la versione dell'API (la versione del set di regole con cui Azure gestisce quel servizio in quella determinata data). Servirà sempre a garantire che ARM interpreti correttamente il codice.

---

13. **Domanda:** Qual è la differenza tra nome simbolico Bicep e nome reale Azure?

    **Risposta:** Il nome simbolico è solo un'etichetta interna che usiamo noi nel codice (come prima `storage`) per poter richiamare quella risorsa comodamente all'interno del file; il nome reale di Azure, invece, è quello vero e proprio che la risorsa avrà nel cloud ed è visibile nel portale.

---

14. **Domanda:** A cosa servono gli output Bicep?

    **Risposta:** Servono a restituire un valore dal deployment una volta che la distribuzione è completata, così da poterli leggere subito o usarli in altri sistemi.

---

15. **Domanda:** Che cosa fa `az bicep lint`?

    **Risposta:** Controlla il codice bicep prima del deploy ed individua eventuali errori, lo usiamo prima così evitiamo di perdere tempo con un deploy che fallirebbe.

---

16. **Domanda:** Che cosa fa What-If?

    **Risposta:** Chiede ad Azure Resource Manager di prevedere cosa cambierebbe applicando il deployment, confrontando le risorse che esistono già con quello che il template descrive. Restituisce un elenco delle operazioni previste, per esempio "Create" per una risorsa nuova, senza eseguire nulla di reale.

---

17. **Domanda:** What-If crea realmente le risorse?

    **Risposta:** No, non crea niente. Mostra solo la previsione di quello che succederebbe se eseguissi davvero il deployment con `az deployment group create`.

---

18. **Domanda:** Qual è la differenza tra What-If e deployment `create`?

    **Risposta:** What-If è solo un'anteprima, analizza il template e mostra le modifiche previste senza toccare Azure. `create` invece esegue il deployment sul serio e crea o modifica le risorse reali. Nel lab ho sempre lanciato What-If prima, per controllare che la previsione corrispondesse a quello che mi aspettavo, e solo dopo ho lanciato `create`.

---

19. **Domanda:** Perché Bicep non richiede un file equivalente a `terraform.tfstate`?

    **Risposta:** Perché con Bicep il deployment passa sempre attraverso Azure Resource Manager, che tiene lui lo stato reale delle risorse. Non serve un file locale che colleghi il codice alla risorsa, quella relazione la gestisce ARM stesso. Con Terraform invece serve un file separato, lo state, perché Terraform non fa parte di Azure e deve tenersi da solo quel collegamento.

---

20. **Domanda:** Che cos'è Terraform?

    **Risposta:** È uno strumento Infrastructure as Code dichiarativo come Bicep, ma a differenza di Bicep non nasce solo per Azure: può gestire più piattaforme diverse (Azure, AWS, GitHub, ecc.) grazie ai provider. Nel nostro caso usa il provider AzureRM per parlare con Azure.

---

21. **Domanda:** Perché Terraform usa provider?

    **Risposta:** Perché Terraform Core da solo non contiene la logica di tutte le piattaforme che può gestire. I provider sono come degli adattatori specializzati: senza il provider AzureRM, per esempio, Terraform non saprebbe come creare o leggere un Resource Group o uno Storage Account su Azure.

---

22. **Domanda:** Che ruolo ha AzureRM?

    **Risposta:** È il provider Terraform che sa parlare con Azure. Conosce i tipi di risorsa come `azurerm_resource_group` e `azurerm_storage_account`, e traduce quello che scrivo nei file `.tf` in richieste vere verso Azure Resource Manager.

---

23. **Domanda:** Che cosa contiene `versions.tf`?

    **Risposta:** Dichiara quali versioni servono per far funzionare la configurazione: la versione minima di Terraform richiesta (`required_version`) e quale provider serve con quale vincolo di versione, nel mio caso `hashicorp/azurerm` con `~> 5.4`.

---

24. **Domanda:** A cosa serve `providers.tf`?

    **Risposta:** Serve ad attivare e configurare il provider dichiarato in `versions.tf`. Nel mio file contiene solo `provider "azurerm" { features {} }`, e non ci scrivo nessuna password: le credenziali arrivano dall'ambiente in cui eseguo Terraform, non dal file.

---

25. **Domanda:** Perché credenziali e codice IaC devono restare separati?

    **Risposta:** Perché il codice `.tf` finisce nel repository Git, quindi nella cronologia dei commit, e un secret scritto lì dentro ci resterebbe per sempre anche se lo tolgo più avanti. Nel lab infatti ho passato il Subscription ID con una variabile d'ambiente (`ARM_SUBSCRIPTION_ID`), non scritto in nessun file `.tf`.

---

26. **Domanda:** Che cosa contiene `variables.tf`?

    **Risposta:** Dichiara i valori configurabili della configurazione, come `location` e `resource_group_name`, ognuno con un tipo e, se serve, un valore di default. `resource_group_name` per esempio ha come default `rg-ud12-tf`: se non passo un valore diverso, Terraform usa proprio quello.

---

27. **Domanda:** Che differenza c'è tra `azurerm_resource_group`, `lab`, `var.resource_group_name` e `rg-ud12-tf`?

    **Risposta:** `azurerm_resource_group` è il tipo di risorsa Terraform. `lab` è il nome logico che ho dato io a quella risorsa dentro il codice, serve solo per riferirmi ad essa nel file. `var.resource_group_name` è la variabile da cui prendo il valore del nome reale. `rg-ud12-tf` è il nome vero che vedo su Azure, cioè il valore che quella variabile contiene.

---

28. **Domanda:** Nella riga `resource "azurerm_resource_group" "lab"`, che cos'è `lab`?

    **Risposta:** È il nome logico interno che uso per riferirmi a questa risorsa dentro il codice Terraform, per esempio quando scrivo `azurerm_resource_group.lab.location` in un'altra risorsa. Non è il nome che il Resource Group avrà su Azure.

---

29. **Domanda:** Il Resource Group reale si chiamerà `lab`?

    **Risposta:** No, il nome reale arriva dalla riga `name = var.resource_group_name`, che nel mio caso vale `rg-ud12-tf`. `lab` resta solo un riferimento interno al codice, non compare da nessuna parte su Azure.

---

30. **Domanda:** Da dove arriva il nome reale `rg-ud12-tf`?

    **Risposta:** Dal valore di default della variabile `resource_group_name` in `variables.tf`. Se non passo un valore diverso al momento dell'esecuzione, Terraform usa proprio quel default per il campo `name` del Resource Group.

---

31. **Domanda:** Che cosa significa `azurerm_resource_group.lab.name`?

    **Risposta:** `azurerm_resource_group` indica il tipo di risorsa, `.lab` è il nome logico scelto nel codice Terraform per identificare quella risorsa, `.name` è l'attributo che restituisce il nome reale che ho dichiarato in `variables.tf` e che Azure userà davvero.

---

32. **Domanda:** Perché lo Storage Account usa `azurerm_resource_group.lab.name`?

    **Risposta:** Nel blocco dello Storage Account, `resource_group_name = azurerm_resource_group.lab.name` dice a Terraform di creare quella risorsa proprio dentro il Resource Group appena dichiarato.

---

33. **Domanda:**  Che cosa significa `azurerm_resource_group.lab.location`?

    **Risposta:** `azurerm_resource_group` indica il tipo di risorsa, `.lab` è il nome logico che abbiamo scelto all'interno del codice Terraform per identificare quella specifica risorsa. `.location` è l'attributo che restituisce la regione geografica (per esempio "italynorth") associata a quel gruppo di risorse.

---

34. **Domanda:** Perché Terraform può dedurre la dipendenza fra Resource Group e Storage Account?

    **Risposta:** Perché all'interno del blocco dello Storage Account facciamo riferimento esplicito a un attributo del Resource Group (tramite espressioni come `azurerm_resource_group.lab.name` o `.location`). Questo legame viene chiamato dipendenza implicita: Terraform legge il codice, capisce che lo Storage Account "ha bisogno" di quel dato per poter essere configurato, e crea automaticamente un ordine di esecuzione corretto (prima il Resource Group, poi lo Storage Account).

---

35. **Domanda:** A cosa serve la validazione di `storage_account_name`?

    **Risposta:** Prima di usare il valore, Terraform controlla che rispetti dei vincoli precisi: lunghezza tra 3 e 24 caratteri, solo lettere minuscole e numeri, tramite il blocco `validation` in `variables.tf`. Se scrivo un nome che non li rispetta, l'errore lo scopro subito con `terraform plan`, non a metà di un `apply` che fallisce su Azure per un nome non valido.

---

36. **Domanda:** A cosa servono gli output Terraform?

    **Risposta:** Servono a esporre valori utili delle risorse gestite dopo l'esecuzione, per esempio `resource_group_name` e `storage_account_name` nel mio `outputs.tf`. Li leggo con `terraform output` dopo l'apply, e in una pipeline futura potrebbero diventare l'input di una fase successiva, esattamente come gli output Bicep.

---

37. **Domanda:** Che cosa fa `terraform init`?

    **Risposta:** Prepara la directory di lavoro: legge quali provider servono, scarica AzureRM se non è già presente, e crea la cartella `.terraform/` e il file `.terraform.lock.hcl`. Non crea ancora nessuna risorsa su Azure, è solo il primo passo prima di poter usare `fmt`, `validate` e `plan`.

---

38. **Domanda:** Che differenza c'è tra `.terraform/` e `.terraform.lock.hcl`?

    **Risposta:** `.terraform/` è una cartella locale con il materiale scaricato da Terraform, i binari dei provider: è solo cache di lavoro, pesante e rigenerabile in qualsiasi momento con un nuovo `init`, per questo l'ho messa nel `.gitignore`. `.terraform.lock.hcl` invece registra le versioni esatte dei provider selezionate: è piccolo ed è informazione di progetto, va committato insieme al resto del codice.

---

39. **Domanda:** Che cosa fa `terraform fmt`?

    **Risposta:** Formatta i file `.tf` secondo lo stile standard di Terraform (indentazione, spaziatura), senza creare né modificare nessuna risorsa Azure. Con `terraform fmt -check` posso solo controllare se i file sono già formattati correttamente, senza cambiarli, utile anche dentro una pipeline CI.

---

40. **Domanda:** Che cosa fa `terraform validate`?

    **Risposta:** Controlla che la configurazione sia sintatticamente corretta e coerente al suo interno, per esempio che ogni riferimento a un'altra risorsa esista davvero nel codice. Non guarda cosa c'è realmente su Azure e non garantisce che l'apply andrà a buon fine, quello lo verifica solo `plan`.

---

41. **Domanda:** Che cosa fa `terraform plan`?

    **Risposta:** Confronta configurazione, state e ciò che il provider legge davvero da Azure, e calcola cosa dovrebbe creare, cambiare o distruggere per arrivare allo stato descritto nel codice, senza eseguire nulla per davvero. Nel primo plan del lab ho visto `Plan: 2 to add, 0 to change, 0 to destroy`, un Resource Group e uno Storage Account nuovi.

---

42. **Domanda:** Perché il piano va letto prima dell'apply?

    **Risposta:** Perché solo leggendolo scopro se Terraform vuole fare esattamente quello che mi aspetto, oppure qualcosa di diverso, come mi è successo quando un cambio di regione ha forzato la ricreazione del Resource Group insieme allo Storage Account. Applicare senza aver letto il piano significa scoprire le conseguenze solo dopo, quando magari una risorsa è già stata distrutta.

---

43. **Domanda:** Perché nel LAB salviamo il piano in `ud12.tfplan`?

    **Risposta:** Perché così l'apply successivo esegue esattamente le azioni già viste e controllate nel piano salvato, non un piano ricalcolato al momento. Se nel frattempo qualcosa fosse cambiato su Azure, `terraform apply ud12.tfplan` me lo segnalerebbe invece di applicare in silenzio un piano diverso da quello che ho controllato.

---

44. **Domanda:** Che cosa fa `terraform apply`?

    **Risposta:** Esegue per davvero le azioni previste dal piano: crea, modifica o distrugge le risorse su Azure. Nel lab l'ho sempre lanciato passando il file di piano già salvato (`terraform apply ud12.tfplan` o `ud12-change.tfplan`), mai senza argomenti, così sono sicuro di applicare esattamente quello che avevo già letto.

---

45. **Domanda:** Che cos'è lo state Terraform?

    **Risposta:** È il file (`terraform.tfstate` nel mio caso, locale) che mantiene il collegamento tra gli oggetti dichiarati nel codice, per esempio `azurerm_storage_account.lab`, e le risorse reali che Terraform sta gestendo su Azure, per esempio `stud12t90072691`. Senza lo state, alla prossima esecuzione Terraform non saprebbe più se quella risorsa esiste già o va creata da capo.

---

46. **Domanda:** Quale relazione mantiene lo state?

    **Risposta:** Mantiene la relazione tra l'oggetto dichiarato nel codice e la risorsa reale che Terraform sta gestendo su Azure, insieme a informazioni come id, proprietà e metadati di quella risorsa.

---

47. **Domanda:** Perché `terraform.tfstate` non va trattato come normale codice sorgente?

    **Risposta:** Perché non è solo testo che descrive un'intenzione, come i file `.tf`, è la fotografia delle risorse reali già create: contiene id, proprietà e a volte anche valori sensibili. Va protetto e gestito con attenzione, non versionato come un file di progetto qualsiasi.

---

48. **Domanda:** Che cosa mostra `terraform state list`?

    **Risposta:** Mostra l'elenco degli oggetti che la configurazione corrente sta gestendo tramite il proprio state, per esempio nel mio lab `azurerm_resource_group.lab` e `azurerm_storage_account.lab`.

---

49. **Domanda:** `terraform state list` mostra tutte le risorse della Subscription?

    **Risposta:** No. Mostra solo le risorse che questa specifica configurazione Terraform sta gestendo attraverso il suo state, non tutto quello che esiste nella subscription Azure, anche se ci fossero altre risorse create in altri modi.

---

50. **Domanda:** `terraform destroy` elimina anche i file `.tf`?

    **Risposta:** No, elimina solo le risorse Azure gestite dallo state. I file `main.tf`, `variables.tf`, `outputs.tf`, `providers.tf` e `versions.tf` restano nel repository.

---

51. **Domanda:** Qual è la differenza principale nel percorso Bicep→Azure rispetto a Terraform→Azure?

    **Risposta:** Con Bicep il percorso è `main.bicep → Azure Resource Manager → risorse`, e lo stato reale resta tutto dentro Azure, non devo gestire niente in locale. Con Terraform il percorso è `file .tf → Terraform → state → provider → risorse`, e serve un file di state locale che devo gestire io, perché Terraform non fa parte di Azure e deve tenersi da solo il collegamento con le risorse reali.

---

52. **Domanda:** In che cosa What-If e Plan sono simili?

    **Risposta:** Hanno lo stesso obiettivo: farmi vedere le modifiche previste prima di applicarle davvero, così posso controllare il cambiamento prima di renderlo reale invece di scoprirlo solo dopo.

---

53. **Domanda:** Perché non sono lo stesso meccanismo?

    **Risposta:** Perché What-If appartiene ad Azure Resource Manager e lavora confrontando il template con lo stato reale delle risorse su Azure, mentre `terraform plan` appartiene al modello Terraform e lavora insieme a configurazione, state locale e provider: due strumenti diversi, con un'architettura diversa dietro, anche se il risultato visibile sembra simile.

---

54. **Domanda:** In quale tipo di organizzazione Bicep può essere particolarmente naturale?

    **Risposta:** In un'azienda che lavora quasi interamente su Azure (Azure, Entra ID, Azure Resource Manager, Azure DevOps), perché Bicep è fortemente integrato in quell'ecosistema.

---

55. **Domanda:** In quale tipo di organizzazione Terraform può essere particolarmente naturale?

    **Risposta:** In un'azienda che usa più piattaforme diverse insieme, per esempio Azure, AWS, GitHub, Cloudflare, perché Terraform usa provider differenti mantenendo lo stesso modello di lavoro su tutte. Ha senso anche in un'azienda solo Azure che però ha già moduli, pipeline e competenze consolidate su Terraform.

---

56. **Domanda:** Perché non ha senso dire in assoluto che uno dei due è sempre migliore?

    **Risposta:** Perché la scelta giusta dipende dalle piattaforme, dagli standard e dalle competenze già presenti nell'organizzazione, non da una qualità  dello strumento. La domanda corretta non è "qual è il migliore" ma "quale è più adatto a questo contesto".

---

57. **Domanda:** Perché i file IaC devono rimanere nel repository?

    **Risposta:** Perché descrivono l'infrastruttura in modo ripetibile, tracciabile e revisionabile: posso confrontarli con `git diff`, sottoporli a Pull Request, versionarli e riusarli in futuro. Senza il codice nel repository perderei tutto questo e dovrei ricostruire l'infrastruttura solo dalla memoria di cosa avevo fatto.

---

58. **Domanda:** Le directory `infra/bicep/` e `infra/terraform/` verranno ricreate da zero in UD13?

    **Risposta:** No, restano quelle di UD12 e vengono estese con nuovi file: per esempio in UD13 mi aspetto un file in più come `network.tf` accanto a quelli già scritti in UD12, non una cartella nuova.

---

59. **Domanda:** Perché installare Terraform nel WSL2 è utile per le UD successive?

    **Risposta:** Perché il self-hosted Agent gira proprio dentro il mio WSL2, che è una macchina persistente: tutto quello che installo lì resta disponibile per l'Agent finché non lo rimuovo, quindi installare Terraform ora prepara concretamente le pipeline che lo useranno nelle prossime UD.

---

60. **Domanda:** Su quale componente vengono realmente eseguiti i comandi di una pipeline?

    **Risposta:** Sull'Agent, cioè sulla macchina che riceve il Job dalla pipeline ed esegue davvero i comandi con i programmi installati su di essa. Il percorso è Pipeline → Job → Agent → programma installato sull'Agent.

---

61. **Domanda:** Che cosa rappresenta il WSL2 del partecipante nel modello self-hosted?

    **Risposta:** Rappresenta un pezzetto di infrastruttura aziendale, non il mio PC personale: è la macchina che resta sempre accesa e configurata per l'Agent, collegata al pool `pool-ud09-wsl`. In un'azienda vera ci sarebbero più macchine così, dedicate solo a far girare le pipeline, non i computer di ogni sviluppatore.

---

62. **Domanda:** Qual è la differenza principale fra persistenza self-hosted e ambiente Microsoft-hosted?

    **Risposta:** Il self-hosted resta sempre la stessa macchina: quello che installo oggi (Terraform, Bicep, Docker) c'è ancora domani, ma tocca a me tenerlo aggiornato e sotto controllo. Il Microsoft-hosted invece mi dà una macchina nuova ad ogni Job, quindi non devo pensare a nessuna manutenzione, ma non posso dare per scontato niente di installato prima: deve procurarsi da sola gli strumenti che le servono.

---

63. **Domanda:** Perché eliminare le risorse Azure non significa eliminare il codice IaC?

    **Risposta:** Perché sono due cose con cicli di vita diversi: le risorse Azure del lab servono solo per esercitarmi e posso eliminarle quando non servono più, mentre il codice IaC nel repository ha un ciclo di vita molto più lungo, resta e viene riusato ed esteso nelle prossime UD. Distruggere le risorse senza toccare il codice è proprio il senso di avere l'infrastruttura descritta a parte invece che solo dentro al Portale.