1006 / 5000
Risultati della traduzione
# Sequenza di caricamento SSDT

- In generale, applichiamo SSDT per una macchina specifica (il suo DSDT o altri SSDT), la sequenza di caricamento dell'ACPI originale ha una priorità maggiore rispetto alle patch SSDT che abbiamo creato. Pertanto, le patch SSDT ** non hanno ** una sequenza di caricamento in "Aggiungi".
- C'è un'eccezione. Se SSDT definisce un "dispositivo" e utilizza anche "Scope" per citare il "dispositivo" da un altro SSDT, la sequenza è ** obbligatoria **.

## Esempi

- Patch 1 ： ** SSDT-XXXX-1.aml **
  
  `` Rapido
  Esterno (_SB.PCI0.LPCB, DeviceObj)
  Ambito (_SB.PCI0.LPCB)
  {
      Dispositivo (XXXX)
      {
          Nome (_HID, EisaId ("ABC1111"))
      }
  }
  `` `
  
- Patch 2 ： ** SSDT-XXXX-2.aml **

  `` Rapido
  Esterno (_SB.PCI0.LPCB.XXXX, DeviceObj)
  Ambito (_SB.PCI0.LPCB.XXXX)
  {
        Metodo (YYYY, 0, NotSerialized)
       {
           /* fare niente */
       }
    }
  `` `
  
- "Aggiungi" sequenza di caricamento

  `` XML
  Articolo 1
            percorso <SSDT-XXXX-1.aml>
  Articolo 2
            percorso <SSDT-XXXX-2.aml>
