# Patch speciale della macchina Dell

## Richiesta

-Controlla se i seguenti "Device" e "Method" esistono in ACPI e i nomi corrispondono, altrimenti ignora il contenuto di questo capitolo.
  - `Device` ：ECDV【PNP0C09】
  - `Device` ：LID0【PNP0C0D】
  - `Method` ：OSID
  - `Method` ：BTNV

## Rinomina speciale

PNLF renamed XNLF

```text
Find:     504E4C46
Replace:  584E4C46
```

C'è una variabile "PNLF" nel DSDT di alcune macchine Dell. Se "PNLF" e la patch di luminosità hanno lo stesso nome, potrebbero esserci dei conflitti. Usa il cambio di nome sopra per evitarlo.

## Patch speciale

- *** SSDT-OCWork-dell ***
  -La maggior parte delle macchine Dell ha un metodo `OSID`. Il metodo `OSID` include due variabili` ACOS` e `ACOS`, che determinano la modalità di lavoro della macchina. Ad esempio, solo quando `ACOS`> =` 0x20`, il metodo del tasto di scelta rapida della luminosità di ACPI funzionerà. Di seguito sono elencate le relazioni tra 2 variabili e modalità di lavoro. Per i dettagli sul metodo `OSID`, fare riferimento al` Metodo (OSID ... `di DSDT).
    -`ACOS`> = `0x20`, il tasto di scelta rapida della luminosità funziona
    -`ACOS` = `0x80`,` ACSE` = 0 è la modalità win7, in questa modalità, la luce del respiro lampeggia durante il sonno
    -`ACOS` = `0x80`,` ACSE` = 1 è la modalità win8, in questa modalità, la luce del respiro è spenta durante il sonno
  -Il contenuto specifico delle due variabili nel metodo `OSID` dipende dal sistema operativo stesso. È necessario utilizzare ** patch del sistema operativo ** o utilizzare ** questa patch ** nello stato mela nera per modificare queste due variabili per soddisfare requisiti specifici.

-Fissa la combinazione di patch di Fn + tasto funzione Inserisci
  
  - *** SSDT-PTSWAK *** Vedi "PTSWAK Comprehensive Extension Patch"
  - *** SSDT-EXT3-WakeScreen *** Vedi "PTSWAK Comprehensive Extension Patch"
  - *** SSDT-LIDpatch *** Vedere "Metodo di correzione del sonno PNP0C0E"
  - *** SSDT-FnInsert_BTNV-dell *** Vedere "Metodo di correzione del sonno PNP0C0E"
