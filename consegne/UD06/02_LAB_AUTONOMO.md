# UD06 — Consegna laboratorio autonomo

## 1. Baseline

- VM: attiva, Nginx risponde
- Nginx: attivo
- HTTP: curl -I "http://$LAB_VM_IP" → 200 OK
- regola NSG: Allow-HTTP-MyIP, priorità 310

## 2–4. Guasto, diagnosi, ripristino

- regola introdotta: Deny-HTTP-Auto, priorità 200, TCP porta 80, stesso IP di sorgente, Deny
- sintomo: il curl esterno sulla porta 80 non risponde più, resta fermo senza errore
- ipotesi: problema di rete/NSG, non dell'applicazione
- controllo: IP Flow Verify dice Access denied, regola responsabile Deny-HTTP-Auto. Dentro la VM Nginx è attivo e curl localhost risponde 200 OK
- causa: Deny-HTTP-Auto ha priorità 200, più bassa di Allow-HTTP-MyIP che è a 310, quindi viene valutata prima e blocca tutto
- correzione minima: eliminata solo la regola Deny-HTTP-Auto, lasciate le altre com'erano
- verifica: curl -I "http://$LAB_VM_IP" → di nuovo 200 OK

## 5. Monitoring

Scelta una metrica tra Percentage CPU, Network In e Network Out.

- metrica: Percentage CPU
- intervallo: ultime 24 ore
- aggregazione: media
- deduzione: la CPU ha lavorato poco in queste ore, la VM non stava facendo niente di pesante
- cosa non posso dedurre: se c'è stato un picco breve, la media lo nasconde. E non capisco se il sito funzionasse davvero bene, la CPU misura solo il carico, non il servizio

## 6. VMSS Autoscale

Requisito dato: mantenere almeno 1 istanza, massimo 4, se la CPU media supera il 70% per 5 minuti aggiungere 1 istanza.

- min: 1
- default: 1
- max: 4
- metrica: Percentage CPU
- condizione: sopra il 70% di media per 5 minuti
- azione: aggiungi 1 istanza
- perché max=4: per non far crescere le istanze all'infinito durante un picco lungo, altrimenti il costo sale senza controllo

## 7. App Service scaling

- A (serve una singola istanza più potente): Scale up
- B (il numero di istanze deve aumentare quando la CPU supera una soglia definita): Azure Monitor Autoscale
- C (la piattaforma deve reagire da sola al traffico HTTP senza regole metriche esplicite, su un tier compatibile): Automatic Scaling
- D (per una demo voglio passare da 1 a 2 istanze a mano): Scale out manuale

## 8. Backup policy

Scenario scelto: una VM che gestisce le email aziendali.

- frequenza: ogni 4 ore
- orario: non serve un orario fisso, gira 6 volte al giorno visto che è ogni 4 ore
- retention: 1 anno
- motivazione: non posso perdere più di 4 ore di email in caso di guasto, e le email degli ordini servono anche mesi dopo per chiudere i conti di fine anno

## 9. HA / Backup / DR

- A (guasto di una singola istanza, il servizio deve continuare): High Availability, un'altra istanza continua a servire senza fermare il servizio
- B (cancellazione accidentale di dati, serve recuperare uno stato precedente): Backup, permette di recuperare uno stato salvato prima della perdita
- C (regione primaria indisponibile, il workload deve essere riattivato altrove): Disaster Recovery, permette di far ripartire il workload in un'altra regione

## 10. RPO / RTO

Requisito dato: perdita massima dati 15 minuti, servizio di nuovo operativo entro 60 minuti.

- RPO: 15 minuti
- RTO: 60 minuti
