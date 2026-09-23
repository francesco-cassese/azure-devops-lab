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

## 31.
**Risposta:**

## 32.
**Risposta:**

## 33.
**Risposta:**

## 34.
**Risposta:**

## 35.
**Risposta:**

## 36.
**Risposta:**

## 37.
**Risposta:**

## 38.
**Risposta:**

## 39.
**Risposta:**

## 40.
**Risposta:**

## 41.
**Risposta:**

## 42.
**Risposta:**

