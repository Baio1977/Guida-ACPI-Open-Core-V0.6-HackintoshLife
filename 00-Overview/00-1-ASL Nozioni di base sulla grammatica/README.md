auto_awesome
Traduci da: Inglese
1637 / 5000
Risultati della traduzione
# ACPI Source Language

> Questa guida è citata da PCBeta, Pubblicato il 2011-11-21 11:16:20, Autore: suhetao.
>
> Contrassegnato e corretto da Bat.bat (williambj1) il 14-2-2020.
>
> <http://bbs.pcbeta.com/forum.php?mod=viewthread&tid=944566&archive=2&extra=page%3D1&page=1>

## Prefazione

Non sono uno sviluppatore di BIOS, i seguenti contenuti si basano sulla comprensione di `Specifiche ACPI` ~~ <http://www.acpi.info/> ~~ [Non valido, è stato trasferito a <https: // uefi. org>] In quanto tale, non sono in grado di evitare incomprensioni e opinioni errate e spero che tu sia in grado di adattarli e migliorarli.

## Descrption

Prima di tutto, è necessario differenziare DSDT (Campi della tabella di descrizione del sistema differenziato) e SSDT (Campi della tabella di descrizione del sistema secondario). Sono tutte forme di "Configurazione avanzata e interfaccia di alimentazione", di cui è abbreviato in "ACPI". , lo percepiamo come una serie di tabelle per descrivere le interfacce. Di conseguenza, la funzione principale di `ACPI` è quella di fornire ai sistemi operativi alcuni servizi e informazioni. DSDT e SSDT non sono esclusi. Una caratteristica notevole di` ACPI` è utilizzando un linguaggio specifico per creare tabelle ACPI. Questo linguaggio, ASL (ACPI Source Language), è il fulcro di questo articolo. Compiliamo ASL to AML (ACPI Machine Language) da software specifici, a loro volta, eseguiti dal sistema operativo. L'ASL è un tipo di linguaggio, deve avere i suoi ruoli.


## Ruoli ASL

1. La variabile non deve superare 4
caratteri e non iniziare con i digitali. Controlla solo eventuali DSDT / SSDT, senza eccezioni.

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

    I parametri `xxxx` si riferiscono a` Nome file`, `OEMID`,` ID tabella`, `Versione OEM`. Il terzo parametro è basato sul secondo parametro. Come mostrato sopra, se il secondo parametro è **` DSDT` * *, a sua volta, il terzo parametro è `0x02`. Altri parametri possono essere inseriti liberamente.

2. Quei metodi e le variabili che iniziano con "_" sono riservati dai sistemi operativi, ecco perché alcune tabelle ASL contengono avvisi di attivazione "_T_X" dopo la decompilazione.

   
3. "Method" può essere definito seguito da "Device" o "Scope". Pertanto, "method" non può essere definito senza "Scope" e le istanze elencate di seguito sono ** non valide **.

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

 > ** I componenti con attributi diversi si trovano negli ambiti corrispondenti. Per esempi: **

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

-I componenti si riferiscono alla posizione della CPU sotto

      > CPU diverse posizionano ambiti comuni in modo diverso, ad esempio `_PR`,` _SB`, `SCK0`

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

Sì, i metodi possono essere inseriti qui. Attenzione, i metodi che iniziano con ** `_` ** sono riservati dai sistemi operativi.

5. Anche "Device (xxxx)" può essere riconosciuto come ambito, contiene varie descrizioni dei dispositivi, ad esempio "_ADR", "_CID", "_UID", "_DSM", "_STA".

6. Il simbolo "\" cita l'ambito radice; "^" cita l'ambito superiore. Allo stesso modo, "^" è superiore a "^^".

7. Il simbolo "_" non ha significato, completa solo i 4 caratteri, ad esempio "_OSI".

8. Per una migliore comprensione, ACPI rilascia "ASL + (ASL2.0)", introduce il linguaggio C "+ - * / =", "<<", ">>" e il giudizio logico "==", "! =" eccetera.

9. I metodi in ASL possono accettare fino a 7 argomenti, sono rappresentati da `Arg0` a` Arg6` e non possono essere personalizzati.

10. Le variabili locali in ASL possono accettare fino a 8 argomenti, sono rappresentate da `Local0` ~` Local7` Le definizioni non sono necessarie, ma dovrebbero essere inizializzate, in altre parole, è necessaria l'assegnazione.

## ASL Common Type of Data

|    ASL    |  
| :-------: | 
| `Integer` | 
| `String`  |  
|  `Event`  |  
| `Buffer`  |  
| `Package` | 

## ASL Variables Definition

- Define Integer

  ```swift
  Name (TEST, 0)
  ```

- Define String
  
  ```swift
  Name (MSTR,"ASL")
  ```

- Define Package

  ```swift
  Name (_PRW, Package (0x02)
  {
      0x0D,
      0x03
  })
  ```

- Define Buffer Field

  > Buffer Field 6 types in total:

|     Create statement     |   size   |
| :--------------: | :------: |
|  CreateBitField  |  1-Bit   |
| CreateByteField  |  8-Bit   |
| CreateWordField  |  16-Bit  |
| CreateDWordField |  32-Bit  |
| CreateQWordField |  64-Bit  |
|   CreateField    | any sizes |

  ```swift
  CreateBitField (AAAA, Zero, CCCC)
  CreateByteField (DDDD, 0x01, EEEE)
  CreateWordField (FFFF, 0x05, GGGG)
  CreateDWordField (HHHH, 0x06, IIII)
  CreateQWordField (JJJJ, 0x14, KKKK)
  CreateField (LLLL, Local0, 0x38, MMMM)
  ```

Non è necessario annunciare il suo tipo quando si definisce una variabile.

## ASL Assignment

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

Read `ACPI Specification` for details

## ASL Logic

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

Only two results from logical calculation - `0` or `1`

## ASL Definition of Method

1. Define a Method

   ```swift
   Method (TEST)
   {
       ...
   }
   ```

2. Define a method contains 2 parameters, and apply local variables`Local0`~`Local7`

   Numbers of parameters are defaulted as `0`

   ```swift
   Method (MADD, 2)
   {
       Local0 = Arg0
       Local1 = Arg1
       Local0 += Local1
   }
   ```


3. Define a method contains a return value
  
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

4. Define serialised method

   If not define `Serialized` or `NotSerialized`, default as `NotSerialized`

   ```swift
   Method (MADD, 2, Serialized)
   {
       Local0 = Arg0
       Local1 = Arg1
       Local0 += Local1
       Return (Local0)
   }
   ```

   It looks like `multi-thread synchronisation`. In other words, only one instance can be existed in the memory when the method is stated as `Serialized`. Normally the application create one object, for example:

   ```swift
   Method (TEST, Serialized)
   {
       Name (MSTR,"I will sucess")
   }
   ```

   If we state `TEST` shown above，and call it from two different methods:

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
If we execute `TEST` in `Dev1`, then `TEST` in `Dev2` will wait until the first one finalised. If we state:

   ```swift
   Method (TEST, NotSerialized)
   {
       Name (MSTR, "I will sucess")
   }
   ```

   when one of `TEST` called from `Devx`, another `TEST` will be failed to create `MSTR`.

## ACPI Preset Function

### `_OSI`  (Operating System Interfaces)

It is easy to acquire the current operating system's name and version when applying `_OSI`. For example, we could apply a patch that is specific to Windows or MacOS.

`_OSI` requires a string, the string must be picked from the table below.

|                 OS                  |      String      |
| :---------------------------------------: | :--------------: |
|                   macOS                   |    `"Darwin"`    |
| Linux<br/>(Including OS based on Linux kernel) |    `"Linux"`     |
|                  FreeBSD                  |   `"FreeBSD"`    |
|                  Windows                  | `"Windows 20XX"` |

> Notably，different Windows versions requre a unique string，read：
>
> <https://docs.microsoft.com/en-us/windows-hardware/drivers/acpi/winacpi-osi>

When `_OSI`'s string matchs the current system, it returns `1`, `If` condition is valid.

```swift
If (_OSI ("Darwin")) /* judge if the current system is macOS */
```

### `_STA` (Status)

**Caution⚠️: two types of `_STA`，do not mix up`_STA`from`PowerResource`！！！**

5 types of bit can be return from `_STA` method, explanations are listed below:

| Bit   | Explanations                           |
| :-----: | :----------------------------- |
| Bit [0] | Set if the device is present.                   |
| Bit [1] | Set if the device is enabled and decoding its resources. |
| Bit [2] | Set if the device should be shown in the UI.         |
| Bit [3] | Set if the device is functioning properly (cleared if device failed its diagnostics).            |
| Bit [4] | Set if the battery is present.             |

We need to transfer these bits from hexadecimal to binary. `0x0F` transfered to `1111`, meaning enable it(the first four bits); while `Zero` means disable. 

We also encounter `0x0B`,`0x1F`. `1011` is a binary form of `0x0B`, meaning the device is enabled and not is not allowed to decode its resources. `0X0B` often utilised in **`SSDT-PNLF`**. `0x1F` (`11111`)only appears to describe battery device from laptop, the last bit is utilised to inform Control Method Battery Device `PNP0C0A` that the battery is present.

> In terms of `_STA` from `PowerResource`
>
> `_STA` from `PowerResource` only returns `One` or `Zero`. Please read `ACPI Specification` for detail.

### `_CRS` (Current Resource Settings)
`_CRS` returns a `Buffer`, it is often utilised to acquire touchable devices' `GPIO Pin`,`APIC Pin` for controlling the interrupt mode.


## ASL flow Control

ASL also has its method to control flow.

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


### Loop control

#### `While` & `Stall`

```swift
Local0 = 10
While (Local0 >= 0x00)
{
    Local0--
    Stall (32)
}
```

`Local0` = `10`,if `Local0` ≠ `0` is false, `Local0`-`1`, stall `32μs`, the codes delay `10 * 32 = 320 μs`。

#### `For`

`For` from `ASL` is similar to `C`, `Java`

```swift
for (local0 = 0, local0 < 8, local0++)
{
    ...
}
```

`For` shown above and `While` shown below are equivalent

```swift
Local0 = 0
While (Local0 < 8)
{
    Local0++
}
```

## `External` Quote

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

`CondRefOf` is useful to check the object is existed or not.

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

The codes are quoted from **`SSDT-I2CxConf`**. When system is not MacOS, and `XSCN` exists under `I2C0`, it returns the orginal value.

## Conclusion
Hoping this article assists you when you are editing DSDT/SSDT.