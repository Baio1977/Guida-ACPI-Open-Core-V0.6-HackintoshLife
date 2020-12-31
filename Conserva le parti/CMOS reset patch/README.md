# Patch di reset CMOS

## Descrizione

- Alcune macchine mostreranno **"Boot Self-Test Error "** quando si spegne o si riavvia a causa del reset del CMOS.
- Quando si usa Clover, il controllo `ACPI\FixRTC` risolverà il problema di cui sopra.
- Quando si utilizza OpenCore, viene fornita ufficialmente la seguente soluzione, vedere ***Sample.plist***.
  - Installare **RTCMemoryFixup.kext**
  - Patch `Kernel\Patch`: **__ZN11BCM5701Enet14getAdapterInfoEv**
- Questo capitolo fornisce un metodo di patch SSDT per risolvere il problema di cui sopra. Questa patch SSDT è essenzialmente un'imitazione dell'RTC, vedi il ``Prefix Variable Method'' e ``Impersonating Devices''.

## Soluzione

- Rimuovere il **numero di interruzione** da **RTC `PNP0B00`** parte `_CRS`.

  ``Swift
  Dispositivo (RTC)
  {
      Nome (_HID, EisaId ("PNP0B00"))
      Nome (_CRS, ResourceTemplate ()
      {
          IO (Decodifica16,
              0x0070,
              0x0070,
              0x01,
              0x08, /* o 0x02, prova per essere sicuri */
              )
          IRQNoFlags () /* Cancellare questa riga */
              {8} /* Cancellare questa riga */
      })
  }
  ```

## Patch: SSDT-RTC0-NoFlags

- Disattivare la parte originale: **RTC**
  - Se **RTC** non esiste ```_STA```, disattivare **RTC** con le seguenti modalità.
  
    ````Swift
    Esterno (_SB.PCI0.LPCB.RTC, DeviceObj)
    Ambito di applicazione (_SB.PCI0.LPCB.RTC)
    RTC) {
        Metodo (_STA, 0, non serializzato)
        {
            Se (_OSI ("Darwin"))
            {
                Ritorno (Zero)
            }
            Altrimenti
            {
                Ritorno (0x0F)
            }
        }
    }
    ```
  
  - Se `_STA` è presente in **RTC**, usare il metodo delle variabili preimpostate per disabilitare **RTC**. La variabile nell'esempio è `STAS` e dovrebbe essere usata con attenzione all'effetto di `STAS` su altri dispositivi, componenti.
  
    ````Swift
    Esterno (STAS, FieldUnitObj)
    Ambito di applicazione (\)
    {
        Se (_OSI ("Darwin"))
        {
            STAS = 2
        }
    }
    ```

- Contraffazione **RTC0** , vedi campione.

## Nota

- Il nome del dispositivo e il percorso nella patch devono essere identici all'ACPI originale.

- Se la macchina stessa ha disattivato l'RTC per qualche motivo, per funzionare correttamente è necessaria un'impersonificazione dell'RTC. In questo caso c'è un errore di autotest di avvio "**", basta rimuovere il numero di interrupt della patch di impersonazione.

  ````Swift
    IRQNoFlags () /* cancellare questa riga */
        {8} /* Cancellare questa riga */
  ```

**Grazie** @Chic Cheung, @Noctis per tutto il vostro duro lavoro!

Tradotto con www.DeepL.com/Translator (versione gratuita)
