# Sensore di luce ambientale contraffatto

## Sommario

A partire da `macOS Catalina`, i dispositivi notebook devono contraffare il sensore di luce ambientale` ALS0` per ottenere la conservazione della luminosità e la regolazione automatica della luminosità. Va notato che solo le macchine con hardware del sensore di luce ambientale reale possono ottenere una vera regolazione automatica della luminosità.

## Istruzioni

Ci sono due situazioni, l'ACPI originale ha un'interfaccia del dispositivo del sensore di luce ambientale e l'interfaccia del dispositivo del sensore della luce ambientale non esiste. Prima cerca "ACPI0008" nell'originale "ACPI". Se è possibile trovare il dispositivo in questione, solitamente "ALSD", significa che è presente un'interfaccia del dispositivo del sensore di luce ambientale, altrimenti significa che non è presente un'interfaccia del dispositivo del sensore della luce ambientale.

### Esiste un'interfaccia del dispositivo con sensore di luce ambientale

> Case

```swift
Device (ALSD)
{
  Name (_HID, "ACPI0008" /* Ambient Light Sensor Device */)  // _HID: Hardware ID
  Method (_STA, 0, NotSerialized)  // _STA: Status
  {
    If ((ALSE == 0x02))
    {
      Return (0x0B)
    }

    Return (Zero)
  }

  Method (_ALI, 0, NotSerialized)  // _ALI: Ambient Light Illuminance
  {
    Return (((LHIH << 0x08) | LLOW))
  }

  Name (_ALR, Package (0x05)  // _ALR: Ambient Light Response
  {
    Package (0x02)
    {
      0x46,
      Zero
    },

    Package (0x02)
    {
      0x49,
      0x0A
    },

    Package (0x02)
    {
      0x55,
      0x50
    },

    Package (0x02)
    {
      0x64,
      0x012C
    },

    Package (0x02)
    {
      0x96,
      0x03E8
    }
  })
}
```

In questo caso, puoi usare una variabile preimpostata per fare in modo che il metodo `_STA` restituisca` 0x0B` per abilitare il dispositivo sensore ambientale esistente `ACPI` originale, il metodo è il seguente:

```swift
DefinitionBlock ("", "SSDT", 2, "OCLT", "ALSD", 0)
{
    External (ALSE, IntObj)

    Scope (_SB)
    {
        Method (_INI, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                ALSE = 2
            }
        }
    }
}
```

### Non è presente l'interfaccia del dispositivo del sensore di luce ambientale

In questo caso, dobbiamo solo simulare un dispositivo `ALS0`, il metodo è il seguente:

```swift
DefinitionBlock ("", "SSDT", 2, "ACDT", "ALS0", 0)
{
    Scope (_SB)
    {
        Device (ALS0)
        {
            Name (_HID, "ACPI0008")
            Name (_CID, "smc-als")
            Name (_ALI, 0x012C)
            Name (_ALR, Package (0x01)
            {
                Package (0x02)
                {
                    0x64,
                    0x012C
                }
            })
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }
        }
    }
}
```

## Nota

-I dispositivi contraffatti sono sicuri ed efficaci in ogni caso, anche se c'è un'interfaccia del dispositivo sensore di luce ambientale nell'originale `ACPI`, puoi contraffare direttamente` ALS0`.
-La "variabile" modificata può esistere in più posizioni. Dopo che è stata modificata, potrebbe influenzare altri componenti mentre si ottengono i risultati attesi.
-Quando è presente un sensore di luce ambientale nell'originale "ACPI", il suo nome potrebbe non essere "ALSD", come "ALS0", ma finora non è stato trovato nessun altro nome.
-Quando è presente un dispositivo sensore di luce ambientale nell'originale "ACPI", se si desidera utilizzare il metodo della variabile preimpostata per abilitarlo forzatamente, è necessario prestare attenzione alla presenza di "_SB.INI" nell'originale "ACPI". In tal caso, utilizzare il falso metodo "ALS0".
