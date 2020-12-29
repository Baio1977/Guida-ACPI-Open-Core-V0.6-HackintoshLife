# Patch di ripristino CMOS

## Descrizione

- Alcune macchine appariranno **`Errore di autotest all'accensione`** all'arresto o al riavvio, causato dal ripristino del CMOS.
- Quando si utilizza Clover, selezionare `ACPI \ FixRTC` per risolvere i problemi di cui sopra.
- Quando si utilizza OpenCore, vengono fornite ufficialmente le seguenti soluzioni, vedere ***Sample.plist***:
  - Installa **RTCMemoryFixup.kext**
  - `Kernel \ Patch` patch: **__ ZN11BCM5701Enet14getAdapterInfoEv**
- Questo capitolo fornisce un metodo di patch SSDT per risolvere i problemi di cui sopra. Questa patch SSDT è essenzialmente un RTC contraffatto, vedere `Preset Variable Method` e `Counterfeit Equipment`.

## soluzione

- Elimina il **numero di interrupt** del **RTC `PNP0B00`** componente` _CRS`.

  `` Rapido
  Dispositivo (RTC)
  {
      Nome (_HID, EisaId ("PNP0B00"))
      Nome (_CRS, ResourceTemplate ()
      {
          IO (Decode16,
              0x0070,
              0x0070,
              0x01,
              0x08, / * o 0x02, determinato sperimentalmente * /
              )
          IRQNoFlags () / * Elimina questa riga * /
              {8} / * Elimina questa riga * /
      })
  }
  `` `

## Patch: SSDT-RTC0-NoFlags

- Parti originali disabilitabili: **RTC**
  - Se **RTC** non esiste `_STA`, utilizzare il seguente metodo per disabilitare **RTC**:
  
    `` Rapido
    Esterno (_SB.PCI0.LPCB.RTC, DeviceObj)
    Ambito (_SB.PCI0.LPCB.RTC)
    {
        Metodo (_STA, 0, NotSerialized)
        {
            Se (_OSI ("Darwin"))
            {
                Ritorno (zero)
            }
            Altro
            {
                Ritorno (0x0F)
            }
        }
    }
    `` `
  
  - Se **RTC** esiste `_STA`, utilizza il metodo delle variabili preimpostate per disabilitare **RTC**. La variabile nell'esempio è `STAS` e si dovrebbe prestare attenzione all'influenza di `STAS` su altre apparecchiature e componenti quando lo si utilizza.
  
    `` Rapido
    Esterno (STAS, FieldUnitObj)
    Scopo (\)
    {
        Se (_OSI ("Darwin"))
        {
            STAS = 2
        }
    }
    `` `

- Contraffazione **RTC0**, vedi catalogo.

## Nota

- Il nome del dispositivo e il percorso nella patch dovrebbero essere coerenti con l'ACPI originale.

- Se la macchina stessa disabilita RTC per qualche motivo, deve falsificare RTC per funzionare normalmente. In questo caso, viene visualizzato **`Errore di autoverifica all'accensione`**, basta eliminare il numero di interruzione della patch contraffatta:

  `` Rapido
    IRQNoFlags () / * Elimina questa riga * /
        {8} / * elimina questa riga * /
  `` `

**Grazie** @Chic Cheung, @Noctis per il tuo duro lavoro!
