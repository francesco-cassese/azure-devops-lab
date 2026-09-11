# Esercizi svolti — Ripasso fondamenti di rete 

## Esercizio 1

```text
255.255.255.0
```

Che CIDR è questa mask?

### Risposta

```text
/24
```

Tre dei quattro numeri sono `255`, quindi pieni (8 bit ciascuno, 24 in totale), l'ultimo è `0` e non aggiunge niente.

---

## Esercizio 2

```text
255.255.0.0
```

Che CIDR è questa mask?

### Risposta

```text
/16
```

Qui i numeri pieni sono solo due, quindi 16 bit in tutto.

---

## Esercizio 3

```text
IP:   192.168.1.25
Mask: 255.255.255.0
```

A quale rete appartiene questo PC, in notazione CIDR?

### Risposta

```text
192.168.1.0/24
```

Con una mask `/24` i primi tre numeri dell'IP restano fissi e diventano la rete, l'ultimo si azzera.

---

## Esercizio 4

```text
PC1: 10.5.3.40/24
PC2: 10.5.4.10/24
```

Questi due PC sono nella stessa rete?

### Risposta

No. Calcolando la rete di ciascuno viene fuori `10.5.3.0/24` per il primo e `10.5.4.0/24` per il secondo: il terzo numero cambia, quindi sono due reti diverse e non possono parlarsi direttamente, serve un router in mezzo.

---

## Esercizio 5

```text
IPv4 Address: 169.254.45.17
```

Cosa significa, e cosa si controlla prima di toccare la configurazione IP a mano?

### Risposta

Vuol dire che il DHCP non ha risposto, o c'è un problema di collegamento alla rete. Prima controllo il collegamento e il DHCP, non tocco subito IP o gateway.

---

## Esercizio 6

```text
> nslookup www.microsoft.com
Address: 20.x.x.x
```

Si può concludere che il sito HTTPS funziona?

### Risposta

No, si può solo dire che la risoluzione del nome ha funzionato. Il servizio vero e proprio dietro quell'IP potrebbe comunque non rispondere, per esempio se la porta è chiusa o il servizio è fermo: sono cose che bisogna controllare separatamente, DNS che funziona non basta.

---

## Esercizio 7

```text
Rete prevista:    192.168.1.0/24
Gateway corretto: 192.168.1.1

PC:
  IP:      192.168.10.25
  Mask:    255.255.255.0
  Gateway: 192.168.1.1
```

Qual è l'anomalia?

### Risposta

Il PC e il gateway non sono nella stessa rete, il terzo numero è diverso (`10` è diverso da `1`). Quindi il PC non riesce a uscire verso l'esterno, il gateway che ha non è nella sua rete.
