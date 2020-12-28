# Patch del sistema operativo

## Descrizione

- **Le patch del sistema operativo** vengono utilizzate per rimuovere le restrizioni del sistema su determinati componenti. In circostanze normali, **"non consigliato"** usa **patch del sistema operativo**. Per i componenti che non possono funzionare normalmente a causa delle limitazioni del sistema, le patch devono essere personalizzate in base alle condizioni specifiche di ACPI.

-Per una breve descrizione delle **patch del sistema operativo**, vedere l'appendice "Origine delle patch del sistema operativo".

## Rinomina

- **OSID to XSID**

  ```text
  Find:     4F534944
  Replace:  58534944
  ```

- **OSIF to XSIF**

  ```text
  Find:     4F534946
  Replace:  58534946
  ```

- **_OSI to XOSI**

  ```text
  Find:     5F4F5349
  Replace:  584F5349
  ```
  Cerca "OSI" nel DSDT originale. Se ci sono altri campi contenenti "OSI" oltre alla funzione "_OSI" (come "OSID" di notebook Dell, "OSIF" di alcuni ThinkPad e notebook Lenovo), devi prima aggiungere il diritto Questi includono la ridenominazione dei campi "OSI" (come "OSID in XSID", "OSIF in XSIF") e quindi l'aggiunta di "_OSI in XOSI".
     Se non ci sono altri campi che contengono "OSI" eccetto la funzione "_OSI", aggiungi direttamente "_OSI a XOSI".

  ## Patch: *** SSDT-OC-XOSI ***

```Swift
Method(XOSI, 1)
{
    If (_OSI ("Darwin"))
    {
        If (Arg0 == //"Windows 2009"  //  = win7, Win Server 2008 R2
                    //"Windows 2012"  //  = Win8, Win Server 2012
                    //"Windows 2013"  //  = win8.1
                    "Windows 2015"  //  = Win10
                    //"Windows 2016"  //  = Win10 version 1607
                    //"Windows 2017"  //  = Win10 version 1703
                    //"Windows 2017.2"//  = Win10 version 1709
                    //"Windows 2018"  //  = Win10 version 1803
                    //"Windows 2018.2"//  = Win10 version 1809
                    //"Windows 2018"  //  = Win10 version 1903
            )
        {
            Return (0xFFFFFFFF)
        }
        Else
        {
            Return (Zero)
        }
    }
    Else
    {
        Return (_OSI (Arg0))
    }
}
```

### Uso

-**Valore massimo**

  Per un singolo sistema, i parametri del sistema operativo possono essere impostati al valore massimo consentito da DSDT. Ad esempio, se il valore massimo di DSDT è `Windows 2018`, impostare `Arg0 ==` Windows 2018 ``. Di solito `Arg0 ==` Windows 2013 `` e versioni successive possono rimuovere le restrizioni del sistema sui componenti.

  **Nota**: **la patch del sistema operativo** non è consigliata per un singolo sistema.

- **Valore di corrispondenza**

  Per i sistemi doppi, i parametri del sistema operativo impostati devono essere coerenti con la versione del sistema Windows. Ad esempio: il sistema Windows è win7, impostare Arg0 == `Windows 2009`.

## Precauzioni

  - Il `Metodo` di alcune macchine utilizza un nome simile a` _OSI` (come `OSID` di` dell`). Quando si trova in `_SB` (meno di 4 caratteri) e viene visualizzato il percorso completo, i suoi dati binari e `_OSI` è lo stesso e genera un errore quando il nome viene modificato dal sistema operativo (da `_OSI a XOSI`). In questo caso, è necessario rinominarlo in qualcos'altro (come `OSID in XSID`) prima di` _OSI in XOSI` per evitare errori.

## Allegato: l'origine delle patch del sistema operativo

- Quando il sistema viene caricato, `_OSI` di ACPI riceverà un parametro. Sistemi differenti hanno parametri differenti e ACPI esegue comandi differenti. Ad esempio, se il sistema è **Win7**, questo parametro è `Windows 2009` e il sistema è **Win8**, questo parametro è `Windows 2012`. Ad esempio:

  ```Swift
  If ((_OSI ("Windows 2009") || _OSI ("Windows 2013")))
  {
      OperationRegion (PCF0, SystemMemory, 0xF0100000, 0x0200)
      Field (PCF0, ByteAcc, NoLock, Preserve)
      {
          HVD0,   32,
          Offset (0x160),
          TPR0,   8
      }
      ...
  }
  ...
  Method (_INI, 0, Serialized)  /* _INI: Initialize */
  {
      OSYS = 0x07D0
      If (CondRefOf (\_OSI))
      {
          If (_OSI ("Windows 2001"))
          {
              OSYS = 0x07D1
          }

          If (_OSI ("Windows 2001 SP1"))
          {
              OSYS = 0x07D1
          }
          ...
          If (_OSI ("Windows 2013"))
          {
              OSYS = 0x07DD
          }

          If (_OSI ("Windows 2015"))
          {
              OSYS = 0x07DF
          }
          ...
      }
  }
  ```

ACPI definisce anche `OSYS`, la relazione tra `OSYS` e i parametri precedenti è la seguente:

- `OSYS = 0x07D9`: sistema Win7, ovvero `Windows 2009`
   - `OSYS = 0x07DC`: sistema Win8, ovvero `Windows 2012`
   - `OSYS = 0x07DD`: sistema Win8.1, ovvero `Windows 2013`
   - `OSYS = 0x07DF`: sistema Win10, ovvero `Windows 2015`
   - `OSYS = 0x07E0`: Win10 1607, che è `Windows 2016`
   - `OSYS = 0x07E1`: Win10 1703, che è `Windows 2017`
   - `OSYS = 0x07E1`: Win10 1709, che è `Windows 2017.2`
   -`OSYS = 0x07E2`: Win10 1803, che è `Windows 2018`
   - `OSYS = 0x07E2`: Win10 1809, che è `Windows 2018.2`
   - `OSYS = 0x ???? `: Win10 1903, che è` Windows 2019`
  -  ...

-Quando il sistema caricato non viene riconosciuto da ACPI, a `OSYS` viene assegnato un valore predefinito. Questo valore varia da macchina a macchina. Alcuni rappresentano `Linux`, altri `Windows2003` e altri hanno altri valori.

-Diversi sistemi operativi supportano hardware diverso.Ad esempio, i dispositivi I2C sono supportati solo da `Win8`.

-Durante il caricamento di macOS, i parametri accettati da `_OSI` non saranno riconosciuti da ACPI e a` OSYS` vengono forniti i valori predefiniti. Questo valore predefinito è solitamente inferiore al valore richiesto da Win8, ovviamente I2C non può funzionare. Ciò richiede una patch per correggere questo errore e la patch del sistema operativo proviene da questo.

-Alcuni altri componenti possono anche essere correlati a `OSYS`.
