# Quiz Ripasso fondamenti di rete 

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

---

# Checklist pre-laboratorio 

**Domanda 1**

Qual è la differenza tra switch e router?

**Risposta**

Lo switch lavora dentro la stessa rete locale: guarda i MAC del traffico che passa e impara da quale porta si raggiunge ogni dispositivo, poi manda i dati solo su quella porta. Il router invece collega reti diverse tra loro, usa gli IP per decidere dove mandare i pacchetti da una rete all'altra.

---

**Domanda 2**

Qual è la differenza tra MAC e IP?

**Risposta**

Il MAC è fisso, lo dà il produttore sulla scheda di rete, e lavora a livello 2 dentro la LAN. L'IP invece può cambiare (lo riassegna il DHCP o cambia se cambi rete), e lavora a livello 3 tra reti diverse.

---

**Domanda 3**

Che cosa significa `/24`?

**Risposta**

`/24` significa che la subnet mask è `255.255.255.0`, cioè 24 bit fissi per la rete e 8 bit liberi per gli host. Con 8 bit liberi si ottengono `2^8 = 256` indirizzi totali in quella rete.

---

**Domanda 4**

Che cos'è il default gateway?

**Risposta**

Il default gateway è il router dove il PC manda il traffico quando la destinazione non è nella sua rete. Se invece è nella stessa rete, il traffico resta in LAN.

---

**Domanda 5**

A cosa serve DHCP?

**Risposta**

DHCP serve ad assegnare automaticamente IP, mask, gateway e DNS a un dispositivo che si collega alla rete, senza doverli configurare a mano su ogni host.

---

**Domanda 6**

A cosa serve DNS?

**Risposta**

DNS traduce i nomi in indirizzi IP. Gli utenti lavorano con i nomi, i computer comunicano con gli indirizzi IP, DNS fa da ponte tra i due.

---

**Domanda 7**

Qual è la differenza tra TCP e UDP?

**Risposta**

**TCP**: controlla che i dati arrivino tutti e nell'ordine giusto, lo usano HTTPS e SSH.

**UDP**: più semplice e veloce, ma senza questo controllo, lo usano DNS e lo streaming, dove perdere qualche pacchetto non è un problema.

---

**Domanda 8**

Che cos'è una porta?

**Risposta**

La porta indica quale servizio, su un host, deve ricevere i dati. L'IP dice a quale computer arrivare (l'host, es. il PC che ospita il sito), la porta dice a quale servizio su quel computer (es. il server web in ascolto), tipo `192.168.1.50:443`.

---

**Domanda 9**

Che cosa fa una route?

**Risposta**

Una route decide il percorso che un pacchetto deve fare per arrivare a destinazione, associando un prefisso di destinazione a un next hop (il passo successivo).

---

**Domanda 10**

Che cosa fa un firewall?

**Risposta**

Un firewall decide quali flussi di traffico sono ammessi, a diversi livelli: L3 (IP), L4 (porte/TCP-UDP), L7 (applicazione/protocollo).

---

**Domanda 11**

Che cos'è una VLAN?

**Risposta**

Una VLAN divide una LAN Ethernet in più reti logiche separate, anche sullo stesso switch fisico. Due porte in VLAN diverse non si vedono tra loro, serve un router per farle comunicare.

---

**Domanda 12**

Perché VLAN e VNet non sono la stessa cosa?

**Risposta**

Perché sono cose diverse. La VLAN è una tecnologia Layer 2, lavora con switch fisici. La VNet di Azure è una rete IP gestita da Azure via software, con le sue subnet e regole: non è la VLAN portata nel cloud, è un livello diverso.

---

**Domanda 13**

Che cosa fa NAT?

**Risposta**

NAT (Network Address Translation) traduce gli indirizzi privati in un indirizzo pubblico condiviso quando il traffico esce verso Internet, così più dispositivi privati possono usare lo stesso IP pubblico.

---

**Domanda 14**

Che cosa rappresenta una DMZ?

**Risposta**

Una DMZ è un segmento di rete separato, dove metti i sistemi più esposti (es. un web server pubblico), lontano dalla rete interna con client e database. Serve a limitare i danni se il sistema esposto viene attaccato.

---

**Domanda 15**

Qual è lo scopo di una VPN?

**Risposta**

Una VPN crea un tunnel cifrato attraverso una rete non fidata (Internet). Site-to-Site collega due reti intere tra loro. Point-to-Site collega un singolo client (es. un laptop) a una rete aziendale.

---

**Domanda 16**

Che informazioni fornisce `ipconfig /all`?

**Risposta**

`ipconfig /all` mostra la configurazione di rete completa del PC: indirizzo IPv4, subnet mask, default gateway, se DHCP è attivo, quale server DNS usa, e l'indirizzo MAC della scheda di rete.

---

**Domanda 17**

Che cosa verifica `nslookup`?

**Risposta**

`nslookup <nome>` verifica se la risoluzione DNS funziona, cioè se un nome viene tradotto in un IP. Si può anche interrogare un resolver specifico, es. `nslookup <nome> 8.8.8.8`, per confrontare risultati diversi.

---

**Domanda 18**

Perché un DNS funzionante non garantisce la connettività applicativa?

**Risposta**

Perché DNS traduce solo il nome in un IP, non controlla se il servizio dietro funziona. Restano da controllare: routing, firewall/NSG, la porta giusta, e se il servizio è davvero in ascolto.
