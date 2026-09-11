# Consegna UD05 — Laboratorio autonomo

## Inventario iniziale

VNet `10.50.0.0/16` con due subnet: `snet-web` (`10.50.10.0/24`, nessun NSG associato) e `snet-data` (`10.50.20.0/24`, NSG `nsg-data-<suffisso>` associato). Due NIC: `nic-web-01` (IP privato `10.50.10.4`, nessun IP pubblico) su `snet-web`, `nic-data-01` (IP privato `10.50.20.4`, nessun IP pubblico) su `snet-data`. Sull'NSG una sola regola personalizzata, `Allow-Web-Postgres`, priorità 300, Allow, TCP, origine `10.50.10.0/24`, porta 5432.

## Guasto e diagnosi

- regola introdotta: `Deny-Web-Postgres-Auto`, priorità 250, Deny, TCP, stessa origine (`10.50.10.0/24`) e porta (5432) della regola Allow
- ordine di priorità osservato: 250 (Deny) valutata prima di 300 (Allow)
- sintomo: il flusso web→data sulla porta 5432 risulterebbe bloccato
- ipotesi: una regola con priorità più bassa nega lo stesso flusso che la regola corretta permette
- controllo: `az network nsg rule list` ordinato per priorità, per vedere quale regola corrisponde per prima
- correzione minima: rimossa solo `Deny-Web-Postgres-Auto`, lasciando intatta `Allow-Web-Postgres`
- verifica dopo la correzione: `az network nsg rule list` mostra di nuovo solo `Allow-Web-Postgres` a priorità 300

Senza una VM collegata alla NIC non è possibile un test IP Flow Verify completo: `az network nic list-effective-nsg` e `az network nic show-effective-route-table` danno errore (`NicMustBeAttachedToRunningVmToGetEffectiveSecurityGroups`/`...Routes`). Questo non impedisce però di individuare il conflitto: leggendo le regole scritte e la priorità si può dedurre dal numero che il `Deny` (250) vince sull'`Allow` (300), senza bisogno di traffico reale.

## Casi ulteriori

**`InvalidAddressPrefix`**
Livello: 3.
Controllo: confrontare il prefisso CIDR con quelli delle subnet già esistenti nella VNet.
Correzione minima: scegliere un prefisso che non si sovrapponga a nessuna subnet già presente.

**`SecurityRuleConflict`**
Livello: 4.
Controllo: vedere se un'altra regola nello stesso NSG ha già quella priorità.
Correzione minima: dare alla nuova regola un numero di priorità libero.

**Nome DNS non risolto**
Livello: 7.
Controllo: `nslookup <nome>`.
Correzione minima: controllare che il nome sia scritto giusto e che esista un record DNS per quello, oppure che il DNS server sia quello giusto.

**Porta filtrata da un NSG**
Livello: 4.
Controllo: `az network nsg rule list`, ordinando per priorità, per vedere quale regola corrisponde per prima al traffico.
Correzione minima: se una regola con priorità più bassa nega il traffico previsto, rimuovere o correggere solo quella regola, senza toccare quella corretta.

## Cleanup e risultato finale

- regola autonoma rimossa: sì, confermato con `az network nsg rule list`
- cleanup verificato: verificato con `az group exists`, che ha risposto `false`: il resource group e tutte le risorse (VNet, subnet, NSG, NIC) non esistono più
- hash abbreviato e messaggio del commit:

