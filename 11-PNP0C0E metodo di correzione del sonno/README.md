# PNP0C0E Metodo di correzione del sonno

## Modalità sleep `PNP0C0E` e` PNP0C0D`

- Specifica ACPI

  `PNP0C0E` - Dispositivo pulsante di sospensione

  `PNP0C0D` - Dispositivo coperchio

  Per dettagli su `PNP0C0E` e `PNP0C0D`, fare riferimento alla specifica ACPI.

- `PNP0C0E` condizioni di sonno

  -Esegui `Notifica (***. SLPB, 0x80)`. SLPB` è il nome del dispositivo `PNP0C0E`.
  
- `PNP0C0D` condizioni di sonno

  - `_LID` restituisce `Zero`. `_LID` è lo stato corrente del dispositivo `PNP0C0D`.
  - Esegui `Notifica (***. LID0, 0x80)`. `LID0` è il nome del dispositivo `PNP0C0D`.

## Descrizione del problema

Alcune macchine forniscono un pulsante di sospensione (piccolo pulsante luna), come Fn + F4 per alcuni ThinkPad, Fn + Insert per Dell e così via. Quando questo pulsante viene premuto, il sistema esegue lo sleep `PNP0C0E`. Tuttavia, ACPI ha passato in modo errato i parametri di arresto invece dei parametri di sospensione al sistema, il che ha causato l'arresto anomalo del sistema. Anche se riesci a dormire, puoi svegliarti normalmente e lo stato di funzionamento del sistema viene distrutto.

Uno dei seguenti metodi può risolvere questo problema:

- Intercettare i parametri passati da ACPI e correggerli.
- Convertire la sospensione `PNP0C0E` in sospensione` PNP0C0D`.

## soluzione

### Associate 3 patch

- ***SSDT-PTSWAK***: Definisci le variabili `FNOK` e` MODE` per catturare le modifiche di `FNOK`. Vedere `Patch di estensione completa per PTSWAK`.

  - `FNOK` significa stato del pulsante
     - `FNOK` = 1: premere il pulsante di sospensione
    - `FNOK` = 0: premere di nuovo il pulsante di sospensione o la macchina viene riattivata
  - `MODE` imposta la modalità di sospensione
    - `MODE` = 1: `PNP0C0E` sleep
    - `MODE` = 0: `PNP0C0D` sleep

  Nota: impostare `MODALITÀ` in base alle proprie esigenze, ma non è possibile modificare `FNOK`.

- ***SSDT-LIDpatch***: cattura le modifiche di `FNOK`

  -Se `FNOK` = 1, lo stato corrente del dispositivo del coperchio torna a `Zero`
  -Se `FNOK` = 0, lo stato corrente del dispositivo di copertura torna al valore originale

  Nota: il percorso e il nome del dispositivo `PNP0C0D` devono essere coerenti con ACPI.

- ***Patch del pulsante di sospensione***: Dopo aver premuto il pulsante, impostare `FNOK` =` 1` ed eseguire le operazioni corrispondenti in base alle diverse modalità di sospensione

  Nota: il percorso e il nome del dispositivo `PNP0C0D` devono essere coerenti con ACPI.

#### Descrizione di due modalità di sospensione

- `MODE` = 1 modalità: quando si preme il pulsante di sospensione, ***patch del pulsante di sospensione*** rende `FNOK = 1`. ***SSDT-PTSWAK*** ha catturato "FNOK" come "1" e forza "Arg0 = 3" (altrimenti "Arg0 = 5"). Ripristina "FNOK = 0" dopo il risveglio. Un processo completo di sospensione e riattivazione `PNP0C0E` è terminato.
- `MODE` = modalità 0: quando viene premuto il pulsante di sospensione, oltre a completare il processo sopra, ***SSDT-LIDpatch*** acquisisce anche `FNOK = 1` e restituisce` _LID` a `Zero` ed esegue Sonno `PNP0C0D`. Ripristina "FNOK = 0" dopo il risveglio. Un processo completo di sospensione e riattivazione di `PNP0C0D` è terminato.

Di seguito sono riportati i contenuti principali di ***SSDT-LIDpatch***:

```Swift
Method (_LID, 0, NotSerialized)
{
    if(\_SB.PCI9.FNOK==1)
    {
        Return (0) /* Return to Zero, meeting one of the PNP0C0D sleep conditions*/
    }
    Else
    {
        Return (\_SB.LID0.XLID()) /* return to original value*/
    }
}
```


Quanto segue è il contenuto principale della ***patch del pulsante di sospensione***:

```Swift
If (\_SB.PCI9.MODE == 1) /* PNP0C0E sleep*/
{
    \_SB.PCI9.FNOK =1 /* Press the sleep button*/
    \_SB.PCI0.LPCB.EC.XQ13() /* Original sleep button position, the example is TP machine*/
}
Else /* PNP0C0D sleep*/
{
    If (\_SB.PCI9.FNOK!=1)
    {
            \_SB.PCI9.FNOK =1 /* Press the sleep button*/
    }
    Else
    {
            \_SB.PCI9.FNOK =0 /* press the sleep button again*/
    }
    Notify (\_SB.LID, 0x80) /* Execute PNP0C0D sleep*/
}
```

### Esempio di combinazione di ridenominazione e patch: (Dell Latitude 5480 e ThinkPad X1C5th)

- **Dell Latitude 5480**

  PTSWAK è stato rinominato: `_PTS` in` ZPTS`,` _WAK` in` ZWAK`.

  Stato del coperchio rinominato: `_LID` in` XLID`

  Pulsante rinominato: da `BTNV` a` XTNV` (Dell-Fn + Inserisci)

  Combinazione di patch:

  - ***SSDT-PTSWAK***: patch completa Imposta "MODALITÀ" in base alle tue esigenze.
  - ***SSDT-LIDpatch***: patch di stato del coperchio.
  - ***SSDT-FnInsert_BTNV-dell***: patch pulsante di sospensione.

- **ThinkPad X1C5th**

  PTSWAK è stato rinominato: `_PTS` in` ZPTS`,` _WAK` in` ZWAK`.

  Stato del coperchio rinominato: `_LID` in` XLID`

  Rinomina chiave: da `_Q13 a XQ13` (TP-Fn + F4)
  
  Combinazione di patch:
  
  - ***SSDT-PTSWAK***: patch completa Imposta `MODALITÀ` in base alle tue esigenze.
  - ***SSDT-LIDpatch***: patch di stato del coperchio Modifica `LID0` in `LID` nella patch.
  - ***SSDT-FnF4_Q13-X1C5th***: patch pulsante di sospensione.
  
  **Nota 1 **: il pulsante di sospensione di X1C5th è Fn + 4 e il pulsante di sospensione di alcuni TP è Fn + F4.
  
  **Nota 2**: il nome del controller "LPC" della macchina TP può essere "LPC" o "LPCB".

### Altre macchine riparano il sonno `PNP0C0E`

- Usa la patch: ***SSDT-PTSWAK***; rinominata: `_PTS` in` ZPTS`,` _WAK` in` ZWAK` Vedere `Patch di estensione completa per PTSWAK`.

  Modifica la `MODALITÀ` in base alle tue esigenze.

- Usa patch: ***SSDT-LIDpatch***; rinominato: `_LID` in` XLID`.

  Nota: il percorso e il nome del dispositivo `PNP0C0D` devono essere coerenti con ACPI.

- Trova la posizione del pulsante sleep, crea ***patch pulsante sleep***

  - Normalmente, il pulsante di sospensione è `_Qxx` sotto` EC`, questo` _Qxx` contiene il comando` Notify (***. SLPB, 0x80) `. Se non può essere trovato, DSDT cercherà il testo completo `Notifica ( ***. SLPB, 0x80)`per trovare la sua posizione, e gradualmente troverà la posizione originale verso l'alto.
  - Fai la patch del pulsante di sospensione e rinomina se necessario con riferimento all'esempio.

  Nota 1: SLPB è il nome del dispositivo `PNP0C0E` Se confermi che non esiste un dispositivo `PNP0C0E`, aggiungi una patch: SSDT-SLPB (che si trova in `Aggiungi parti mancanti `).

  Nota 2: il nome e il percorso del dispositivo "PNP0C0D" devono essere coerenti con ACPI.

### `PNP0C0E` Funzioni di sospensione

-Il processo di sonno è leggermente più veloce.
-Il processo di sospensione non può essere terminato.

### `PNP0C0D` Funzioni di sospensione

-Durante il sonno, premere nuovamente il pulsante di sospensione per interrompere immediatamente il sonno.

-Quando il display esterno è collegato, dopo aver premuto il pulsante sleep, lo schermo di lavoro diventa il display esterno (lo schermo interno è spento); premendo nuovamente il pulsante sleep, i display interno ed esterno sono normali.

## Precauzioni

-`PNP0C0E` e `PNP0C0D` nomi e percorsi dei dispositivi devono essere coerenti con ACPI.
