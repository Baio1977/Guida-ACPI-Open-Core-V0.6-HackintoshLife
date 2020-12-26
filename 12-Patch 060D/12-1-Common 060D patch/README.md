Patch # 0D / 6D

## Panoramica

-`_PRW` definisce il metodo di attivazione di un componente. Il "Return" è un pacchetto composto da 2 o più byte. Per i dettagli su "_PRW", fare riferimento alla specifica ACPI.
-Ci sono alcuni componenti il ​​cui `_PRW` è in conflitto con macOS, il che fa sì che la macchina si riattivi non appena si dorme con successo. Per risolvere il problema, è necessario applicare patch a questi componenti. Questi componenti "_PRW" Il primo byte del pacchetto di dati è "0D" o "6D". Pertanto, questo tipo di patch è chiamato `0D / 6D patch`, chiamato anche` seconda patch di attivazione`, anche chiamato `sleep-and-wake patch`. Per comodità di descrizione, i seguenti elementi vengono indicati collettivamente come "patch 0D / 6D".
-Il secondo byte del pacchetto di dati "_PRW" è principalmente "03" o "04". La correzione di questo byte a "0" completa la "patch 0D / 6D".
-Diverse macchine possono definire metodi differenti per `_PRW`, e il contenuto e la forma dei pacchetti di dati possono essere diversificati. L'attuale "patch 0D / 6D" dipende dalla situazione specifica. Vedere la descrizione di seguito.
-Ci aspettiamo che le versioni successive di OpenCore risolvano il problema "0D / 6D".

### Parti che potrebbero richiedere la "patch 0D / 6D"

-Dispositivo USB
  -`ADR` indirizzo: `0x001D0000`, nome parte:` EHC1`.
  -`ADR` indirizzo: `0x001A0000`, nome parte:` EHC2`.
  -`ADR` indirizzo: `0x00140000`, nome parte:` XHC`, `XHCI`,` XHC1` ecc.
  -`ADR` indirizzo: `0x00140001`, nome parte:` XDCI`.
  -`ADR` indirizzo: `0x00140003`, nome parte:` CNVW`.

-Ethernet

  -Prima della 6a generazione, indirizzo `ADR`:` 0x00190000`, nome della parte: `GLAN`,` IGBE`, ecc.
  -6a generazione e successive, indirizzo `ADR`:` 0x001F0006`, nome della parte: `GLAN`,` IGBE` ecc.

-Scheda audio

  -Prima della 6a generazione, indirizzo `ADR`:` 0x001B0000`, nome della parte: `HDEF`,` AZAL`, ecc.
  -6a generazione e successive, indirizzo `ADR`:` 0x001F0003`, nome della parte: `HDAS`,` AZAL` ecc.

  ** Nota 1 **: Il metodo per confermare le parti precedenti cercando il nome non è affidabile. Il metodo affidabile è cercare "indirizzo ADR", "_PRW".

  ** Nota 2 **: Le macchine appena rilasciate potrebbero avere nuove parti che richiedono `0D / 6D patch`.

## La diversità di `_PRW` e il corrispondente metodo di patch

-` Tipo di nome`

  ```Swift
    Name (_PRW, Package (0x02)
    {
        0x0D, /* may be 0x6D */
        0x03, /* may be 0x04 */
        ...
    })
  ```

Questo tipo di "patch 0D / 6D" è adatto per modificare "0x03" (o "0x04") in "0x00" mediante la ridenominazione binaria. Il pacchetto prevede:

   -Name-0D rinominato .plist
     -`Name0D-03` a `00`
     -`Name0D-04` a `00`
   -Nome-6D rinominato in .plist
     -`Name6D-03` a `00`
     -`Name6D-04` a `00`

-Uno di "Tipo di metodo": "GPRW (UPRW)"

  ```Swift
    Method (_PRW, 0, NotSerialized)
    {
      Return (GPRW (0x6D, 0x04)) /* or Return (UPRW (0x6D, 0x04)) */
    }
  ```

268 / 5000
Risultati della traduzione
La maggior parte delle macchine più recenti cade in questa situazione. Segui il solito metodo (rinominato-patch). Il pacchetto prevede:

   - *** SSDT-GPRW *** (Sono presenti dati di ridenominazione binari nel file patch)
   - *** SSDT-UPRW *** (Sono presenti dati di ridenominazione binari nel file patch)

-` Tipo di metodo` due: `Scope`

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
                Return (Package (0x02)
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

Questa situazione non è comune. Per il caso dell'esempio, utilizzare il nome binario per rinominare *** Name6D-03 in 00 ***. Prova altre forme di contenuto da solo.

-`Name type`, `Method type` metodo misto

   Per la maggior parte delle macchine TP, le parti coinvolte nella "patch 0D / 6D" hanno sia "tipo di nome" che "tipo di metodo". Usa i rispettivi tipi di patch. ** Nota che ** La patch di ridenominazione binaria non può essere utilizzata in modo improprio. Alcune parti "_PRW" che non richiedono "0D / 6D patch" possono anche essere "0D" o "6D". Per evitare questo tipo di errore, il file `System DSDT` dovrebbe essere estratto per verifica e verifica.

### Precauzioni

-Il metodo descritto in questo articolo è applicabile a Hotpatch.
-Per qualsiasi ridenominazione binaria utilizzata, il file `System DSDT` dovrebbe essere estratto per la verifica.
