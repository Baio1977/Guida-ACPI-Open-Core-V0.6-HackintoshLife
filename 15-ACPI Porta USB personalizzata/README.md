# Porta USB personalizzata ACPI

## Descrizione

-Questo metodo realizza la personalizzazione della porta USB modificando il file ACPI.
-L'operazione di questo metodo richiede di eliminare un file ACPI. In circostanze normali, OpenCore ** non è consigliato ** per farlo, le porte USB personalizzate generalmente utilizzano lo strumento *** Hackintool.app ***.
-Questo metodo è dedicato ai fan.

## Campo di applicazione

-XHC e il suo "_UPC" esistono in un file ACPI separato
-Questo metodo non è applicabile ai dispositivi in cui `_UPC` esiste in DSDT (ad esempio ASUS)

## Specifica `_UPC`

```Swift
_UPC, Package ()
{
    xxxx,
    yyyy,
    0x00,
    0x00
}
```

### Spiegazione

1. ** `xxxx` **
   -`0x00` significa che questa porta non esiste
   -Altri valori (di solito "0x0F") rappresentano l'esistenza di questa porta

2. ** `yyyy` **

   ** `yyyy` ** definisce il tipo di porta, fare riferimento alla tabella seguente

   | ** `yyyy` ** | Tipo di porta |
   | :------: | ----------------------------- |
   | `0x00` | USB Type `A` |
   | `0x01` | USB `Mini-AB` |
   | `0x02` | USB Smart Card |
   | `0x03` | USB 3 Standard Type `A` |
   | `0x04` | USB 3 Standard Type `B` |
   | `0x05` | USB 3 `Micro-B` |
   | `0x06` | USB 3 `Micro-AB` |
   | `0x07` | USB 3 `Power-B` |
   | `0x08` | USB Type `C` **(Only USB 2)** |
   | `0x09` | USB Type `C` **(With diverter)** |
   | `0x0A` | USB Type `C` **(without diverter)** |
   | `0xFF` | Built-in |

   > Se sia la parte anteriore che quella posteriore dell'USB-C sono collegate alla stessa porta in Hackintool, significa che la porta ha un redirector
   >
   > Viceversa, se due porte sono occupate su entrambi i lati, significa che non è presente alcun deviatore

## Processo di personalizzazione USB

-Cancella patch, driver, ecc. Di altri metodi di personalizzazione.

-rilascia il file ACPI

  -Confermare XHC e includere il file ACPI di `_UPC`
    > Come *** SSDT-2-xh_OEMBD.aml *** di dell5480
    >
    > Come *** SSDT-8-CB-01.aml *** di Xiaoxin PRO13 (i5) (la macchina senza display indipendente è *** SSDT-6-CB-01.aml ***)

  -`config \ ACPI \ Block \ `rilascia i file ACPI nei metodi` TableLength` (decimale) e `TableSignature`. Ad esempio:

    ** dell5480 **: ** `TableLength` ** =` 2001`, ** `TableSignature` ** =` 53534454` (SSDT)

    ** Xiaoxin PRO13 (i5) **: ** `TableLength` ** =` 12565`, ** `TableSignature` ** =` 53534454` (SSDT)

-Personalizza il file di patch SSDT

  -Trascina il file ACPI originale che deve essere rilasciato sul desktop, ** raccomandazione: **

    -Salva come formato `.asl / .dsl`
    -Modifica il nome del file. Ad esempio: *** SSDT-xh_OEMBD_XHC.dsl ***, *** SSDT-CB-01_XHC.dsl ***
    -Modifica l '"ID tabella OEM" nel file con il tuo nome preferito.
    -Elimina gli errori.

  -Aggiungere il seguente codice all'inizio di `_UPC` di tutte le porte nel file SSDT:

    ```Swift
    Method (_UPC, 0, NotSerialized)
    {
        If (_OSI ("Darwin"))
        {
            Return (Package ()
            {
                xxxx,
                yyyy,
                0x00,
                0x00
            })
        }
        /* The following is the original content */
        ...
    }
    ```
    
-Personalizza la porta USB in base alla specifica `_UPC`. Cioè, i valori di xxxx e yyyy vengono corretti.

     -Se la porta non esiste
       - ** `xxxx` ** =` 0x00`
       - ** `yyyy` ** =` 0x00`
     -Se la porta esiste
       - ** `xxxx` ** =` 0xFF`
       - ** `yyyy` **

     > Fare riferimento alla tabella sopra
  
   -Debug, compila e metti i file di patch in `ACPI`, aggiungi l'elenco delle patch.

### Esempio di riferimento

- *** SSDT-xh_OEMBD_XHC ***
- *** SSDT-CB-01_XHC ***
