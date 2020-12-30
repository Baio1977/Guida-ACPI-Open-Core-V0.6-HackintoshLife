# Panoramica AOAC

## Tecnologia AOAC

- I nuovi portatili introducono una nuova tecnologia - `AOAC`, o *Always On/Always Connected*. AOAC è stato introdotto da Intel per mantenere la connettività di rete e il trasferimento dei dati anche quando il computer è in modalità sleep o ibernazione. In poche parole, l'introduzione di `AOAC` rende i portatili come i nostri telefoni cellulari, mai spenti e sempre online.

### Come determinare la macchina `AOAC

- Aprire `FACP.aml` di `ACPI` con MaciASL, cercare `Low Power S0 Idle`, se è = 1, è una macchina `AOAC`. Per esempio.

  ```asl
  Bassa potenza S0 Idle (V5) : 1
  ```

- Per ulteriori informazioni su `AOAC`, fare riferimento a Baidu `AOAC`, `Lenovo AOAC`, `AOAC NIC`, ecc.

## Problemi AOAC

### Problema di mancanza di sonno

- Poiché `AOAC` e `S3` si contraddicono a vicenda, le macchine con tecnologia `AOAC` non hanno la funzione sleep `S3`, come il `Lenovo PRO13`. Una macchina di questo tipo **Sleep Fail** una volta entrato nel sonno `S3`. **Il guasto del sonno** si manifesta principalmente con il fatto che la macchina non può essere svegliata dopo il sonno e sembra essere morta, e può essere solo costretta a spegnersi. L'essenza di **sleep failure** è che la macchina rimane in stallo nel processo di sonno e non dorme mai con successo.
- Vedere la specifica ACPI per gli aspetti relativi al sonno 'S3'.

### Problemi di tempo di standby

- La disabilitazione del sonno `S3` risolve il problema dell'interruzione del sonno**, ma la macchina non dormirà più. Il problema che ne consegue, in assenza di sonno, è che il tempo di standby della macchina si riduce notevolmente in modalità a batteria. Ad esempio, in 'menu sleep', 'auto sleep', "box cover sleep", ecc. il consumo della batteria è maggiore, circa il 5% - 10% all'ora.

## Soluzione AOAC

- Disattivare il sonno 'S3'
- Spegnere l'alimentazione per il solo display
- Gestione dei tempi di inattività
- Scegliere una migliore qualità SSD: SLC>MLC>TLC>TLC>QLC (non sicuro)
- Aggiornare il firmware dell'SSD, se possibile, per migliorare le prestazioni di gestione dell'alimentazione
- Attivare APST per SSD utilizzando NVMeFix.kext
- Abilita ASPM (opzioni avanzate del BIOS per abilitare ASPM, patch enable L1)

## AOAC Dormire, svegliarsi

- 'Il sonno dell'AOAC'.

  Lo schema di cui sopra può far dormire la macchina, questo sonno si chiama sonno `AOAC` sleep . L'essenza del sonno `AOAC` è che il sistema, l'hardware, va in uno stato di inattività, non di `S3` sonno nel senso tradizionale.

- Sveglia "AOAC

  Svegliare una macchina dopo che è entrata nel sonno `AOAC` può essere difficile e di solito richiede il pulsante di accensione per svegliarla. Alcune macchine possono richiedere il metodo del pulsante di accensione + `PNP0C0D` per svegliare la macchina.

## AOAC Patch

- Disattivare il sonno `S3` - vedi Disattivare il sonno S3
- Disabilita Patch Solo - vedi `AOAC Disabilita Solo'.
- Patch di Power Idle Management - vedi Power Idle Management
- AOAC Wakeup Patch - vedi 'Metodo di risveglio AOAC'
- Wake in Seconds Patch - vedi '060D' Patch
- Attivare il dispositivo LI - vedi 'Impostazione del modo di lavoro ASPM', grazie a @iStar丶Forever per il metodo
- Gestire il Bluetooth WIFI - vedi 'Sleep Auto Disable Bluetooth WIFI', grazie a @i5 ex900 0,66%/h Huaxing OC Dreamn per il metodo

## Attenzione

- La soluzione 'AOAC' è una soluzione provvisoria. Con l'uso diffuso della tecnologia 'AOAC', ci potrebbe essere una soluzione migliore in futuro.
- Il sonno e la veglia dell'AOAC sono diversi dal sonno e dalla veglia dell'S3, i seguenti cerotti non sono applicabili
  - Il PTSWAK Comprehensive Extension Patch
  - PNP0C0E Fissaggi per il sonno
- Per lo stesso motivo di cui sopra, il sonno `AOAC` non visualizza correttamente lo stato di funzionamento durante il sonno, ad es. durante il sonno non lampeggia alcuna luce di respirazione.
- Anche le macchine non-AOAC possono provare questo metodo.
