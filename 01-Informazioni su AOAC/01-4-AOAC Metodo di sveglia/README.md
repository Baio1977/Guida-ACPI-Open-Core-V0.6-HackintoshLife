# Metodo di riattivazione AOAC

## Descrizione

- La patch ***SSDT-DeepIdle*** può mettere la macchina in uno stato di inattività profondo ed estendere il tempo di standby della macchina. Tuttavia, può anche rendere più difficile il risveglio della macchina e richiedere metodi speciali per svegliarla. Vedere Power Idle Management per maggiori informazioni sugli aspetti ***SSDT-DeepIdle***.
- Questo metodo** ripristina lo stato di risveglio** tramite una patch personalizzata.

## Metodo del risveglio: pulsante di accensione

## Breve descrizione del principio del risveglio

- Normalmente, il **Pulsante di accensione** è in grado di svegliare la macchina. Tuttavia, ci sono momenti in cui la macchina viene svegliata in uno stato incompleto. E' possibile che: non **accenda lo schermo** o non **aggiorni i dati di potenza**. In questo caso, è necessario aggiungere il metodo `_PS0` sotto il dispositivo `LPCB`, e aggiungere il metodo **Reset wakeup state** a `_PS0`. Tipicamente, il metodo `_WAK` [Arg0 = 3] include **Schermo luminoso** e **Aggiorna i dati sull'alimentazione**.
- Secondo le specifiche ACPI, si raccomanda di utilizzare entrambi i metodi `_PS0` e `_PS3`.

## Esempio di patch

- ***SSDT-PCI0.LPCB-Wake-AOAC*** 

  ````Swift
  ...
  Ambito di applicazione (_SB.PCI0.LPCB)
  {
      Se (_OSI ("Darwin"))
      {
          Metodo (_PS0, 0, serializzato)
          {
              \_WAK(0x03) // Riprendere lo stato di risveglio
              // Può richiedere un metodo di recupero dei dati di potenza personalizzato
          }
          Metodo (_PS3, 0, serializzato)
          {
          }
      }
  }
  ...
  ```
  

## In allegato

- **Condizione dello schermo luminoso** 
  - `_LID` restituisce `One' . `_LID` è lo stato attuale del dispositivo `PNP0C0D
  - Eseguire `Notify(***.LID0, 0x80)`. `LID0` è `PNP0C0D` Nome del dispositivo

- **Aggiornamento del metodo dei dati di potenza** 

  Se l'icona dell'alimentazione non può essere aggiornata dopo il risveglio a causa del cambiamento di stato dell'alimentazione durante il sonno (ad esempio, scollegando o collegando l'alimentazione durante il sonno), fare riferimento al seguente metodo.

  - Trovare il nome e il percorso del dispositivo di alimentazione (`_HID` = `ACPI0003`), cercare per nome di alimentazione e registrare il `Metodo` che comprende `Notify (***Power Name, 0x80)`. Aggiungere questo `Metodo` a `_PS0` in ***SSDT-PCI0.LPCB-Wake-AOAC***.
  - `Notify (***Power Name, 0x80)` può esistere in più di un `Metodo`, questo deve essere confermato dal metodo ACPIDebug. **Confermare il metodo**: il `Metodo` che risponde all'inserimento o allo scollegamento dell'alimentazione è quello di cui abbiamo bisogno.
