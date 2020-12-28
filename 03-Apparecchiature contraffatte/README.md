# Attrezzature contraffatte

## Sommario

Tra le tante patch `SSDT`, un numero considerevole di patch può essere classificato come patch di dispositivo contraffatto, come ad esempio:

- Alcuni dispositivi non esistono in ACPI, ma il sistema MAC ne ha bisogno. La descrizione corretta di questi dispositivi tramite le patch può caricare i driver di dispositivo. Ad esempio `05-2-PNLF Injection Method`, `Add Missing Parts`, `Counterfeit Ethernet`, ecc.
- Problemi CE. Come "contraffazione CE".
- Per alcuni dispositivi speciali, il metodo per vietare la contraffazione del dispositivo originale ci porterà convenienza nel lavoro di regolazione del cerotto. Come `Metodo patch OCI2C-TPXX`.
- Un certo dispositivo è disabilitato per qualche motivo, ma il sistema MAC ha bisogno che funzioni. Vedi esempi di `questo capitolo`.
- Nella maggior parte dei casi, anche utilizzando "Rinomina binaria e variabili preimpostate" è possibile abilitare il dispositivo.

## Attrezzatura contraffatta

- Caratteristiche
  
  - Il dispositivo contraffatto esiste già in ACPI e il codice è relativamente breve, poco e indipendente.
  
  - Il dispositivo originale ha il canonico `_HID` o` _CID`.
  - Anche se il dispositivo originale non è disabilitato, l'utilizzo di una patch del dispositivo contraffatto non causerà danni ACPI.
  
- Richiesta

  - Il nome del dispositivo contraffatto è **diverso** dal nome del dispositivo originale di ACPI.

  - Il contenuto della patch è **uguale** al contenuto principale del dispositivo originale.

  - La parte `_STA` della patch contraffatta dovrebbe includere quanto segue per garantire che il sistema Windows utilizzi l'ACPI originale.

    ```Swift
        Method (_STA, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                ...
                Return (0x0F)
            }
            Else
            {
                Return (Zero)
            }
        }
    ```
  
  -Esempio
     - ***SSDT-RTC0*** - RTC contraffatto

       -Nome dispositivo originale: RTC
       -_HID: PNP0B00

       **Nota**: il nome di `LPCB` dovrebbe essere coerente con il nome ACPI originale.
