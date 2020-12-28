# Proibisci dispositivi PCI

## Descrizione

- In alcuni casi, vogliamo disabilitare un dispositivo PCI. Ad esempio, la scheda SD del bus PCI di solito non è in grado di guidare, anche se è pilotata, difficilmente può funzionare normalmente. In questo caso, possiamo disabilitare questo dispositivo personalizzando la patch SSDT.
- Questi dispositivi hanno le seguenti caratteristiche:
  - È un **dispositivo figlio** di un dispositivo genitore PCI ** **
  - **Il dispositivo genitore** definisce alcune variabili di tipo `PCI_Config` **o` SystemMemory`**, dove il bit `D4` dei dati di offset 0x55 è l'attributo operativo del dispositivo
  - **Dispositivo secondario** Indirizzo: `Nome (_ADR, Zero)`

## Nome del dispositivo

- Il nome del **dispositivo figlio** della macchina più recente è **`PXSX`**; il nome del **dispositivo genitore** è **`RP01`**, **`RP02`**, **`RP03`** ... Aspetta.
- Il nome delle prime macchine Thinkpad **dispositivo figlio** è **`SLOT`** o **nessuno**; **il nome del dispositivo principale** è **`EXP1`**, **` EXP2`**, **`EXP3`** ... ecc.
- Altre macchine possono avere altri nomi.
- La scheda di rete wireless incorporata del notebook appartiene a tale dispositivo.

## SSDT disabilita l'esempio di patch

- La scheda SD di Dell Latitude5480 è un dispositivo PCI, il percorso del dispositivo: `_SB.PCI0.RP01.PXSX`

- File di patch: ***SSDT-RP01.PXSX-disbale***

```Swift
  External (_SB.PCI0.RP01, DeviceObj)
  Scope (_SB.PCI0.RP01)
  {
      OperationRegion (DE01, PCI_Config, 0x50, 0x01)
      Field (DE01, AnyAcc, NoLock, Preserve)
      {
              , 4,
          DDDD, 1
      }
  //possible start
  Method (_STA, 0, Serialized)
  {
  If (_OSI ("Darwin"))
  {
  Return (Zero)
  }
  }
  //possible end
  }
  Scope (\)
  {
      If (_OSI ("Darwin"))
      {
          \_SB.PCI0.RP01.DDDD = One
      }
  }
  ```

## Nota

- Se il **dispositivo genitore** ha più **dispositivi figlio**, **utilizzare questo metodo con cautela**.
-Quando si utilizza, sostituire `RP01` nell'esempio con il nome del **dispositivo genitore** del dispositivo disabilitato, fare riferimento all'esempio.
- Se il dispositivo disabilitato include già il metodo `_STA`, ignora il contenuto da *possibile inizio* a * possibile fine *, vedere i commenti di esempio.
- Questo metodo non rilascia il dispositivo dal canale PCI.

## Grazie

-@哞🌈
