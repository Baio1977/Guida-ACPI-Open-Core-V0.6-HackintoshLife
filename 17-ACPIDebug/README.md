# Descrizione ACPIDebug

## Descrizione

Aggiungendo il codice di debug alla patch *** SSDT-xxxx ***, è possibile vedere la patch o il processo di lavoro ACPI sulla console per il debug della patch.

## Richiesta

-Guidare
  -Installa *** ACPIDebug.kext *** in `OC \ Kexts` e aggiungi l'elenco dei driver.
-Patch
  -Aggiungere la patch principale *** SSDT-RMDT *** a `OC \ ACPI` e aggiungere l'elenco delle patch.
  -Aggiungere *** patch personalizzata *** a `OC \ ACPI` e aggiungere l'elenco delle patch.

## Debug

-Apri la ** Console ** e cerca ** `Keyword` ** (**` Keyword` ** da *** Patch personalizzate ***)
-Osservare l'output della console

## Esempio

-Scopo

  -Osserva come `_PTS` e` _WAK` di `ACPI` ricevono` Arg0` dopo che la macchina è in stato di stop e si sveglia.

-Driver e patch

  - *** ACPIDebug.kext *** - vedi sopra

  - *** SSDT-RMDT *** - vedi sopra

  - *** SSDT-PTSWAK *** —— La patch ha variabili di trasferimento dei parametri incorporate `\ _SB.PCI9.TPTS`,` \ _SB.PCI9.TWAK` per facilitare l'uso di altre patch. Vedi "PTSWAK Comprehensive Extension Patch"

  - *** SSDT-BKeyQxx-Debug *** - Questa patch è solo un esempio. Il codice di debug è stato aggiunto alla patch e il codice di debug può essere eseguito dopo aver risposto alla chiave. Nell'uso effettivo, è possibile assegnare tasti di scelta rapida della luminosità o altri tasti.

    ** Nota **: la modifica del nome richiesta dalla patch precedente si trova nel commento del file della patch corrispondente.

-Osservare l'output della console

  -Apri la console e cerca "ABCD-"

  -Completa un processo di sonno e risveglio

  -Premere il tasto specificato da *** SSDT-BKeyQxx-Debug *** e osservare l'output della console. In circostanze normali, i risultati di visualizzazione sono i seguenti:

    `` log
    13: 19: 50.542733 + 0800 kernel ACPIDebug: {"ABCD-_PTS-Arg0 =", 0x3,}
    13: 19: 55.541826 + 0800 kernel ACPIDebug: {"ABCD-_WAK-Arg0 =", 0x3,}
    `` `

    Il risultato del display sopra è il valore di "Arg0" dopo l'ultimo sonno e risveglio.

## Osservazioni

-Il codice di debug può essere diversificato, ad esempio: `\ RMDT.P1`,` \ RMDT.P2`, `\ RMDT.P3`, ecc., Vedere *** SSDT-RMDT.dsl *** per i dettagli
-I driver e le patch principali di cui sopra provengono da [@RehabMan] (https://github.com/rehabman)
