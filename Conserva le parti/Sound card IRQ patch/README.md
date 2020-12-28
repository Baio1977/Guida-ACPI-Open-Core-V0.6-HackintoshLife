## Descrizione

- La scheda audio della prima macchina richiede parti **HPET** **`PNP0103`** Fornisci il numero di interrupt` 0` e `8`, altrimenti la scheda audio non funzionerà normalmente. Infatti, quasi tutte le macchine '**HPET** non fornisce alcun numero di interrupt. Normalmente, i numeri di interrupt `0` e` 8` sono occupati rispettivamente da **RTC** **`PNP0B00`**, **TIMR** **`PNP0100`**
- Per risolvere i problemi di cui sopra, è necessario correggere **HPET**, **RTC**, **TIMR** contemporaneamente.

## Principio della patch

- Disabilita le tre parti **HPET**, **RTC**, **TIMR**.
- Contraffazione di tre parti, ovvero: **HPE0**, **RTC0**, **TIM0**.
- Rimuovere e aggiungere `IRQNoFlags () {8}` di **RTC0** e `IRQNoFlags () {0}` di **TIM0** a **HPE0**.

## Metodo patch

- Disabilita **HPET**, **RTC**, **TIMR**
  - **HPET**
  
    Di solito HPET ha `_STA`, quindi, per disabilitare HPET, è necessario utilizzare il` metodo della variabile preimpostata `. Ad esempio:
  
    `` Rapido
    Esterno (HPAE, IntObj) / * o Esterno (HPTE, IntObj) * /
    Scopo (\)
    {
        Se (_OSI ("Darwin"))
        {
            HPAE = 0 / * o HPTE = 0 * /
        }
    }
    `` `
  
    Nota: la variabile randomizer di `HPAE` in `_STA` potrebbe essere diversa.
  
  - **RTC**
  
    L'RTC delle prime macchine non aveva `_STA`, premere `Method (_STA,` per disabilitare RTC. Ad esempio:
  
    `` Rapido
    Metodo (_STA, 0, NotSerialized)
    {
        Se (_OSI ("Darwin"))
        {
            Ritorno (0)
        }
        Altro
        {
            Ritorno (0x0F)
        }
    }
    `` `
  
  - **TIMR**
  
    Uguale a **RTC**
  
- File di patch: ***SSDT-HPET_RTC_TIMR-fix***

  Vedere il **principio della patch** sopra, fare riferimento all'esempio.
  
  **Carica massima**
  
  Sebbene la prima piattaforma (il terminale mobile di generazione Intel 3 Ivy Bridge è la più comune), c'è un problema comune di "IRQ", che causa il mancato funzionamento della scheda audio integrata. La prestazione è che `AppleHDA.kext` non può essere caricato e viene caricato solo` AppleHDAController.kext`. Alcune macchine sulla piattaforma hanno ancora questo problema. Poiché HPET è un dispositivo obsoleto della piattaforma Intel di sesta generazione, è riservato per la compatibilità con le versioni precedenti del sistema. Se si utilizza la piattaforma di sesta generazione o superiore e la versione del sistema Windows 8.1 + HPET (High Precision Event in Device Manager) Timer) è già nello stato di unità non caricata
  Nella versione macOS 10.12 +, se questo problema si verifica sulla piattaforma hardware di sesta generazione +, è possibile bloccare direttamente HPET per risolvere il problema. Fare riferimento alle impostazioni specifiche del metodo HPET `_STA` nel DSDT originale.
    
## Precauzioni

- Questa patch non può essere utilizzata contemporaneamente alle seguenti patch:
  - ***SSDT-RTC_Y-AWAC_N*** di `Rinomina binaria e variabili preimpostate`
  - OC ufficiale ***SSDT-AWAC***
  - "Dispositivo contraffatto" o OC ufficiale ***SSDT-RTC0***
  - ***SSDT-RTC0-NoFlags*** di `CMOS Reset Patch`
-`LPCB` nome, **tre parti** nome e `IPIC` dovrebbero essere lo stesso del nome originale della parte` ACPI`.
- Se la patch tre in uno non può essere risolta, prova ***SSDT-IPIC*** con la premessa di utilizzare la patch tre in uno. Segui il metodo sopra per disabilitare ***HPET***, ***RTC*** e ***TIMR*** per disabilitare il dispositivo ***IPIC***, quindi falsificare un ***IPI0*** dispositivo, Il contenuto del dispositivo è il contenuto del dispositivo ***IPIC*** o ***PIC*** nel `DSDT` originale, e infine elimina `IRQNoFlags {2}`, fare riferimento all'esempio.
