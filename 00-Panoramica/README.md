# Panoramica

## Rinomina e patch ACPI

- Il metodo di rinomina è consigliabile evitarlo, ad esempio `HDAS rename HDEF`,` EC0 rename EC`, `SSDT-OC-XOSI`. Usare con cautela , speciale per coloro che rinominano` MethodObj` (ad esempio _STA , _OSI).
- Parlando in generale:
  - La patch del sistema operativo non è necessaria. Se i componenti sono limitati da un sistema operativo specifico, modificare la patch ACPI di conseguenza. **Attenzione** per `OS Patch`

  - La patch per i tasti di luminosità della tastiera non è necessaria per alcune macchine. Applicando invece `PS2 Keyboard Mapping & Brightness Function`.

  - Finora, la stragrande maggioranza delle macchine risolve il problema del "risveglio istantaneo" tramite la "patch 0D6D".

  - Per le batterie, se è richiesta la suddivisione dei dati, le ridenominazioni e le patch per la batteria sono necessarie.
  
  - La maggior parte delle macchine Thinkpad richiede la `patch dell'estensione PTSWAK` per risolvere i problemi relativi al night shift.
  
  - Il `Metodo di regolazione dello sleep PNP0C0E` è utile per quelle macchine che hanno il tasto sleep `💤` o `🌙`.
  

- Potrebbe essere necessario disabilitare o abilitare un componente per risolvere un problema specifico. I metodi sono:
  -`Binary Renames & Preset Variables` ----- il metodo binary rename è particolarmente efficace. **Attenzione**, è necessario valutare gli impatti negativi per i multi-boot, poiché il binary rename si applica a tutti i sistemi.
  
  - Il metodo `Fake Devices` è affidabile. **Consigliato**

## Patch importanti

- ***SSDT-RTC0*** ——in `Fake devices`

  RTC 【PNP0B00】 in alcune macchine è disabilitato, causando un kernel panic nella fase iniziale. Usa ***SSDT-RTC0*** per patcharlo.

- ***SSDT-EC*** ——Under`Fake EC`

  Per **MacOS 10.15+**,***SSDT-EC*** è necessario se `Embedded Controller` non è denominato `EC`, altrimenti causerà un kernel panic.
