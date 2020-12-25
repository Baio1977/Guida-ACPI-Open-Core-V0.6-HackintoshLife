auto_awesome
Traduci da: Inglese
450 / 5000
Risultati della traduzione
# Sequenza di caricamento SSDT

-In generale, applichiamo SSDT per una macchina specifica (il suo DSDT o altri SSDT), la sequenza di caricamento dell'ACPI originale ha una priorità maggiore rispetto alle patch SSDT che abbiamo creato. Pertanto, le patch SSDT ** non hanno ** un sequenza di caricamento sotto "Aggiungi".
-C'è un'eccezione: se SSDT definisce un `dispositivo`, e utilizza anche` Scope` per citare il `dispositivo` da un altro SSDT, la sequenza è ** obbligatoria **.

## Esempi

- Patch 1：**SSDT-XXXX-1.aml**
  
  ```Swift
  External (_SB.PCI0.LPCB, DeviceObj)
  Scope (_SB.PCI0.LPCB)
  {
      Device (XXXX)
      {
          Name (_HID, EisaId ("ABC1111"))
      }
  }
  ```
  
- Patch 2：**SSDT-XXXX-2.aml**

  ```Swift
  External (_SB.PCI0.LPCB.XXXX, DeviceObj)
  Scope (_SB.PCI0.LPCB.XXXX)
  {
        Method (YYYY, 0, NotSerialized)
       {
           /* do nothing */
       }
    }
  ```
  
- `Add` loading sequence

  ```XML
  Item 1
            path    <SSDT-XXXX-1.aml>
  Item 2
            path    <SSDT-XXXX-2.aml>
  ```
