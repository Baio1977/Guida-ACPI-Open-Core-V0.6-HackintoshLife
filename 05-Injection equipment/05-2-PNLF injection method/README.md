# Metodo di iniezione OC-PNLF

## Brightness (`PNLF`) La composizione della parte di controllo

-Guidare:

  - Driver per la luminosità integrato di AnyGreen.kext (richiede Lilu.kext)

    Per impostazione predefinita, WutelyGreen.kext caricherà il driver della luminosità. Se usi altri driver di luminosità, dovresti disabilitare il suo driver di luminosità integrato.

    -Metodo disabilitato:

      -Aggiungere il parametro di avvio `applbkl = 0`
      -Modifica il file `Info.plist \ IOKitPersonality \ AppleIntelPanelA \ IOProbeScore = 5500` del driver.

    -Link di download: <https://github.com/acidanthera/W qualunqueGreen/releases>

  -IntelBacklight.kext
  
    -Scarica link: <https://bitbucket.org/RehabMan/os-x-intel-backlight/src/master/>
  
  -ACPIBacklight.kext
  
    -Scarica link: <https://bitbucket.org/RehabMan/os-x-acpi-backlight/src/master/>
  
-Patch

  -Patch luminosità personalizzato

    - *** SSDT-PNLF-SNB_IVY ***: patch di luminosità di 2a e 3a generazione.
    - *** SSDT-PNLF-Haswell_Broadwell ***: patch di luminosità di 4a e 5a generazione.
    - *** SSDT-PNLF-SKL_KBL ***: patch di luminosità di sesta e settima generazione.
    - *** SSDT-PNLF-CFL ***: 8a generazione + patch di luminosità.

      La patch sopra è inserita in `_SB`.

  -Patch luminosità RehabMan
  
    - [https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-PNLF.dsl] (https://github.com/RehabMan/OS-X-Clover -Laptop-Config / blob / master / hotpatch / SSDT-PNLF.dsl)
  
    - [https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-PNLFCFL.dsl] (https://github.com/RehabMan/OS-X-Clover -Laptop-Config / blob / master / hotpatch / SSDT-PNLFCFL.dsl)
  
    - [https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-RMCF.dsl] (https://github.com/RehabMan/OS-X-Clover -Laptop-Config / blob / master / hotpatch / SSDT-RMCF.dsl)
  
      La patch di luminosità di RehabMan è inserita in `_SB.PCI0.IGPU`. Quando la si utilizza, rinominare la` IGPU` del file di patch con il nome originale in ACPI (ad esempio: `GFX0`).

## Metodi di iniezione comuni

-Drive: qualunque sia il verde
-Patch: patch di luminosità personalizzato o patch di luminosità RehabMan

## Metodo di iniezione ACPI

-Driver: ACPIBacklight.kext (è necessario disabilitare il driver di luminosità integrato W AnyGreen.kext, vedere il metodo di disabilitazione sopra)
-Patch: vedere il metodo "ACPI Brightness Patch"

## Altri metodi di iniezione

Provalo tu stesso secondo il principio di driver + patch.

## Precauzioni

-Quando si seleziona un metodo di iniezione, i driver, le patch, le impostazioni, ecc. Relativi ad altri metodi dovrebbero essere cancellati.

-Quando si utilizzano patch di luminosità personalizzate, si prega di notare che le patch vengono tutte iniettate nel dispositivo `PNLF` sotto` _SB`. Quando c'è un campo `PNLF` nell'originale` ACPI`, deve essere rinominato, altrimenti influenzerà l'avvio di `Windows` . Puoi anche usare la [patch di `RehabMan`] (https://github.com/RehabMan/OS-X-Clover-Laptop-Config/tree/master/hotpatch). Rinominato come segue:

  `` testo
  // Da PNLF a XNLF
  Trova: 504E 4C46
  Sostituisci: 584E 4C46
  `` `
