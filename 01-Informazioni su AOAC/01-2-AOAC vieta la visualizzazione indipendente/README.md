# AOAC vieta la visualizzazione indipendente

## Descrizione

-Per notebook con tecnologia "AOAC", si consiglia di disabilitare il display indipendente per estendere il tempo di standby della macchina.
-Il metodo patch in questo articolo è applicabile solo alle macchine che hanno adottato la tecnologia "AOAC".

## Esempio di patch `SSDT`

-Patch 1: *** SSDT-NDGP_OFF-AOAC ***
  -Query il nome e il percorso del display univoco e confermare l'esistenza dei metodi `_ON` e` _OFF`
  -Fare riferimento all'esempio, modificare il nome e il percorso in modo che siano coerenti con il risultato della query
-Patch 2: *** SSDT-NDGP_PS3-AOAC ***
  -Query il nome e il percorso del display indipendente e confermare l'esistenza dei metodi `_PS0`,` _PS3` e `_DSM`
  -Fare riferimento all'esempio, modificare il nome e il percorso in modo che siano coerenti con il risultato della query
-**Attenzione**
  -Quando si interroga il nome e il percorso univoci, `_ON`,` _OFF`, `_PS0`,` _PS3` e `_DSM`, devono essere cercati tutti i file` ACPI`. Potrebbe esistere nel file `DSDT` o potrebbe Esiste in altri file `SSDT` di` ACPI`.
  -I 2 esempi precedenti sono patch personalizzate per Xiaoxin PRO13, scegline una da utilizzare. Il nome e il percorso univoci sono: `_SB.PCI0.RP13.PXSX`.

## Nota

-Se entrambi *** SSDT-NDGP_OFF ​​*** e *** SSDT-NDGP_PS3 *** soddisfano i requisiti di utilizzo, utilizzare prima *** SSDT-NDGP_OFF ​​***
-Per il metodo dettagliato di schermatura del display indipendente, fare riferimento a "Metodo di visualizzazione indipendente della schermatura SSDT"
