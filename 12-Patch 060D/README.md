## Panoramica

- `_PRW` definisce un metodo di attivazione del componente. Il `Return` è un pacchetto composto da 2 o più byte. Per i dettagli su `_PRW`, fare riferimento alla specifica ACPI.
- Ci sono alcuni componenti il ​​cui `_PRW` è in conflitto con macOS, il che fa sì che la macchina si riattivi immediatamente dopo che è andata a dormire con successo. Per risolvere il problema, è necessario applicare patch a questi componenti. Questi componenti `_PRW` Il primo byte del pacchetto di dati è `0D` o `6D`. Pertanto, questo tipo di patch è chiamato `0D / 6D patch`, chiamato anche` second wake patch`, chiamato anche `sleep and wake patch`. Per comodità di descrizione, viene indicato collettivamente come "patch 0D / 6D" di seguito.
- `_PRW` Il secondo byte del pacchetto di dati è principalmente `03` o `04`. La correzione di questo byte a `0` completa la `patch 0D / 6D`.
- Diverse macchine possono definire `_PRW` in modi diversi, e anche il contenuto e la forma dei loro pacchetti di dati possono essere diversificati. L'attuale `patch 0D / 6D` dovrebbe dipendere dalla situazione specifica. Vedere la descrizione di seguito.
- Ci aspettiamo che le versioni successive di OpenCore risolvano il problema `0D / 6D`.

### Parti che potrebbero richiedere patch `0D / 6D`

- Dispositivo USB

  - `ADR` indirizzo: `0x001D0000`, nome parte:` EHC1` [prima della 6a generazione]
  - `ADR` indirizzo: `0x001A0000`, nome parte:` EHC2` [prima della 6a generazione]
  - `ADR` indirizzo: `0x00140000`, nome parte:` XHC`, `XHCI`,` XHC1` ecc.
  - `ADR` indirizzo: `0x00140001`, nome parte:` XDCI`
  - `ADR` indirizzo: `0x00140003`, nome parte:` CNVW`

- Ethernet

  - prima della 6a generazione, indirizzo `ADR`:` 0x00190000`, nome della parte: `GLAN`,` IGBE`, ecc.
  - 6a generazione e successive, indirizzo `ADR`:` 0x001F0006`, nome della parte: `GLAN`,` IGBE` ecc.
  
- Scheda Audio integrata

  - Prima della 6a generazione, indirizzo `ADR`:` 0x001B0000`, nome della parte: `HDEF`,` AZAL` ecc.
  - 6a generazione e successive, indirizzo `ADR`:` 0x001F0003`, nome della parte: `HDAS`,` AZAL` ecc.

  **Nota 1**: Il metodo per confermare le parti precedenti cercando il nome non è affidabile. Il metodo affidabile è cercare `indirizzo ADR`, `_PRW`.

  **Nota 2**: Le macchine appena rilasciate potrebbero avere nuove parti che richiedono `0D / 6D patch`.

## La diversità di `_PRW` e il corrispondente metodo di patch

- 
    `Name type` 

  ```Swift Name (_PRW, Package (0x02) 
    { 
        0x0D, /* may be 0x6D */ 
        0x03, /* may be 0x04 */ 
        . .. 
    }) 
  ```

Questo tipo di `0D/6D patch` è adatto per modificare `0x03` (or `0x04`) to `0x00 utilizzando il metodo di ridenominazione binario.

- Name0D renamed .plist 
  - `Name0D-03` to` 00` 
  - `Name0D-04` to` 00` 
  
- Name6D renamed .plist 
  - `Name6D-03` to` 00` 
  - `Name6D-04` to `00` 

- uno di `Method type`: `GPRW(UPRW)` 

```Swift 

  ```Swift 
    Method (_PRW, 0, NotSerialized) 
    { 
      Return (GPRW (0x6D, 0x04)) /* or Return ( UPRW (0x6D, 0x04)) */ 
    } 
  ``` 
  - ***SSDT-GPRW*** (binary renamed data in the patch file) 
  - ***SSDT-UPRW*** (binary renamed data in the patch file ) -`Method type`

- Metodo : `Scope` 

  ```Swift 
    Scope (_SB.PCI0.XHC) 
    {
        Method (_PRW, 0, NotSerialized) 
        { 
            ... 
            If ((Local0 == 0x03)) 
            { 
                Return (Package (0x02) 
                { 
                    0x6D, 
                    0x03 
                }) 
            } 
            If ((Local0 == One)) 
            { 
                Return (Package (0x02) ) 
                { 
                    0x6D, 
                    One 
                }) 
            } 
            Return (Package (0x02) 
            { 
                0x6D, 
                Zero
            }) 
        } 
    } 
  ``` 

Questa situazione non è comune. Per il caso dell'esempio, utilizzare il nome binario per modificare il nome ***Name6D-03 to 00***. Prova altre forme di contenuto da solo.

- `Name type`, `Method type` metodo misto

Per la maggior parte delle macchine TP, le parti coinvolte nella `0D/6D patch` hanno sia `Name type` and `Method type`. Usa i rispettivi tipi di patch. **Nota che** La patch di ridenominazione binaria non può essere utilizzata in modo improprio. Alcuni componenti `_PRW` che non richiedono`0D/6D patch`  possono anche essere `0D` or `6D`.  Per evitare questo tipo di errore, il file `System DSDT` dovrebbe essere estratto per verifica e verifica.

### Precauzioni

- Il metodo descritto in questo articolo è applicabile a Hotpatch.
- Se usi un cambio di nome binario, dovresti estrarre il file `System DSDT` per la verifica.
- La patch `06 / 0D` della macchina HP è speciale, fare riferimento a`12-2-HP Special 060D Patch`per i dettagli
