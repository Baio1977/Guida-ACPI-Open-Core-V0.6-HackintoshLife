# Rinomina binario

## Descrizione

Il metodo descritto in questo articolo non è rinominare `Device` o `Method` nel senso comune, ma abilitare o disabilitare un dispositivo tramite la ridenominazione binaria.

## Rischio

Quando OC avvia altri sistemi, la ridenominazione binaria ACPI può influenzare altri sistemi.

## Esempio

Prendi l'abilitazione di `HPET` come esempio. Vogliamo che `_STA` restituisca `0x0F`.

Rinomina binario:

Trova: `00 A0 08 48 50`" Nota: `00` =` {`;` A0` = `If` ......`

Sostituisci: `00 A4 0A 0F A3` `Nota:` 00 `=` {`;` A4 0A 0F `=` Return (0x0F) `;` A3 `=` Noop `, utilizzato per inserire il numero di byte`

- Codice originale

  ```Swift
    Method (_STA, 0, NotSerialized)
    {
        If (HPTE)
        {
            Return (0x0F)
        }
        Return (Zero)
    }
  ```

- Codice rinominato

  ```Swift
    Method (_STA, 0, NotSerialized)
    {
          Return (0x0F)
          Noop
          TE** ()
          Return (Zero)
    }
  ```

**Spiegazione**: si è verificato un errore evidente dopo la modifica del nome, ma questo errore non causerà danni. Prima di tutto, il contenuto dopo `Return (0x0F)` non verrà eseguito. In secondo luogo, l'errore si trova in "{}" e non influirà su altri contenuti.

   In realtà, dovremmo fare del nostro meglio per garantire la completezza della grammatica dopo il cambio di nome. Di seguito sono riportati i dati completi di "Trova" e "Sostituisci".
  
   Trova: `00 A0 08 48 50 54 45 A4 0A 0F A4 00`
  
   Sostituisci: `00 A4 0A 0F A3 A3 A3 A3 A3 A3 A3 A3 A3`
  
   Completa il codice dopo `Sostituisci`
  
  ```Swift
    Method (_STA, 0, NotSerialized)
    {
        Return (0x0F)
        Noop
        Noop
        Noop
        Noop
        Noop
        Noop
        Noop
        Noop
    }
  ```

## Richiesta

- ***ACPI*** file originale

  Il file binario `Trova` deve essere il file ***ACPI*** originale e non può essere modificato o salvato da alcun software, il che significa che deve essere il file binario originale fornito dalla macchina.

- `Trova` unicità e correttezza

   Il numero di `Find` è solo uno, **a meno che** la nostra intenzione non sia quella di eseguire la stessa operazione di` Find` e `Replace` in più posizioni.

   **Attenzione speciale**: qualsiasi riscrittura di un pezzo di codice per trovare e confermare i dati binari è molto inaffidabile!

- `Replace` numero di byte

  `Trova`,` Sostituisci` Il numero di byte è uguale. Ad esempio, se "Trova" è di 10 byte, anche "Sostituisci" è di 10 byte. Se "Sostituisci" è inferiore a 10 byte, riempilo con "A3" (nessuna operazione).

## Metodo di ricerca dei dati `Find`

Di solito, usa un software binario (come `010 Editor`) e` MaciASL.app` per aprire lo stesso file `ACPI`, usa dati binari e testo contenuto relativo a` Trova`, osserva il contesto, credo che tu possa determinare rapidamente `Trova` dati.

## `Sostituisci` contenuto

Quando "Trova" è indicato nei "Requisiti", [Qualsiasi dato binario che viene riscritto per trovare e confermare un pezzo di codice è molto inaffidabile! ], ma "Replace" può farlo. Secondo l'esempio sopra, scriviamo un pezzo di codice:

```Swift
    DefinitionBlock ("", "SSDT", 2, "hack", "111", 0)
    {
        Method (_STA, 0, NotSerialized)
        {
            Return (0x0F)
        }
    }
```

Dopo la compilazione, aprilo con il software binario e trova: `XX ... 5F 53 54 41 00 A4 0A 0F`, dove` A4 0A 0F` è `Return (0x0F)`.

Nota: il contenuto di "Sostituisci" deve essere conforme alle specifiche ACPI e ai requisiti della lingua ASL.

## Precauzioni

- L'aggiornamento del BIOS potrebbe rendere non valida la modifica del nome. Maggiore è il numero di byte `Trova` e` Sostituisci`, maggiore è la possibilità di errore.

### Allegato: TP-W530 proibisce BAT1

Trova: `00 A0 4F 04 5C 48 38 44 52`

Sostituisci: `00 A4 00 A3 A3 A3 A3 A3 A3`

- Codice originale

  ```Swift
    Method (_STA, 0, NotSerialized)
    {
          If (\H8DR)
          {
              If (HB1A)
              {
              ...
    }
  ```

- Codice rinominato

  ```Swift
    Method (_STA, 0, NotSerialized)
    {
          Return (Zero)
          Noop
          Noop
          Noop
          Noop
          Noop
          Noop
          If (HB1A)
          ...
    }
  ```

# Metodo delle variabili preimpostate

## Descrizione

- Il cosiddetto **metodo delle variabili preimpostate** consiste nel pre-assegnare alcune variabili ACPI (tipo `Name` e tipo` FieldUnitObj`) per ottenere lo scopo dell'inizializzazione. [Sebbene queste variabili siano state assegnate al momento della definizione, non sono cambiate prima che il `Metodo` le chiami. 】
- La correzione di queste variabili in `Scope (\)` tramite un file di patch di terze parti può ottenere l'effetto di patch previsto.

## Rischio

- La "variabile" modificata può esistere in più posizioni. Dopo che è stata modificata, potrebbe influenzare altri componenti mentre si ottengono i risultati attesi.
- La `variabile` modificata può provenire da informazioni hardware e può essere solo letta ma non scritta. In questo caso, **Binary Rename** e **SSDT Patch** devono essere completati insieme. Va notato che quando OC avvia altri sistemi, potrebbe essere impossibile ripristinare la `variabile` rinominata. Vedi **Esempio 4**.

### Esempio 1

Un dispositivo _STA testo originale:

```Swift
Method (_STA, 0, NotSerialized)
{
    ECTP (Zero)
    If ((SDS1 == 0x07))
    {
        Return (0x0F)
    }
    Return (Zero)
}
```
Per qualche ragione abbiamo bisogno di disabilitare questo dispositivo, al fine di raggiungere lo scopo `_STA` dovrebbe restituire` Zero`. Si può vedere dal testo originale che finché `SDS1` non è uguale a `0x07`. Utilizza il **metodo delle variabili preimpostate** come segue:

```Swift
Scope (\)
{
    External (SDS1, FieldUnitObj)
    If (_OSI ("Darwin"))
    {
        SDS1 = 0
    }
}
```

### Esempio 2

La patch ufficiale ***SSDT-AWAC*** viene utilizzata per alcune macchine della serie 300 + per forzare l'abilitazione di RTC e disabilitare AWAC allo stesso tempo.

Nota: è anche possibile utilizzare ***SSDT-RTC0*** per abilitare RTC, vedere `Attrezzatura contraffatta`.

originale:

```Swift
Device (RTC)
{
    ...
    Method (_STA, 0, NotSerialized)
    {
            If ((STAS == One))
            {
                Return (0x0F)
            }
            Else
            {
                Return (Zero)
            }
    }
    ...
}
Device (AWAC)
{
    ...
    Method (_STA, 0, NotSerialized)
    {
            If ((STAS == Zero))
            {
                Return (0x0F)
            }
            Else
            {
                Return (Zero)
            }
    }
    ...
}
```

Si può vedere dal testo originale che fino a quando `STAS` = `1`, RTC può essere abilitato e `AWAC` può essere disabilitato allo stesso tempo. Utilizza il **metodo delle variabili preimpostate** come segue:

- Patch ufficiale ***SSDT-AWAC***

  ```Swift
  External (STAS, IntObj)
  Scope (_SB)
  {
      Method (_INI, 0, NotSerialized)  /* _INI: Initialize */
      {
          If (_OSI ("Darwin"))
          {
              STAS = One
          }
      }
  }
  ```

Nota: la patch ufficiale introduce il percorso `_SB._INI`, dovresti assicurarti che DSDT e altre patch non esistano` _SB._INI` quando lo usi.

- Patch migliorata ***SSDT-RTC_Y-AWAC_N***

  ```Swift
  External (STAS, IntObj)
  Scope (\)
  {
      If (_OSI ("Darwin"))
      {
          STAS = One
      }
  }
  ```

### Esempio 3

Quando si utilizza la patch I2C, potrebbe essere necessario abilitare `GPIO`. Vedere ***SSDT-OCGPI0-GPEN*** in `OCI2C-GPIO Patch`.

Qualche testo originale:

```Swift
Method (_STA, 0, NotSerialized)
{
    If ((GPEN == Zero))
    {
        Return (Zero)
    }
    Return (0x0F)
}
```

Come si può vedere dal testo originale, fintanto che `GPEN` non è uguale a `0`, `GPIO` può essere abilitato. Utilizza il **metodo delle variabili preimpostate** come segue:

```Swift
External(GPEN, FieldUnitObj)
Scope (\)
{
    If (_OSI ("Darwin"))
    {
        GPEN = 1
    }
}
```

### Esempio 4

Quando la `variabile` è di sola lettura, la soluzione è la seguente:

- Rinomina la `variabile` originale
- Ridefinisci una `variabile` con lo stesso nome nel file patch

Ad esempio: un testo originale:

```Swift
OperationRegion (PNVA, SystemMemory, PNVB, PNVL)
Field (PNVA, AnyAcc, Lock, Preserve)
{
    ...
    IM01,   8,
    ...
}
...
If ((IM01 == 0x02))
{
    ...
}
```

Infatti, `IM01` non è uguale a 0x02 e il contenuto di {...} non può essere eseguito. Per correggere gli errori, utilizza **Binary Rename** e **SSDT Patch**:

**Rinomina**: `IM01` rinomina` XM01`

```text
Find:    49 4D 30 31 08
Replace: 58 4D 30 31 08
```

**patch**:

```Swift
Name (IM01, 0x02)
If (_OSI ("Darwin"))
{
    ...
}
Else
{
     IM01 = XM01 / * Uguale al percorso della variabile ACPI originale * /
}
```
### Esempio 5

Utilizzare il metodo (Metodo) `_STA` originale del dispositivo da chiamare `IntObj` e assegnarlo per modificare il bit di abilitazione dello stato del dispositivo.

Un testo originale: può essere utilizzato un esempio di questo metodo

```Swift
Method (_STA, 0, NotSerialized)
{
    If ((XXXX == Zero))
    {
        Return (Zero)
    }
    Return (0x0F)
}

Method (_STA, 0, NotSerialized)
{
    Return (0x0F)
}

Name (_STA, 0x0F)

```
Si può vedere che il metodo `_STA` sopra esemplificato contiene solo il bit di abilitazione che restituisce lo stato del dispositivo e il bit di abilitazione che viene restituito in base al giudizio condizionale. Se non si desidera utilizzare le variabili preimpostate per rinominare e modificare le condizioni, è possibile utilizzare SSDT personalizzato Puoi fare riferimento direttamente al metodo `_STA` come` IntObj`

Esempi di operazioni per disabilitare un dispositivo:

```Swift

External (_SB_.PCI0.XXXX._STA, IntObj)

\_SB.PCI0.XXXX._STA = Zero 

```
Per l'impostazione specifica del bit di abilitazione del metodo `_STA`, fare riferimento a ** Basi del linguaggio ASL **

Il motivo per cui questo metodo è efficace nelle applicazioni pratiche è principalmente perché la priorità del metodo `_STA` nella specifica ACPI per la valutazione dello stato del dispositivo e l'inizializzazione nel modulo OSPM del sistema operativo è maggiore del ritorno di` _INI _ADR _HID` e `_STA` Il valore stesso è anche un intero `Integer`

Un testo originale: un esempio di un'operazione in cui questo metodo non può essere utilizzato

```Swift
Method (_STA, 0, NotSerialized)
{
    ECTP (Zero)
    If (XXXX == One)
    {
        Return (0x0F)
    {
    
    Return (Zero)
}

Method (_STA, 0, NotSerialized)
{
    ^^^GFX0.CLKF = 0x03
    Return (Zero)
}
```
Dagli esempi precedenti, si può vedere che oltre a impostare il bit di abilitazione dello stato condizionale del dispositivo, il metodo originale `_STA` contiene anche altre operazioni` chiamata metodo ECTP (Zero) `e` operazioni di assegnazione ^^^ GFX0.CLKF = 0x03` ,
L'uso di questo metodo provocherà il fallimento di altri riferimenti e operazioni nel metodo originale `_STA` e causerà errori (errore non ACPI)


**Rischio**: `XM01` potrebbe non essere ripristinato quando OC avvia altri sistemi.
