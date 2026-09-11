# Consegna UD05 — Laboratorio guidato

## Piano di indirizzamento

| Elemento | CIDR | Scopo | Sovrapposizioni |
|---|---|---|---|
| VNet | `10.50.0.0/16` | spazio indirizzi del laboratorio | |
| subnet web | `10.50.10.0/24` | risorse web | dentro la VNet, non si sovrappone a data |
| subnet data | `10.50.20.0/24` | risorse dati | dentro la VNet, non si sovrappone a web |

## NSG e associazioni

| NSG | Scope associato | Regola | Priorità | Origine | Porta | Esito |
|---|---|---|---:|---|---|---|
| `nsg-data-<suffisso>` | subnet `snet-data` | `Allow-Web-Postgres` | 300 | `10.50.10.0/24` | `5432` TCP | Allow |

## Verifica effettiva

Seguendo la guida, ho creato due NIC: `nic-data-01` su `snet-data` (IP privato `10.50.20.4`, senza IP pubblico) e `nic-web-01` su `snet-web`. Poi sono andato a controllare che tutto fosse a posto: l'NSG era associato alla subnet `snet-data`, e la regola `Allow-Web-Postgres` aveva priorità, protocollo, sorgente e porta corretti.

Ho anche provato a rompere le cose creando una regola `Deny-Web-Postgres` con priorità più bassa (200, quindi valutata prima della 300), e ho verificato che avrebbe davvero bloccato il flusso. Poi ho tolto solo quella regola e ricontrollato che fosse rimasta solo quella giusta.

 Non sono riuscito a leggere le regole e le route effettive vere. Sia `list-effective-nsg` che `show-effective-route-table` danno errore, perché serve una NIC collegata a una VM accesa, e qui non c'è ancora nessuna VM.

Flusso previsto, non ancora testato:

```text
10.50.10.0/24:any → 10.50.20.0/24:5432 TCP
```

Ho verificato configurazione e regole effettive, non la connettività: arriverà in UD06.

## Costi e cleanup

Registra risorse create, possibili costi, eliminazione e verifica finale.

## Rilevanza professionale

**Domanda:** Spiega perché progettazione CIDR e controllo delle regole devono precedere il deployment dei workload.<br>

**Risposta:** Farei sempre così: progetterei prima il CIDR e controllerei le regole, come ho fatto in questo laboratorio prima di creare VNet e subnet, perché sistemarlo dopo, con risorse già in produzione, richiederebbe una migrazione.

