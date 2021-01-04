# L'ACPI Source Language (ASL)

> Questa guida è tradotta da PCBeta, Pubblicata il 2011-11-21 11:16:20, Dall'autore: suhetao.
>
> Contrassegnata e corretta da Bat.bat (williambj1) il 14-2-2020.
>
> <http://bbs.pcbeta.com/forum.php?mod=viewthread&tid=944566&archive=2&extra=page%3D1&page=1>

## Prefazione

Non sono uno sviluppatore di BIOS, i seguenti contenuti si basano sulla comprensione di `Specifiche ACPI`[<https://uefi.org>] In quanto tale, non sono in grado di evitare incomprensioni e opinioni errate e spero che tu sia in grado di adattarli e migliorarli.

## Descrizione

Prima di tutto, è necessario differenziare DSDT (Differentiated System Description Table, letteralmente Campi della tabella di descrizione del sistema differenziato) e SSDT (Secondary System Description Table, letteralmente Campi della tabella di descrizione del sistema secondario). Sono tutte forme di "Advanced Configuration and Power Interface", "Configurazione avanzata e interfaccia di alimentazione", di cui è abbreviato in "ACPI". , lo percepiamo come una serie di tabelle per descrivere le interfacce. Di conseguenza, la funzione principale di `ACPI` è quella di fornire ai sistemi operativi alcuni servizi e informazioni. DSDT e SSDT non sono esclusi. Una caratteristica notevole di ACPI è l'utilizzo di un linguaggio specifico per creare tabelle ACPI. Questo linguaggio, ASL (ACPI Source Language), è il fulcro di questo articolo. Compiliamo ASL to AML (ACPI Machine Language) da software specifici, a loro volta, eseguiti dal sistema operativo. L'ASL è un tipo di linguaggio, deve avere i suoi ruoli.

## Ruoli ASL

1. La variabile non deve superare 4
caratteri non iniziare con i digitali. Controlla solo eventuali DSDT / SSDT, senza eccezioni.

2. `Scope` è simile a `{}`. È presente uno e un solo `Scope`. Pertanto, DSDT inizia con

   ```swift
   DefinitionBlock ("xxxx", "DSDT", 0x02, "xxxx", "xxxx", xxxx)
   {
   ```

   e termina con

   ```swift
   }
   ```

   Questo è il `root Scope`.

   I parametri `xxxx` si acquistano a` Nome file`,` OEMID`, `ID tabella`,` Versione OEM`. Il terzo parametro è basato sul secondo parametro. Come mostrato sopra, se il secondo parametro è **DSDT**, a sua volta, il terzo parametro è` 0x02`. Altri parametri possono essere inseriti liberamente.


3. Quei metodi e le variabili che iniziano con `_` sono riservati dai sistemi operativi, ecco perché alcune tabelle ASL contengono avvisi di attivazione `_T_X` dopo la decompilazione.


4. Il `Method` può essere definito se seguito da `Device` o `Scope`. In quanto, `method` non può essere definito senza `Scope`, e le istanze elencate qui sotto sono **invalid**.

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

5. `\_GPE`,`\_PR`,`\_SB`,`\_SI`,`\_TZ` appartengono al root scope `\`.

   - `\_GPE`--- Gestori degli Eventi ACPI (ACPI Event handlers)
   - `\_PR` --- CPU
   - `\_SB` --- Dispositivi e bus
   - `\_SI` --- Indicatori di sistema
   - `\_TZ` --- Gestione delle temperature

   > **I componenti con attributi diversi si inseriscono al di sotto degli scope corrispondenti. Per esempio:**

   - `Device (PCI0)` si inseriscono sotto `Scope (\_SB)`

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

   - Componenti che riguardano la CPU da inserire

     > Con CPU diverse si inserisce in un modo differente, ecco degli scope comuni per l'istanza `_PR`,`_SB`,`SCK0`

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

   - `Scope (_GPE)` inserisce diversi gestori di eventi

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

      Si, i metodi possono essere inseriti qui. Attenzione, i metodi che iniziano con **`_`** sono riservati ai sistemi operativi.

6. `Device (xxxx)` viene anche riconosciuto come uno scope, contiene varie descrizioni dei dispositivi, per esempio `_ADR`,`_CID`,`_UID`,`_DSM`,`_STA`.

7. Il simbolo `\` cita il root scope; `^` cita il superior scope. Allo stesso modo,`^` è superiore a `^^`.

8. Il simbolo `_` non ha alcun significato, semplicemente fa raggiungere 4 caratteri, per esempio `_OSI`.

9. Per una migliore comprensione, le release ACPI `ASL+(ASL2.0)`, introducono dal linguaggio C `+-*/=`, `<<`, `>>` e gli operatori logici `==`, `!=` ecc.

10. I methods in ASL possono accettare fino a 7 argomenti; sono rappresentati da `Arg0` a `Arg6` e non sono personalizzabili.

11. Le variabili locali in ASL possono accettare fino a 8 argomenti；sono rappresentati da `Local0` fino a `Local7`. Non è necessario definirli ma vanno inizializzati, in altre parole, è necessaria un'attribuzione.

## Tipo comune di dati ASL

|    ASL    |  
| :-------: | 
| `Integer` | 
| `String`  |  
|  `Event`  |  
| `Buffer`  |  
| `Package` |

## Definizione delle variabili ASL

- Definizione di un integer

  ```swift
  Name (TEST, 0)
  ```

- Definizione di una stringa
  
  ```swift
  Name (MSTR,"ASL")
  ```

- Definizione di un pacchetto

  ```swift
  Name (_PRW, Package (0x02)
  {
      0x0D,
      0x03
  })
  ```

- Definizione di un buffer field

  > Il buffer field si distingue in 6 tipi in totale:

| Creazione dell'istruzione |   dimensione   |
| :-----------------------: | :------------: |
|       CreateBitField      |      1-Bit     |
|       CreateByteField     |      8-Bit     |
|       CreateWordField     |      16-Bit    | 
|       CreateDWordField    |      32-Bit    |
|       CreateQWordField    |      64-Bit    |
|       CreateField         |      qualsiasi |

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

|  ASL+  | ASL Legacy |     Esempi                                                                    |
| :----: | :--------: | :-----------------------------------------------------------------------------|
|   +    |    Add     |    `Local0 = 1 + 2`<br/>`Add (1, 2, Local0)`                                  |
|   -    |  Subtract  |     `Local0 = 2 - 1`<br/>`Subtract (2, 1, Local0)`                            |
|   *    |  Multiply  |     `Local0 = 1 * 2`<br/>`Multiply (1, 2, Local0)`                            |
|   /    |   Divide   |    `Local0 = 10 / 9`<br/>`Divide (10, 9, Local1(remainder), Local0(result))`  |
|   %    |    Mod     |     `Local0 = 10 % 9`<br/>`Mod (10, 9, Local0)`                               |
|   <<   | ShiftLeft  |      `Local0 = 1 << 20`<br/>`ShiftLeft (1, 20, Local0)`                       |
|   >>   | ShiftRight |    `Local0 = 0x10000 >> 4`<br/>`ShiftRight (0x10000, 4, Local0)`              |
|   --   | Decrement  |   `Local0--`<br/>`Decrement (Local0)`                                         |
|   ++   | Increment  |   `Local0++`<br/>`Increment (Local0)`                                         |
|   &    |    And     |      `Local0 = 0x11 & 0x22`<br/>`And (0x11, 0x22, Local0)`                    |
| &#124; |     Or     |        `Local0 = 0x01`&#124;`0x02`<br/>`Or (0x01, 0x02, Local0)`              |
|   ~    |    Not     |   `Local0 = ~(0x00)`<br/>`Not (0x00,Local0)`                                  |
|        |    Nor     |    `Nor (0x11, 0x22, Local0)`                                                 |

Leggere `Specifiche ACPI` per i dettagli

## Logica ASL

|  ASL+  |   ASL Legacy  | Esempi             |
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

Dal calcolo logico sono possibili solo due risultati : `0` o `1`

## Definizione di metodo ASL

1. Definire un metodo

   ```swift
   Method (TEST)
   {
       ...
   }
   ```

2. Definire un metodo che contenga 2 parametri e applicare le variabili locali`Local0` ~ `Local7`

   I numeri dei parametri sono impostati come `0`

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

   Se non si definisce `Serialized` o `NotSerialized`, il valore predefinito sarà `NotSerialized`

   ```swift
   Method (MADD, 2, Serialized)
   {
       Local0 = Arg0
       Local1 = Arg1
       Local0 += Local1
       Return (Local0)
   }
   ```

   È un concetto molto simile alla `sincronizzazione multi-thread`. In altre parole, solo un'istanza può essere presente nella memoria quando il metodo è dichiarato come `Serialized`. Normalmente l'applicazione crea un oggetto, ad esempio:

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

È facile acquisire il nome e la versione del sistema operativo corrente quando si applica `_OSI`. Ad esempio, potremmo applicare una patch specifica per Windows o MacOS.

`_OSI` richiede una stringa, la stringa deve essere prelevata dalla tabella sottostante.

|                 OS                  |      String      |
| :---------------------------------------: | :--------------: |
|                   macOS                   |    `"Darwin"`    |
| Linux<br/>(Including OS based on Linux kernel) |    `"Linux"`     |
|                  FreeBSD                  |   `"FreeBSD"`    |
|                  Windows                  | `"Windows 20XX"` |

> In particolare ， diverse versioni di Windows richiedono una stringa univoca ， è possibile consultare il documento ufficiale di Microsoft ：
>
> <https://docs.microsoft.com/en-us/windows-hardware/drivers/acpi/winacpi-osi>

Quando la stringa di `_OSI` corrisponde al sistema corrente, restituisce `1`, la condizione `If` è valida.

```swift
If (_OSI ("Darwin")) /* giudica se il sistema attuale è macOS */
```

### `_STA` (Stato)

**Attenzione⚠️: Esistono due tipi di `_STA`，non si deve confondere `_STA` con `PowerResource`！！！**

5 tipi di bit possono essere restituiti dal metodo `_STA`, qui sotto sono indicate le spiegazioni:

| Bit   | Explanations                           |
| :-----: | :----------------------------- |
| Bit [0] | Se il dispositivo è connesso.                   |
| Bit [1] | Seil dispositivo è abilitato e sta decodificando le sue risorse. |
| Bit [2] | Se il dispositivo deve essere mostrato nell'interfaccia utente.         |
| Bit [3] | Se il dispositivo funziona correttamente (azzerato se il dispositivo fallisce le sue operazioni di diagnostica).            |
| Bit [4] | Se la batteria è presente.             |

Dobbiamo convertire questi bit da esadecimale a binario. "0x0F" viene convertito in `1111`, che significa "completamente abilitato" (i primi quattro bit); mentre `Zero` significa "completamente disabilitato".

Incontriamo anche `0x0B`, `0x1F`. `1011` è una forma binaria di `0x0B`, il che significa che il dispositivo è abilitato e non autorizzato a decodificare le sue risorse. `0X0B` spesso usato in **`SSDT-PNLF`**. `0x1F` (`11111`) sarà presente solo quando sarà rilevato un controller di batteria di un laptop, l'ultimo bit è utilizzato per notfiicare al Control Method Battery Device (Metodo di controllo del dispositivo della batteria) `PNP0C0A` che la batteria è presente.

> Ancora una parola di `_STA` e di` PowerResource`
>
> `_STA` da` PowerResource` restituisce solo` One` o` Zero`. Leggere `Specifiche ACPI` per i dettagli.

### `_CRS` (Impostazioni correnti delle risorse)
`_CRS` restituisce un` Buffer`, è spesso utilizzato per acquisire dispositivi touch '`GPIO Pin`,` APIC Pin` per controllare la modalità di interruzione del dispositivo.


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

### Controllo dei rami `If` e `Switch`

#### `If`

   I seguenti codici controllano se il sistema è `Darwin`, se sì allora `OSYS = 0x2710`

   ```swift
   If (_OSI ("Darwin"))
   {
       OSYS = 0x2710
   }
   ```

#### `ElseIf`, `Else`

   I seguenti codici controllano se il sistema è `Darwin`, se non lo è allora viene controllato se è `Linux`, altrimenti `OSYS = 0x07D0`

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

`For` mostrato sopra e `While` sotto sono equivalenti

```swift
Local0 = 0
While (Local0 < 8)
{
    Local0++
}
```

## Riferimento `Esterno`

|    Tipo di riferimento    | Riferimento dell'SSDT esterno| riferito    |
| :------------: | :------------: |  :------------------------------------ |
|   UnknownObj    | `External (\_SB.EROR, UnknownObj`             | (evitarne l'utilizzo)                          |
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

> DDBHandleObj è, niente discussioni

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

Questi sono codici estratti da **`SSDT-I2CxConf`**. Quando si avvia un sistema non MacOS, se è presente XSCN in I2C0 (in precedenza SSCN, è stato rinominato XSCN, creare una nuova funzione e utilizzare il nome originale SSCN), quindi restituire il valore restituito dalla funzione originale

## Conclusione
Spero che questo articolo ti aiuti nella modifica di un DSDT / SSDT.
