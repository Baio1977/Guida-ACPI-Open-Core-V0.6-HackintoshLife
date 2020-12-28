# Panoramica AOAC

## Tecnologia AOAC

- Il nuovo laptop introduce una nuova tecnologia-`AOAC`, ovvero: *Sempre attivo/Sempre connesso*. `AOAC` è stato proposto dalla società `Intel`, con l'obiettivo di mantenere la connessione di rete e la trasmissione dei dati quando il computer è in modalità di sospensione o ibernazione. In poche parole, l'introduzione di `AOAC` rende i notebook come i nostri telefoni cellulari, mai spenti e sempre online.

### Come giudicare la macchina `AOAC`

- Apri `FACP.aml` di` ACPI` con MaciASL, cerca `Low Power S0 Idle`, se = 1, appartiene alla macchina` AOAC`. Ad esempio:

  `` asl
  Bassa potenza S0 inattivo (V5): 1
  `` `

- Per il contenuto di `AOAC`, Baidu `AOAC`, `Lenovo AOAC`, `scheda di rete AOAC` ecc.

## Problema di AOAC

### Problema di interruzione del sonno

- A causa della contraddizione tra `AOAC` e `S3`, la macchina che utilizza la tecnologia `AOAC` non dispone della funzione sleep `S3`, come `Lenovo PRO13`. Una macchina del genere **interrompe il sonno** una volta che entra in modalità di sospensione `S3`. **Insufficienza del sonno** Le manifestazioni principali sono: impossibilità di essere risvegliato dopo il sonno, mostrando uno stato morto, solo spegnimento forzato. **Interruzione del sonno** L'essenza è che la macchina è rimasta bloccata nel processo di sospensione e non è mai riuscita a dormire.
- Fare riferimento a "Specifiche ACPI" per i contenuti del sonno `S3`.

### Problema di tempo di standby

- **Forbid `S3`sleep** può risolvere il problema **sleep failure**, ma la macchina non dormirà più. Il problema derivante dall'assenza di sospensione è che in modalità alimentata a batteria, il tempo di standby della macchina è notevolmente ridotto. Ad esempio, nel caso di `menu sleep`, `auto sleep`, `lid sleep`, ecc., La batteria consuma molta energia, circa il 5% -10% all'ora.

## Soluzione AOAC

- Disabilita il sonno `S3`
- Spegnere l'alimentazione del display indipendente
- Power gestione del minimo
- Scegli un SSD di qualità migliore: SLC> MLC> TLC> QLC (non sicuro)
- Aggiorna il firmware SSD, se possibile, per migliorare le prestazioni di gestione dell'alimentazione
- Usa NVMeFix.kext per abilitare APST di SSD
- Abilita ASPM (le opzioni avanzate del BIOS abilitano ASPM, patch abilita L1)

## AOAC dormi, svegliati

-`AOAC` sonno

  Lo schema sopra può far dormire la macchina, questo tipo di sonno è chiamato sleep `AOAC`. L'essenza del sonno `AOAC` è che il sistema e l'hardware entrano nello stato di inattività, che non è il senso tradizionale del sonno` S3`.

-`AOAC` sveglia

  È più difficile riattivare la macchina dopo che è entrata in modalità sleep AOAC, di solito è necessario il pulsante di accensione per riattivarla. Alcune macchine potrebbero aver bisogno del pulsante di accensione + metodo `PNP0C0D` per riattivare la macchina.

## Patch AOAC

- Proibisci il sonno `S3`-vedi` Proibisci il sonno S3 `
- Disattivare la patch di visualizzazione indipendente: vedere `AOAC vieta la visualizzazione indipendente`
- Patch Power Idle Management-Vedi `Power Idle Management`
- Patch di attivazione AOAC - vedere `Metodo di attivazione AOAC`
- Seconda patch di riattivazione: vedere `patch 060D"
- Abilita dispositivo LI —— vedere `Impostazione della modalità di lavoro ASPM`, grazie @iStar 丶 Forever per aver fornito il metodo
-C ontrollo Bluetooth WIFI —— vedere `Sleep per disattivare automaticamente Bluetooth WIFI`, grazie @ i5 ex900 0,66% / h Huaxing OC Dreamn per aver fornito il metodo

## Precauzioni

- La soluzione `AOAC` è una soluzione temporanea. Con l'applicazione diffusa della tecnologia `AOAC`, potrebbero esserci soluzioni migliori in futuro.
- `AOAC` sonno e risveglio sono diversi da `S3` sonno e risveglio, le seguenti patch non sono applicabili
  - `Patch di estensione completa PTSWAK`
  - `Metodo di correzione del sonno PNP0C0E`
- Per lo stesso motivo di cui sopra, `AOAC` non può visualizzare correttamente lo stato di funzionamento durante il sonno, ad esempio la spia che non respira lampeggia durante il sonno.
- Le macchine non-`AOAC` possono anche provare questo metodo.
