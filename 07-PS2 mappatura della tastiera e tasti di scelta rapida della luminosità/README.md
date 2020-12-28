# Mappatura della tastiera PS2 e scorciatoie per la luminosità

## Descrizione

- Attraverso la mappatura della tastiera, è possibile generare l'effetto di un altro tasto dopo aver premuto un determinato tasto. Ad esempio, è possibile specificare che dopo aver premuto `A / a`, l'output di stampa è `Z / z`. Per un altro esempio, specificare `F2` per realizzare la funzione originale di `F10`.
- Nuova versione [30 settembre] **VoodooPS2Controller.kext** separa la parte del tasto di scelta rapida della luminosità in un driver indipendente **BrightnessKeys.kext** e fornisce il metodo `Notify (^^^ GFX0. ***, 0x86) `E` Notify (^^^ GFX0. ***, 0x87) `, la tradizionale patch di scorciatoia per la luminosità non è più necessaria. Se il nuovo driver non è valido, fare riferimento al contenuto di questo capitolo per assegnare 2 tasti da mappare a `F14`,` F15` per realizzare la funzione dei tasti di scelta rapida per regolare la luminosità.
  - **VoodooPS2Controller.kext**: https://github.com/acidanthera/VoodooPS2
  - **BrightnessKeys.kext**: https://github.com/acidanthera/BrightnessKeys
  
  **Nota**: Alcune macchine Dell e Asus richiedono ***`SSDT-OCWork`*** o `patch del sistema operativo` per deselezionare` Notify (^^^ GFX0. ***, 0x86) `e` Notify ( ^^^ GFX0. ***, 0x87) `restrizioni, fare in modo che **BrightnessKeys.kext** funzioni normalmente. Per i dettagli, fare riferimento a `Patch speciali per macchine Dell` e `Patch speciali per macchine Asus`.
- Non tutti i pulsanti possono essere mappati, possono essere mappati solo i pulsanti che possono catturare il codice di scansione PS2 sotto il sistema MAC.

## Richiesta

- Usa **VoodooPS2Controller.kext** e i suoi sub-driver.
- Cancella il contenuto della mappatura chiave precedente di altri metodi.

### Codice di scansione PS2 e codice di scansione ABD

Un pulsante genererà 2 codici di scansione, che sono **codice di scansione PS2** e **codice di scansione ABD**. Ad esempio, il codice di scansione PS2 del tasto `Z / z` è `2c` e il codice di scansione ABD è `6`. A causa dei diversi codici di scansione, esistono due metodi di mappatura corrispondenti a:

- ` Codice di scansione PS2 -> Codice di scansione PS2`
- ` Codice di scansione PS2 -> Codice di scansione ADB`

### Ottieni il codice di scansione della tastiera

- Controlla il file di intestazione `ApplePS2ToADBMap.h`, il codice di scansione della maggior parte delle chiavi è elencato nel file.

- Ricevi il codice di scansione della tastiera dalla console (scegline uno)

  - Installa ioio nel terminale

    `` bash
      ioio -s ApplePS2Keyboard LogScanCodes 1
    `` `

  - **Modifica** `VoodooPS2Keyboard.kext \ info \ IOKitPersonality \ Platform Profile \ Default \` **`LogScanCodes`**` = `**`1`**

  Apri la console e cerca `ApplePS2Keyboard`. Premere i tasti, come `A / a`, `Z / z`.

  `` log
    11: 58: 51.255023 +0800 kernel ApplePS2Keyboard: invio della chiave 1e = 0 down
    11: 58: 58.636955 +0800 kernel ApplePS2Keyboard: invio della chiave 2c = 6 giù
  `` `

  tra loro:

  `1e` nella prima riga di `1e = 0` è il codice di scansione PS2 del tasto `A / a` e `0` è il codice di scansione di ADB.

  Nella seconda riga di `2c = 6`, `2c` è il codice di scansione PS2 del tasto `Z / z` e `6` è il codice di scansione di ADB.

### Metodo di mappatura

La mappatura della tastiera può essere realizzata modificando il file `VoodooPS2Keyboard.kext \ info.plist` e aggiungendo un file di patch di terze parti. Si consiglia il metodo di utilizzo di un file di patch di terze parti.

Esempio: ***SSDT-RMCF-PS2Map-AtoZ***. `A / a` viene mappato a `Z / z`.

- `A / a` Codice di scansione PS2: `1e`
- `Z / z` Codice di scansione PS2: `2c`
- `Z / z` Codice di scansione ADB: `06`

Scegli uno dei seguenti due metodi di mappatura

#### Codice di scansione PS2 -> Codice di scansione PS2

```Swift
    ...
      "Custom PS2 Map", Package()
      {
          Package(){},
          "1e=2c",
      },
    ...
```

#### Codice di scansione PS2 -> Codice di scansione ADB

```Swift
    ...
    "Custom ADB Map", Package()
    {
        Package(){},
        "1e=06",
    }
    ...
```

### Precauzioni

- Il percorso della tastiera nell'esempio è `\ _SB.PCI0.LPCB.PS2K`, assicurati che il suo percorso sia coerente con il percorso della tastiera ACPI quando lo usi. Il percorso della tastiera della maggior parte delle macchine Thinkpad è `\ _SB.PCI0.LPC.KBD` o` \ _SB.PCI0.LPCB.KBD`.

- La variabile `RMCF` è usata nella patch. Se` RMCF` è usata anche in altre **patch di tastiera**, deve essere unita e usata. Vedere ***SSDT-RMCF-PS2Map-dell***. `Nota`: ***SSDT-RMCF-MouseAsTrackpad*** viene utilizzato per attivare forzatamente l'opzione di impostazione del touchpad.

- In VoodooPS2, il codice di scansione PS2 corrispondente al pulsante <kbd> PrtSc </kbd> è `e037`, che è l'interruttore del touchpad (e il piccolo punto rosso sulle macchine ThinkPad). Puoi mappare questo pulsante a `F13` e associare `F13` alla funzione screenshot nelle `Preferenze di Sistema`:

```Swift
    ...
    "Custom ADB Map", Package()
    {
        Package(){},
        "e037=64", // PrtSc -> F13
    }
    ...
```

![](https://i.loli.net/2020/04/01/gQqVC2YKFweSARZ.png)
