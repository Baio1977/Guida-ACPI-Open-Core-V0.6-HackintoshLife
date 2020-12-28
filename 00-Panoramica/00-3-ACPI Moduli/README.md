# Modulo ACPI

### Breve descrizione

- ACPI (Advanced Configuration & Power Interface) è la configurazione avanzata di un computer e l'interfaccia di alimentazione. È uno standard di gestione dell'alimentazione sviluppato congiuntamente da Intel, Microsoft e altri fornitori, vale a dire [`Specifiche ACPI`] (https: //www.acpica. Org / documentation). Ogni computer verrà fornito con una serie di file binari conformi alla [`specifica ACPI`] (https://www.acpica.org/documentation) quando lascia la fabbrica. Questi file sono chiamati moduli ACPI. Il numero e il contenuto delle tabelle ACPI variano da dispositivo a computer e ** possono ** variare in base alla versione del BIOS. Il modulo ACPI include:
  - 1 DSDT.aml
  - Multipli SSDT-.aml ad esempio: `SSDT-SataAhci.aml`,` SSDT-CpuSsdt.aml`, `SSDT-CB-01.aml` ecc.
  - Altri SSDT-.aml ad esempio: `APIC.aml`,` BGRT.aml`, `DMAR.aml`,` ECDT.aml` ecc.
- Alcuni strumenti e guide possono estrarre il modulo ACPI della macchina, come Aida64 sotto Windows, trifoglio e così via. Poiché il modulo ACPI è un file binario, abbiamo bisogno di un software di decompilazione che ci aiuti a comprendere il contenuto del file, come MaciASL del sistema MAC. Quando si aprono questi moduli con il decompilatore, soprattutto quando si apre DSDT.aml, potrebbero essere visualizzati molti errori. Va notato che nella maggior parte dei casi questi errori sono causati dal processo di decompilazione del software e il foglio ACPI fornito dalla macchina non contiene questi errori.
- Il modulo ACPI descrive le informazioni hardware della macchina sotto forma di linguaggio aml e non ha alcuna capacità di guida. Tuttavia, il normale funzionamento di un determinato hardware richiede un ACPI corretto e un metodo di descrizione errato può causare un errore di avvio o un arresto anomalo del sistema. Ad esempio, se nella macchina è installata una scheda di rete Broadcom, se ACPI è descritta come una scheda di rete Intel, il sistema caricherà il driver della scheda di rete Intel, il che è ovviamente sbagliato. Per un altro esempio, la macchina non fornisce hardware per la "regolazione automatica della luminosità", anche se ACPI aggiunge "SSDT-ALS0", non può realizzare la funzione di regolazione automatica della luminosità.
- A causa dei diversi principi di funzionamento del sistema Windows e del sistema MAC, la mela nera deve correggere l'ACPI. L'ACPI corretto è la base per il lavoro stabile della Mela Nera. ** Fortemente consigliato ** Usa `Hot Patch` [HOTpatch] per applicare una patch ad ACPI. "Hot patch" può evitare il cosiddetto errore DSDT.
- Per dettagli su ACPI, fare riferimento a [`Specifiche ACPI`] (https://www.acpica.org/documentation); per l'introduzione del linguaggio AML, fare riferimento a "Nozioni di base sulla grammatica ASL".
- Questo capitolo `Patch ACPI` si applica solo a` OpenCore`

### Patch ACPI

- Patch DSDT e patch SSDT

  Questa parte del contenuto si riferisce ad altri capitoli di `OC-little`.

- Altre patch del modulo

  - **Cancella i `campi di intestazione` di ACPI **
    - **Metodo patch **: `ACPI \ Quirks \ NormalizeHeaders` =` true`
    - **Nota**: questa patch è richiesta solo per Mac 10.13
  - **Riposiziona l'area di memoria ACPI **
    - **Metodo patch**: `ACPI \ Quirks \ RebaseRegions` =` true`
    - **Spiegazione**: L'area di memoria del foglio ACPI ha indirizzi allocati dinamicamente e indirizzi allocati fissi. La funzione della patch è quella di **riposizionare l'area di memoria ACPI**, questa operazione è molto pericolosa, a meno che questa patch non risolva il problema del crash di avvio, altrimenti non utilizzarla.
  - **FACP.aml**
    
    - **Metodo patch**: `ACPI \ Quirks \ FadtEnableReset` =` true`
    
    - **Descrizione**: [`Specifiche ACPI`] (https://www.acpica.org/documentation) Usa **FADT** per definire varie informazioni di sistema statiche relative alla configurazione e alla gestione dell'alimentazione. Il modulo ACPI appare come **FACP.aml**. **FACP.aml** Le informazioni rappresentate dal modulo includono orologio RTC, pulsanti di accensione e spegnimento, gestione dell'alimentazione, ecc. I seguenti aspetti sono attualmente correlati alle mele nere:
    
    - Se il riavvio e l'arresto sono anomali, provare a utilizzare questa patch
      
    - Se non riesci a richiamare il menu `Riavvia, Sospendi, Annulla, Arresta` premendo il **pulsante di accensione**, prova questa patch
      
      **Nota**: Se `ACPI \ Quirks \ FadtEnableReset` =` true` non è ancora in grado di richiamare il menu `Riavvia, Sospendi, Annulla, Arresto", prova ad aggiungere ***SSDT-PMCR***. ***SSDT-PMCR*** si trova in `Aggiungi parti mancanti` in OC-little.
      
    - Il `Low Power S0 Idle` e `Hardware Reduced` nel formato **FACP.aml** rappresentano il tipo di macchina e determinano il metodo di gestione dell'alimentazione. Se "Low Power S0 Idle" = `1`, significa che la macchina appartiene a `AOAC`. Per il contenuto di `AOAC`, fare riferimento a `Informazioni su AOAC`.
    
  - **FACS.aml**
    - **Metodo patch**: `ACPI \ Quirks \ ResetHwSig` =` true`
    - **Descrizione**: l'elemento `Firma hardware` nel formato **FACS.aml** è una firma hardware a 4 byte, che viene calcolata in base alla configurazione hardware di base dopo l'avvio del sistema. Se questo valore cambia dopo che la macchina è nello stato **sleep** **risveglio**, il sistema non sarà in grado di ripristinarsi correttamente. Lo scopo della patch è di rendere `Firma hardware` = `0` per cercare di risolvere i problemi di cui sopra.
    - **Nota:** Se il sistema ha disabilitato **l'ibernazione**, non preoccuparti di questa patch
  - **BGRT.aml**
    - **Metodo patch**: `ACPI \ Quirks \ ResetLogoStatus` =` true`
    - **Descrizione**: **BGRT.aml** form è un modulo di risorse grafiche di guida. Secondo la [`Specifica ACPI`] (https://www.acpica.org/documentation), l'elemento` Displayed` del modulo dovrebbe = `0`. Tuttavia, alcuni produttori scrivono dati diversi da zero nella voce "Visualizzato" per qualche motivo, il che potrebbe causare un errore di aggiornamento dello schermo durante la fase di avvio. L'effetto della patch è di rendere "Displayed" = `0`.
    - **Nota:** non tutte le macchine hanno questa forma
  - **DMAR.aml**
    - **Metodo patch**: `Kernel \ Quirks \ DisableIoMapper` =` true`
    - **Nota**: La funzione della patch è la stessa di quella del BIOS che proibisce `VT-d` o Drop **DMAR.aml**
    - **Nota**: questa patch è richiesta solo per i sistemi Mac precedenti
  - **ECDT.aml**
    
    - **Metodo patch**: rinomina globalmente il nome "EC" e il percorso di tutti i moduli ACPI per essere coerente con "Namepath"
    - **Spiegazione**: Il `Namepath` della forma **ECDT.aml** delle singole macchine (come **Lenovo yoga-s740**) non è coerente con i nomi` EC` di altri moduli ACPI, che causerà l'avvio della macchina Si è verificato un errore ACPI durante il processo. Questo metodo di patch può risolvere meglio il problema di segnalazione degli errori ACPI.
    - **Nota**: non tutte le macchine hanno questa forma
