# ACPI linguaggio del codice

> Questa guida è citata da PCBeta, Pubblicato il 2011-11-21 11:16:20, Autore: suhetao.
>
> Contrassegnato e corretto da Bat.bat (williambj1) il 14-2-2020.
>
> <http://bbs.pcbeta.com/forum.php?mod=viewthread&tid=944566&archive=2&extra=page%3D1&page=1>

## Prefazione

Non sono uno sviluppatore di BIOS, i seguenti contenuti si basano sulla comprensione di `Specifiche ACPI`[<https://uefi.org>] In quanto tale, non sono in grado di evitare incomprensioni e opinioni errate e spero che tu sia in grado di adattarli e migliorarli.

## Descrizione

Prima di tutto, è necessario differenziare DSDT (Campi della tabella di descrizione del sistema differenziato) e SSDT (Campi della tabella di descrizione del sistema secondario). Sono tutte forme di "Configurazione avanzata e interfaccia di alimentazione", di cui è abbreviato in "ACPI". , lo percepiamo come una serie di tabelle per descrivere le interfacce. Di conseguenza, la funzione principale di `ACPI` è quella di fornire ai sistemi operativi alcuni servizi e informazioni. DSDT e SSDT non sono esclusi. Una caratteristica notevole di ACPI è l'utilizzo di un linguaggio specifico per creare tabelle ACPI. Questo linguaggio, ASL (ACPI Source Language), è il fulcro di questo articolo. Compiliamo ASL to AML (ACPI Machine Language) da software specifici, a loro volta, eseguiti dal sistema operativo. L'ASL è un tipo di linguaggio, deve avere i suoi ruoli.

## Ruoli ASL

1. La variabile non deve superare 4
caratteri non iniziare con i digitali. Controlla solo eventuali DSDT / SSDT, senza eccezioni.

1. "Scope" è simile a "{}". Ce n'è uno e solo uno "Scope". Pertanto, DSDT inizia con

   ```swift
   DefinitionBlock ("xxxx", "DSDT", 0x02, "xxxx", "xxxx", xxxx)
   {
   ```

   and ended by

   ```swift
   }
   ```

Questo è "root Scope".

    I parametri `xxxx` si acquistano a` Nome file`,` OEMID`, `ID tabella`,` Versione OEM`. Il terzo parametro è basato sul secondo parametro. Come mostrato sopra, se il secondo parametro è **`DSDT`**, a sua volta, il terzo parametro è` 0x02`. Altri parametri possono essere inseriti liberamente.

2. Quei metodi e le variabili che iniziano con "_" sono riservati dai sistemi operativi, ecco perché alcune tabelle ASL contengono avvisi di attivazione "_T_X" dopo la decompilazione.

3. `Method` can be defined followed by `Device` or `Scope`. As such, `method` cannot be defined without `Scope`, and the instances listed below are **invalid**.

   ```swift
   Method (xxxx, 0, NotSerialized)
   {
       ...
   }
   DefinitionBlock ("xxxx", "DSDT", 0x02, "xxxx", "xxxx", xxxx)
   {
       ...
   }
   ```

4. `\_GPE`,`\_PR`,`\_SB`,`\_SI`,`\_TZ` belong to root scope `\`.

   - `\_GPE`--- ACPI Event handlers
   - `\_PR` --- CPU
   - `\_SB` --- Devices and buses
   - `\_SI` --- System indicator
   - `\_TZ` --- Thermal zone

   > **Components with different atrributes place under corresponding scopes. For examples:**

   - `Device (PCI0)` places under `Scope (\_SB)`

     ```swift
     Scope (\_SB)
     {
         Device (PCI0)
         {
             ...
         }
         ...
     }
     ```

   - Components relate to CPU place under

     > different CPUs place variously, common scopes for instance `_PR`,`_SB`,`SCK0`

     ```swift
     Scope (_PR)
     {
         Processor (CPU0, 0x00, 0x00000410, 0x06)
         {
             ...
         }
         ...
     }
     ```

   - `Scope (_GPE)` places event handlers

      ```swift
      Scope (_GPE)
      {
          Method (_L0D, 0, NotSerialized)
          {
              ...
          }
          ...
      }
      ```

      Yes, methods can be placed here. Caution, methods begin with **`_`** are reserved by operating systems.

5. `Device (xxxx)` also can be recognised as a scope, it cotains various descriptions to devices, e.g. `_ADR`,`_CID`,`_UID`,`_DSM`,`_STA`.

6. Symbol `\` quotes the root scope; `^` quotes the superior scope. Similarly,`^` is superior to `^^`.

7. Symbol `_` is meaningless, it only completes the 4 characters, e.g. `_OSI`.

8. For better understanding, ACPI releases `ASL+(ASL2.0)`, it introduces C language's `+-*/=`, `<<`, `>>` and logical judgment `==`, `!=` etc.

9. Methods in ASL can accept up to 7 arguments; they are represented by `Arg0` to `Arg6` and cannot be customised.

10. Local Variables in ASL can accept up to 8 arguments；they are represented by `Local0`~`Local7`. Definitions is not necessary, but should be initialised, in other words, assignment is needed.

## Tipo comune di dati ASL

|    ASL    |  
| :-------: | 
| `Integer` | 
| `String`  |  
|  `Event`  |  
| `Buffer`  |  
| `Package` |

## Definizione delle variabili ASL

- Definisci numero intero

  ```swift
  Name (TEST, 0)
  ```

- Definisci stringa
  
  ```swift
  Name (MSTR,"ASL")
  ```

- Definisci pacchetto

  ```swift
  Name (_PRW, Package (0x02)
  {
      0x0D,
      0x03
  })
  ```

- Definisci campo buffer

  > Buffer Field 6 tipi in totale:

| Crea dichiarazione | dimensione |
| : --------------: | : ------: |
| CreateBitField | 1 bit |
| CreateByteField | 8 bit |
| CreateWordField | 16 bit |
| CreateDWordField | 32 bit |
| CreateQWordField | 64 bit |
| CreateField | qualsiasi dimensione |

  ```swift
  CreateBitField (AAAA, Zero, CCCC)
  CreateByteField (DDDD, 0x01, EEEE)
  CreateWordField (FFFF, 0x05, GGGG)
  CreateDWordField (HHHH, 0x06, IIII)
  CreateQWordField (JJJJ, 0x14, KKKK)
  CreateField (LLLL, Local0, 0x38, MMMM)
  ```

Non è necessario annunciare il suo tipo quando si definisce una variabile.

## Assegnazione ASL

```swift
Store (a,b) /* legacy ASL */
b = a      /*   ASL+  */
```

Esempio:

```swift
Store (0, Local0)
Local0 = 0

Store (Local0, Local1)
Local1 = Local0
```

## Calcolo ASL

|  ASL+  |  Legacy ASL  |     Examples                                                         |
| :----: | :--------: | :----------------------------------------------------------- |
|   +    |    Add     |    `Local0 = 1 + 2`<br/>`Add (1, 2, Local0)`                    |
|   -    |  Subtract  |     `Local0 = 2 - 1`<br/>`Subtract (2, 1, Local0)`               |
|   *    |  Multiply  |     `Local0 = 1 * 2`<br/>`Multiply (1, 2, Local0)`               |
|   /    |   Divide   |    `Local0 = 10 / 9`<br/>`Divide (10, 9, Local1(remainder), Local0(result))` |
|   %    |    Mod     |     `Local0 = 10 % 9`<br/>`Mod (10, 9, Local0)`                  |
|   <<   | ShiftLeft  |      `Local0 = 1 << 20`<br/>`ShiftLeft (1, 20, Local0)`           |
|   >>   | ShiftRight |    `Local0 = 0x10000 >> 4`<br/>`ShiftRight (0x10000, 4, Local0)` |
|   --   | Decrement  |   `Local0--`<br/>`Decrement (Local0)`                          |
|   ++   | Increment  |   `Local0++`<br/>`Increment (Local0)`                          |
|   &    |    And     |      `Local0 = 0x11 & 0x22`<br/>`And (0x11, 0x22, Local0)`        |
| &#124; |     Or     |        `Local0 = 0x01`&#124;`0x02`<br/>`Or (0x01, 0x02, Local0)`  |
|   ~    |    Not     |   `Local0 = ~(0x00)`<br/>`Not (0x00,Local0)`                   |
|      |    Nor     |    `Nor (0x11, 0x22, Local0)`                                   |

Leggere "Specifiche ACPI" per i dettagli

## Logica ASL

|  ASL+  |   Legacy ASL  | Examples             |
| :----: | :-----------: | :----------------------------------------------------------- |
|   &&   |     LAnd      |  `If (BOL1 && BOL2)`<br/>`If (LAnd(BOL1, BOL2))`              |
|   !    |     LNot      |  `Local0 = !0`<br/>`Store (LNot(0), Local0)`                  |
| &#124; |      LOr      |  `Local0 = (0`&#124;`1)`<br/>`Store (LOR(0, 1), Local0)`    |
|   <    |     LLess     |  `Local0 = (1 < 2)`<br/>`Store (LLess(1, 2), Local0)`         |
|   <=   |  LLessEqual   |  `Local0 = (1 <= 2)`<br/>`Store (LLessEqual(1, 2), Local0)`   |
|   >    |   LGreater    |  `Local0 = (1 > 2)`<br/>`Store (LGreater(1, 2), Local0)`      |
|   >=   | LGreaterEqual |  `Local0 = (1 >= 2)`<br/>`Store (LGreaterEqual(1, 2), Local0)` |
|   ==   |    LEqual     |  `Local0 = (Local0 == Local1)`<br/>`If (LEqual(Local0, Local1))` |
|   !=   |   LNotEqual   |  `Local0 = (0 != 1)`<br/>`Store (LNotEqual(0, 1), Local0)`    |

Solo due risultati dal calcolo logico: "0" o "1"

## Definizione di metodo ASL

1. Definire un metodo

   ```swift
   Method (TEST)
   {
       ...
   }
   ```

2. Definire un metodo che contenga 2 parametri e applicare le variabili locali`Local0` ~ `Local7`

   I numeri dei parametri sono impostati come "0"

   ```swift
   Method (MADD, 2)
   {
       Local0 = Arg0
       Local1 = Arg1
       Local0 += Local1
   }
   ```


3. Definire un metodo che contenga un valore di ritorno
  
   ```swift
   Method (MADD, 2)
   {
       Local0 = Arg0
       Local1 = Arg1
       Local0 += Local1

       Return (Local0) /* return here */
   }
   ```
   
   ```swift
   Local0 = 1 + 2            /* ASL+ */
   Store (MADD (1, 2), Local0)  /* Legacy ASL */
   ```
   `` `

4. Definire il metodo serializzato

   Se non definire "Serialized" o "NotSerialized", il valore predefinito è "NotSerialized"

   ```swift
   Method (MADD, 2, Serialized)
   {
       Local0 = Arg0
       Local1 = Arg1
       Local0 += Local1
       Return (Local0)
   }
   ```

   Sembra una "sincronizzazione multi-thread". In altre parole, solo un'istanza può essere presente nella memoria quando il metodo è dichiarato come "Serializzato". Normalmente l'applicazione crea un oggetto, ad esempio:

   ```swift
   Method (TEST, Serialized)
   {
       Name (MSTR,"I will sucess")
   }
   ```

   Se affermiamo `TEST` mostrato sopra ， e lo chiamiamo da due metodi diversi:

   ```swift
   Device (Dev1)
   {
        TEST ()
   }
   Device (Dev2)
   {
        TEST ()
   }
   ```

Se eseguiamo `TEST` in` Dev1`, allora `TEST` in` Dev2` aspetterà fino a quando il primo non sarà finalizzato. Se affermiamo:

   ```swift
   Method (TEST, NotSerialized)
   {
       Name (MSTR, "I will sucess")
   }
   ```
   quando uno di `TEST` chiamato da` Devx`, un altro `TEST` non riuscirà a creare` MSTR`.

## Funzione Preset ACPI

### `_OSI` (interfacce del sistema operativo)

È facile acquisire il nome e la versione del sistema operativo corrente quando si applica "_OSI". Ad esempio, potremmo applicare una patch specifica per Windows o MacOS.

"_OSI" richiede una stringa, la stringa deve essere prelevata dalla tabella sottostante.

|                 OS                  |      String      |
| :---------------------------------------: | :--------------: |
|                   macOS                   |    `"Darwin"`    |
| Linux<br/>(Including OS based on Linux kernel) |    `"Linux"`     |
|                  FreeBSD                  |   `"FreeBSD"`    |
|                  Windows                  | `"Windows 20XX"` |

> In particolare ， diverse versioni di Windows richiedono una stringa univoca ， leggi ：
>
> <https://docs.microsoft.com/en-us/windows-hardware/drivers/acpi/winacpi-osi>

Quando la stringa di "_OSI" corrisponde al sistema corrente, restituisce "1", la condizione "If" è valida.

`` rapido
If (_OSI ("Darwin")) / * giudica se il sistema corrente è macOS * /
`` `
### `_STA` (Stato)

**Caution⚠️: two types of `_STA`，do not mix up`_STA`from`PowerResource`！！！**

5 types of bit can be return from `_STA` method, explanations are listed below:

| Bit   | Explanations                           |
| :-----: | :----------------------------- |
| Bit [0] | Set if the device is present.                   |
| Bit [1] | Set if the device is enabled and decoding its resources. |
| Bit [2] | Set if the device should be shown in the UI.         |
| Bit [3] | Set if the device is functioning properly (cleared if device failed its diagnostics).            |
| Bit [4] | Set if the battery is present.             |

Dobbiamo trasferire questi bit da esadecimale a binario. "0x0F" trasferito a "1111", che significa abilitarlo (i primi quattro bit); mentre "Zero" significa disabilitare.

Incontriamo anche "0x0B", "0x1F". "1011" è una forma binaria di "0x0B", il che significa che il dispositivo è abilitato e non autorizzato a decodificare le sue risorse. `0X0B` spesso usato in **` SSDT-PNLF` **. "0x1F" ("11111") sembra descrivere solo il dispositivo batteria dal laptop, l'ultimo bit è utilizzato per informare il metodo di controllo del dispositivo batteria "PNP0C0A" che la batteria è presente.

> In termini di `_STA` da` PowerResource`
>
> `_STA` da` PowerResource` restituisce solo` Uno` o` Zero`. Si prega di leggere "Specifiche ACPI" per i dettagli.

### `_CRS` (Impostazioni correnti delle risorse)
`_CRS` restituisce un` Buffer`, è spesso utilizzato per acquisire dispositivi toccabili '`GPIO Pin`,` APIC Pin` per controllare la modalità di interruzione.


## Controllo del flusso ASL

ASL ha anche il suo metodo per controllare il flusso.

- Switch
  - Case
  - Default
  - BreakPoint
- While
  - Break
  - Continue
- If
  - Else
  - ElseIf
- Stall

### Branch control `If` & `Switch`

#### `If`

   The following codes check if the system is `Darwin`, if yes then`OSYS = 0x2710`

   ```swift
   If (_OSI ("Darwin"))
   {
       OSYS = 0x2710
   }
   ```

#### `ElseIf`, `Else`

   The following codes check if the system is `Darwin`, and if the system is not `Linux`, if yes then `OSYS = 0x07D0`

   ```swift
   If (_OSI ("Darwin"))
   {
       OSYS = 0x2710
   }
   ElseIf (_OSI ("Linux"))
   {
       OSYS = 0x03E8
   }
   Else
   {
       OSYS = 0x07D0
   }
   ```

#### `Switch`, `Case`, `Default`, `BreakPoint`

   ```swift
   Switch (Arg2)
   {
       Case (1) /* Condition 1 */
       {
           If (Arg1 == 1)
           {
               Return (1)
           }
           BreakPoint /* Mismatch condition, exit */
       }
       Case (2) /* Condition 2 */
       {
           ...
           Return (2)
       }
       Default /* if condition is not match，then */
       {
           BreakPoint
       }
   }
   ```

### Controllo del loop

#### `While` &` Stall`

```swift
Local0 = 10
While (Local0 >= 0x00)
{
    Local0--
    Stall (32)
}
```

`Local0` = `10`,if `Local0` ≠ `0` is false, `Local0`-`1`, stall `32μs`, the codes delay `10 * 32 = 320 μs`。


#### `Per`

`For` from `ASL` is similar to `C`, `Java`

```swift
for (local0 = 0, local0 < 8, local0++)
{
    ...
}
```

"For" mostrato sopra e "While" sotto sono equivalenti

```swift
Local0 = 0
While (Local0 < 8)
{
    Local0++
}
```

## Citazione `Esterno`

|    Quote Types    | External SSDT Quote| Quoted    |
| :------------: | :------------: |  :------------------------------------ |
|   UnknownObj    | `External (\_SB.EROR, UnknownObj`             | (avoid to use)                          |
|     IntObj        | `External (TEST, IntObj`                      | `Name (TEST, 0)`                                                        |
|     StrObj        | `External (\_PR.MSTR, StrObj`                 | `Name (MSTR,"ASL")`                                                     |
|    BuffObj       | `External (\_SB.PCI0.I2C0.TPD0.SBFB, BuffObj` | `Name (SBFB, ResourceTemplate ()`<br/>`Name (BUF0, Buffer() {"abcde"})` |
|     PkgObj      | `External (_SB.PCI0.RP01._PRW, PkgObj`        | `Name (_PRW, Package (0x02) { 0x0D, 0x03 })`                            |
|  FieldUnitObj     | `External (OSYS, FieldUnitObj`                | `OSYS,   16,`                                                           |
|   DeviceObj       | `External (\_SB.PCI0.I2C1.ETPD, DeviceObj`    | `Device (ETPD)`                                                         |
|    EventObj       | `External (XXXX, EventObj`                    | `Event (XXXX)`                                                          |
|   MethodObj        | `External (\_SB.PCI0.GPI0._STA, MethodObj`    | `Method (_STA, 0, NotSerialized)`                                       |
|    MutexObj       | `External (_SB.PCI0.LPCB.EC0.BATM, MutexObj`  | `Mutex (BATM, 0x07)`                                                    |
|  OpRegionObj      | `External (GNVS, OpRegionObj`                 | `OperationRegion (GNVS, SystemMemory, 0x7A4E7000, 0x0866)`              |
|  PowerResObj     | `External (\_SB.PCI0.XDCI, PowerResObj`       | `PowerResource (USBC, 0, 0)`                                            |
|  ProcessorObj      | `External (\_SB.PR00, ProcessorObj`           | `Processor (PR00, 0x01, 0x00001810, 0x06)`                              |
| ThermalZoneObj    | `External (\_TZ.THRM, ThermalZoneObj`         | `ThermalZone (THRM)`                                                    |
|  BuffFieldObj      | `External (\_SB.PCI0._CRS.BBBB, BuffFieldObj` | `CreateField (AAAA, Zero, BBBB)`                                        |

> DDBHandleObj is rare, no discussion

## ASL CondRefOf

`CondRefOf` è utile per controllare che l'oggetto sia esistito o meno.

```swift
Method (SSCN, 0, NotSerialized)
{
    If (_OSI ("Darwin"))
    {
        ...
    }
    ElseIf (CondRefOf (\_SB.PCI0.I2C0.XSCN))
    {
        If (USTP)
        {
            Return (\_SB.PCI0.I2C0.XSCN ())
        }
    }

    Return (Zero)
}
```

I codici sono citati da ** `SSDT-I2CxConf` **. Quando il sistema non è MacOS e "XSCN" esiste in "I2C0", restituisce il valore originale.

## Conclusione
Spero che questo articolo ti aiuti quando stai modificando DSDT / SSDT.
