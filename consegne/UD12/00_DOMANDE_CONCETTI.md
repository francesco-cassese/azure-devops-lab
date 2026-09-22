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

## 16.
**Risposta:**

## 17.
**Risposta:**

## 18.
**Risposta:**

## 19.
**Risposta:**

## 20.
**Risposta:**

## 21.
**Risposta:**

## 22.
**Risposta:**

## 23.
**Risposta:**

## 24.
**Risposta:**

## 25.
**Risposta:**

## 26.
**Risposta:**

## 27.
**Risposta:**

## 28.
**Risposta:**

## 29.
**Risposta:**

## 30.
**Risposta:**

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

