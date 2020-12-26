# Metodo di riattivazione AOAC

## Descrizione

- *** SSDT-DeepIdle *** patch può far entrare la macchina in uno stato di inattività profondo e prolungare il tempo di standby della macchina. Ma allo stesso tempo, sarà difficile riattivare la macchina e sarà necessario adottare metodi speciali per riattivare la macchina. Per il contenuto di *** SSDT-DeepIdle ***, fare riferimento a "Power Idle Management".
- ** Questo metodo ** ** Reimposta lo stato di attivazione ** tramite una patch personalizzata.

## Metodo di riattivazione: pulsante di accensione

## Breve descrizione del principio di sveglia

-In circostanze normali, il ** pulsante di accensione ** può riattivare la macchina. Ma a volte, lo stato dopo il risveglio della macchina non è completo. Potrebbe essere: impossibile ** illuminare lo schermo ** o impossibile ** aggiornare i dati di alimentazione **. In questo caso, è necessario aggiungere il metodo `_PS0` sotto il dispositivo` LPCB` e aggiungere il metodo ** reset wakeup state ** in `_PS0`. Di solito, il metodo `_WAK` [Arg0 = 3] include il contenuto correlato di ** illumina lo schermo ** e ** aggiorna i dati di potenza **.
-Secondo la specifica ACPI, si consiglia di utilizzare entrambi i metodi `_PS0` e` _PS3`.

## Esempio di patch

- ***SSDT-PCI0.LPCB-Wake-AOAC*** 

  ```Swift
  ...
  Scope (_SB.PCI0.LPCB)
  {
      If (_OSI ("Darwin"))
      {
          Method (_PS0, 0, Serialized)
          {
              \_WAK(0x03) //Ripristina lo stato di veglia
              // Potrebbe essere necessario personalizzare il metodo di ripristino dei dati di alimentazione
          }
          Method (_PS3, 0, Serialized)
          {
          }
      }
  }
  ...
  ```
  

## Allegato

- ** Illumina le condizioni dello schermo **
  -`_LID` restituisce "Uno". "_LID" è lo stato corrente del dispositivo "PNP0C0D"
  -Esegui "Notifica (***. LID0, 0x80)". "LID0" è il nome del dispositivo "PNP0C0D"

- ** Come aggiornare i dati di potenza **

  Se l'icona di alimentazione non può essere aggiornata dopo il risveglio a causa della modifica dello stato di alimentazione durante la sospensione (ad esempio, scollegando o ricollegando l'alimentazione durante la sospensione), è possibile fare riferimento ai seguenti metodi:

  -Trova il nome e il percorso del dispositivo di alimentazione (`_HID` =` ACPI0003`), cerca in base al nome della fonte di alimentazione e registra il "Metodo" che contiene "Notifica (*** nome della fonte di alimentazione, 0x80)". Aggiungi questo `Metodo` a` _PS0` di *** SSDT-PCI0.LPCB-Wake-AOAC ***.
  -`Notify (*** nome della fonte di alimentazione, 0x80) `può esistere in più` Method`, che devono essere confermati dal metodo "ACPIDebug". ** Metodo di conferma **: Il `Metodo` che risponde a collegare e scollegare l'alimentazione è ciò di cui abbiamo bisogno.
