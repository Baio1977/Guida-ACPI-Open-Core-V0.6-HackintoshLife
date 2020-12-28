# Patch ausiliaria per le informazioni sulla batteria

## Panoramica

- Il nuovo ***VirtualSMC.kext*** e i suoi componenti ***kext*** [dopo il 14 agosto] forniscono un'interfaccia per visualizzare le informazioni ausiliarie della batteria. Attraverso la patch SSDT personalizzata, il `PackLotCode`,` PCBLotCode`, `versione firmware`,` correzione hardware` e `correzione batteria` della batteria possono essere visualizzati sotto l'azione del driver.
- Questa patch proviene dalla patch ufficiale di ***VirtualSMC.kext*** con alcune modifiche
- Questa patch e la patch `battery` non hanno alcuna relazione master-slave. Non essenziale!
- Questa patch si applica a tutti i laptop

### Note sulla patch

- Nelle specifiche ACPI, `_BST` definisce alcune informazioni sulla batteria e la patch usa i metodi` CBIS` e `CBSS` per iniettare queste informazioni. Per i dettagli sulla definizione di `_BST`, fare riferimento alla specifica ACPI
- Nell'esempio non è stato possibile trovare l'applicazione pratica di `CBSS`, basta usare` Return (Buffer (Zero) {}) `. **Nota** Il contenuto `CBSS` non può essere eliminato
- Per poter lavorare su **macchine che non necessitano di una patch `battery`**, la patch di esempio aggiunge il metodo B1B2 sotto il percorso della batteria

### Esempio SSDT-BATS-PRO13

- `Battery` percorso: `_SB.PCI0.LPCB.H_EC.BAT1`

  Durante l'utilizzo, assicurarsi che il percorso della batteria dell'ACPI originale sia coerente con il percorso della batteria dell'esempio
- `CBIS`
  
  - Trova la variabile corrispondente in base al contenuto di `_BST`, e premi` low byte` e `high byte` per scrivere B1B2. Ad esempio: PKG1 [0x02] = B1B2 (`FUSL`,` FUSH`), se questa variabile è a doppio byte, fare riferimento al metodo di divisione dei dati della patch della batteria per dividere i dati e ridefinire i dati
  -Se non puoi confermare le variabili, puoi anche visualizzare le informazioni relative alla batteria [**Non verificato**] in Win o Linux e compilare direttamente. Ad esempio: `Versione firmware` è 123, impostare direttamente PKG1 [0x04] = B1B2 (0x23, 0x01)

-`CBSS`

  Il metodo di riempimento dei dati è lo stesso di `CBIS`. Se non è necessario inserire alcun contenuto, utilizzare `Return (Buffer (Zero) ())`
