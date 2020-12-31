# Panoramica

## ACPI Rinomina e Patch

- Il metodo di rinominazione non è raccomandato, cercare di evitarlo, ad esempio `HDAS rinomina HDEF` , `EC0 rinomina EC` , `SSDT-OC-XOSI`. Una speciale **cauzione** per coloro che rinominano `MethodObj` (ad esempio _STA、 _OSI).
- In generale:
  - La patch del sistema operativo non è necessaria. Se i componenti sono limitati da uno specifico OS, si prega di modificare la patch ACPI di conseguenza. **Attenzione** per la `Patch OS`.

  - La patch di luminosità dei tasti della tastiera non è necessaria per alcune macchine. Si applica invece la `PS2 Keyboard Mapping & Brightness Function`.

  - Finora, la stragrande maggioranza delle macchine risolve la `scia istantanea` attraverso la `patch 0D6D`.

  - Per le batterie, se è necessario dividere i dati, sono necessari i nomi e le patch per la batteria.
  
  - La maggior parte delle macchine Thinkpad richiede la `PTSWAK extensional patch` per risolvere i problemi relativi alla luce respiratoria.
  
  - Il `PNP0C0E Sleep Adjust Method` è utile per quelle macchine che hanno il tasto 💤 o 🌙. 
  

- Potrebbe essere necessario disabilitare o abilitare un componente per risolvere un problema spcifico. I metodi sono:
  - `Binary Renames & Preset Variables`-----Il metodo di rinomina binaria è particolarmente efficace. **Attenzione**, si dovrebbero valutare gli impatti negativi per i multi-sistemi, dato che la rinomina binaria si applica a tutti i sistemi.
  
  - Il metodo dei "falsi dispositivi" è affidabile. **Raccomandare** 

## Patch importanti

- ***SSDT-RTC0*** --under`Fake Devices`-

  RTC【PNP0B00】 in alcune macchine è disabilitato, portando al panico nella fase iniziale. Utilizzare ***SSDT-RTC0***** per rattopparlo.

- ***SSDT-EC***** --Fake EC` -Under`Fake EC`.

  Per **MacOS 10.15+**,***SSDT-EC*** è necessario se il `Embedded Controller` non è nominato come `EC`, altrimenti il panico.
