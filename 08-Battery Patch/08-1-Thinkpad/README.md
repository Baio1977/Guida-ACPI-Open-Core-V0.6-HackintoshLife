# Patch batteria ThinkPad

## Descrizione

-Si prega di leggere "Allegato" "ThinkPad Battery System".
-Confermare che il percorso di `Main Battery` sia` \ _SB.PCI0.` ** `LPC` **` .EC.BAT0` o `\ _SB.PCI0.` **` LPCB` ** `.EC.BAT0`, Non entrambi, il contenuto di questo capitolo è solo di riferimento.
-Quanto segue è diviso in ** tre casi ** per spiegare come utilizzare la patch della batteria.

### Rinomina e patch del sistema a batteria singola

-Rinominare:
  -La batteria TP è sostanzialmente rinominata
  -La batteria TP `Mutex` impostata su` 0` è stata rinominata
-Patch
  -Patch batteria principale` - *** SSDT-OCBAT0-TP ******

### Sistema a doppia batteria con una batteria fisica rinominata e patchata

-Rinominare
  -La batteria TP è sostanzialmente rinominata
  -La batteria TP `Mutex` impostata su` 0` è stata rinominata
  -`BAT1` disabilita la ridenominazione di `_STA in XSTA`
  
    ** Nota **: Utilizza correttamente `Count`,` Skip`, `TableSignature` e verifica che la posizione di` _STA in XSTA` sia corretta tramite DSDT di sistema
-Patch
  
  -Patch batteria principale` - *** SSDT-OCBAT0-TP ******
  -`BAT1` disabilita patch - *** SSDT-OCBAT1-disable-`LPC` *** [o *** SSDT-OCBAT1-disable-`LPCB` ***]

### Sistema a doppia batteria due batterie fisiche rinominate e patchate

-Rinominare
  -La batteria TP è sostanzialmente rinominata
  -La batteria TP `Mutex` impostata su` 0` è stata rinominata
  -`Notify` rinominato
-Patch
  -Patch batteria principale` - *** SSDT-OCBAT0-TP ******
  -`BATC` patch-- *** SSDT-OCBATC-TP-`LPC` *** [o *** SSDT-OCBATC-TP-`LPCB` *** *** SSDT-OCBATC-TP-` _BIX` ***】
  -`Notify` patch - *** SSDT-Notify-`LPC` *** [o *** SSDT-Notify-`LPCB` ***】
  
    **Nota**:
  
    -Quando si utilizza la patch `BATC`, utilizzare la + macchina di settima generazione *** SSDT-OCBATC-TP-`_BIX` ***
    -Quando si seleziona la patch `Notify`, dovresti ** attentamente ** controllare` _Q22`, `_Q24`,` _Q25`, `_Q4A`,` _Q4B`, `_Q4C`,` _Q4D`, `BATW` Se il contenuto di "BFCC" è coerente con il contenuto corrispondente di "ACPI" originale, in caso contrario, correggere il contenuto corrispondente della patch. Ad esempio, il contenuto di "_Q4C" della macchina di terza generazione è diverso dal contenuto di esempio; le macchine di quarta, quinta, sesta e settima generazione non hanno "_Q4C"; la macchina di settima generazione + ha "BFCC". e molti altri....... Il file di esempio *** SSDT-Notify-`LPCB` *** è solo per T580.
-Carico di sequenza
  -Patch della batteria principale
  -Patch`BATC`
  -Patch di notifica

## Precauzioni

- *** SSDT-OCBAT0-TP ****** è la patch della batteria principale. Quando si sceglie, scegliere la patch corrispondente in base al modello di macchina.
-Quando si selezionano le patch, prestare attenzione alla differenza tra "LPC" e "LPCB".
-Hai bisogno di `TP battery Mutex impostato su 0 e rinominato`, provalo tu stesso.

## Esempio di patch `Notify` [solo metodo` (_Q22` ... parte])

> T580 originale

```Swift
Method (_Q22, 0, NotSerialized)  /* _Qxx: EC Query, xx=0x00-0xFF */
{
    CLPM ()
    If (HB0A)
    {
        Notify (BAT0, 0x80) /* Status Change */
    }

    If (HB1A)
    {
        Notify (BAT1, 0x80) /* Status Change */
    }
}
```

> Riscrivi

```swift
/*
 * For ACPI Patch:
 * _Q22 to XQ22:
 * Find:    5f51 3232
 * Replace: 5851 3232
 */
Method (_Q22, 0, NotSerialized)  /* _Qxx: EC Query, xx=0x00-0xFF */
{
    If (_OSI ("Darwin"))
    {
        CLPM ()
        If (HB0A)
        {
            Notify (BATC, 0x80) /* Status Change */
        }

        If (HB1A)
        {
            Notify (BATC, 0x80) /* Status Change */
        }
    }
    Else
    {
        \_SB.PCI0.LPCB.EC.XQ22 ()
    }
}
```

Vedere la patch `Notify` per i dettagli - *** SSDT-Notify-`BFCC` ***

> La macchina verificata è `ThinkPad T580`, la patch e la ridenominazione sono le seguenti:

- ** SSDT-OCBAT0-TP_tx80_x1c6th **
- ** SSDT-OCBATC-TP-`LPCB` **
- ** SSDT-Notify-`LPCB` **
- ** La batteria TP è sostanzialmente rinominata **
- ** Notifica rinominato **

### Accessori: sistema di batterie ThinkPad

#### Panoramica

Il sistema di batterie Thinkpad è suddiviso in sistema a batteria singola e sistema a doppia batteria.

-Il sistema a doppia batteria significa che la macchina è dotata di due batterie. Oppure, sebbene la macchina sia dotata di una sola batteria, fornisce l'interfaccia fisica della seconda batteria e il corrispondente ACPI. La seconda batteria è opzionale e può essere installata successivamente. Una macchina con un sistema a doppia batteria può avere una o due batterie.
-Il sistema a batteria singola è ACPI in cui la macchina è dotata di una batteria e una sola batteria.

-Ad esempio, la struttura della batteria del T470 e del T470s è un sistema a doppia batteria e la struttura della batteria del T470P è un sistema a batteria singola. Per un altro esempio, la serie T430 è un sistema a doppia batteria La macchina stessa ha una sola batteria, ma la seconda batteria può essere installata tramite l'unità ottica.

#### Valutazione del sistema a batteria singola e doppia

-Sistema a doppia batteria: sia `BAT0` che` BAT1` esistono in ACPI
-Sistema a batteria singola: ACPI ha solo "BAT0" e non "BAT1"
