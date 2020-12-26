# RTC contraffatto

## Sommario

Per alcune schede madri della serie 300, il dispositivo `RTC` è disabilitato per impostazione predefinita e il valore restituito di` _STA` non può essere controllato dalla variabile `STAS` condivisa con` AWAC` per abilitare il dispositivo RTC tradizionale, risultando in *** `SSDT-AWAC` *** Non può avere effetto, quindi per forzare l'abilitazione del dispositivo "RTC", dobbiamo falsificare un "RTC0".

## Istruzioni

> Case

```Swift
Device (RTC)
{
  Name (_HID, EisaId ("PNP0B00"))
  Name (_CRS, ResourceTemplate ()
  {
      IO (Decode16,
          0x0070,
          0x0070,
          0x01,
          0x08,
         )
      IRQNoFlags ()
          {8}
  })
  Method (_STA, 0, NotSerialized)
  {
    Return (0);
  }
}
```

> Quanto sopra è il caso in cui il dispositivo "RTC" è disabilitato. Il metodo di contraffazione è il seguente:

```swift
DefinitionBlock ("", "SSDT", 2, "ACDT", "RTC0", 0)
{
    External (_SB_.PCI0.LPCB, DeviceObj)

    Scope (_SB.PCI0.LPCB)
    {
        Device (RTC0)
        {
            Name (_HID, EisaId ("PNP0B00"))
            Name (_CRS, ResourceTemplate ()
            {
                IO (Decode16,
                    0x0070,
                    0x0070,
                    0x01,
                    0x08,
                    )
                IRQNoFlags ()
                    {8}
            })
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (0);
                }
            }
        }
    }
}
```

## Nota

-Questo componente è valido solo per le schede madri della serie 300.
-Questo componente viene utilizzato solo quando *** `SSDT-AWAC` *** non viene utilizzato e il valore di ritorno del metodo` _STA` del dispositivo `RTC` nell'originale` ACPI` è `0`.
-Il percorso del dispositivo della patch di esempio è "LPCB", modificalo in base alla situazione attuale.
