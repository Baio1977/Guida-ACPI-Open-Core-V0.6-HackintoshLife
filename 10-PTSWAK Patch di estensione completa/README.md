# Patch completa

## Descrizione

-Denominando `_PTS` e` _WAK`, aggiungendo patch complete e le sue patch estese, sono stati risolti alcuni problemi nel processo di sospensione o riattivazione di alcune macchine.

-La patch completa è un framework che include:
   -Blocca l'interfaccia del display indipendente `_ON`,` _OFF`.
   -6 interfacce patch estese `EXT1`,` EXT2`, `EXT3`,` EXT4`, `EXT5` e` EXT6`.
   -Definire i parametri obbligatori per il trasferimento del sonno `FNOK` e` MODE`, vedere "Metodo di correzione del sonno PNP0C0E" per i dettagli.
   -Definisci i parametri di debug `TPTS` e` TWAK`, che sono usati per rilevare e tenere traccia delle modifiche di `Arg0` durante il sonno e la sveglia. Ad esempio, aggiungi il seguente codice alla patch di scelta rapida della luminosità:

    ```Swift
    ...
         /* Una chiave: */
         \ RMDT.P2 ("ABCD-_PTS-Arg0 =", \ _SB.PCI9.TPTS)
         \ RMDT.P2 ("ABCD-_WAK-Arg0 =", \ _SB.PCI9.TWAK)
         ...
         `` `

         Quando si preme il tasto di scelta rapida della luminosità, è possibile vedere il valore di "Arg0" sulla console dopo la sospensione e il risveglio precedenti.

         Nota: per eseguire il debug di ACPI, è necessario installare il driver ACPIDebug.kext, aggiungere la patch SSDT-RMDT e personalizzare la patch di debug. Vedere "ACPIDebug" per metodi specifici.

    ## Rinomina

    Per utilizzare la patch integrata, è necessario rinominare `_PTS` e` _WAK`. Scegli la modifica del nome corretta in base al contenuto DSDT originale, ad esempio:

    -`_PTS` a `ZPTS (1, N)`:

  ```Swift
    Method (_PTS, 1, NotSerialized)  /* _PTS: Prepare To Sleep */
    {
  ```

- `_WAK` to `ZWAK(1,N)`:

  ```Swift
    Method (_WAK, 1, NotSerialized)  /* _WAK: Wake */
    {
  ```

- `_PTS` to `ZPTS(1,S)`:

  ```Swift
    Method (_PTS, 1, Serialized)  /* _PTS: Prepare To Sleep */
    {
  ```

- `_WAK` to `ZWAK(1,S)`:

  ```Swift
    Method (_WAK, 1, Serialized)  /* _WAK: Wake */
    {
  ```

Se "_TTS" esiste nel DSDT, deve essere rinominato; se non esiste, non è necessario rinominarlo. Scegli la modifica del nome corretta in base al contenuto DSDT originale, ad esempio:

- `_TTS` to `ZTTS(1,N)`:

  ```Swift
    Method (_TTS, 1, NotSerialized)  /* _WAK: Wake */
    {
  ```

- `_TTS` to `ZTTS(1,S)`:

  ```Swift
    Method (_TTS, 1, Serialized)  /* _WAK: Wake */
    {
  ```


## Patch

- *** SSDT-PTSWAKTTS *** —— Patch completa.

- *** SSDT-EXT1-FixShutdown *** —— Patch di estensione `EXT1`. Risolve il problema che il controller XHC cambia dallo spegnimento al riavvio. Il principio è di impostare "XHC.PMEE" su 0 quando il parametro passato in "_PTS" è "5". Questa patch ha lo stesso effetto di "FixShutdown" di Clover. Alcune macchine XPS / ThinkPad avranno bisogno di questa patch.

- *** SSDT-EXT3-WakeScreen *** - Patch di estensione `EXT3`. Risolvi il problema che alcune macchine devono premere un tasto qualsiasi per accendere lo schermo dopo il risveglio. Quando lo si utilizza, è necessario verificare se il nome del dispositivo e il percorso di `PNP0C0D` sono già nel file di patch, ad esempio` _SB.PCI0.LPCB.LID0`. Se non esiste, aggiungilo tu stesso.

- *** SSDT-EXT5-TP-LED *** —— Patch di estensione `EXT5`. Risolvi il problema che la luce del respiro sul lato A e la luce del respiro del pulsante di accensione non tornano alla normalità dopo che la macchina ThinkPad si è riattivata; risolvi il problema che lo stato dell'indicatore del microfono <kbd> F4 </kbd> è anormale dopo il risveglio sul vecchio modello ThinkPad.

## Nota

Le patch con lo stesso nome di estensione non possono essere utilizzate contemporaneamente. Se ci sono requisiti per l'uso simultaneo, devono essere combinati.
