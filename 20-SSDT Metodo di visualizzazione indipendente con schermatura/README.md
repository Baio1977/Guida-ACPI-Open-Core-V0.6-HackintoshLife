## Metodo SSDT shield solo

## Due metodi per bloccare il display Solo

- metodo `config

  - `DeviceProperties\Add\PciRoot(0x0)/Pci(0x2,0x0)` Add

    ``testo
    disattivare-esterno-gpu 0100000000
    ```

  - Aggiungere parametri di avvio

    ``testo
    boot-args -wegnoegpu
    ```

- Questo metodo** -- Metodo SSDT shield solo

## Processo di Mascheramento SSDT Solo

- La fase di inizializzazione disabilita la visualizzazione in solitario.
- Attivare l'assolo durante il sonno della macchina per evitare un possibile crash del sistema se l'assolo va a `S3` mentre è disabilitato.
- Disattivare di nuovo l'assolo dopo il risveglio della macchina.

## Combinazione di patch

- Patch combinato - ***SSDT-PTSWAK****
- Patch di blocco del solo display-- ***SSDT-NDGP_OFF*** [o ***SSDT-NDGP_PS3***].

## Esempio

- ***SSDT-PTSWAK***

  Leggermente, vedere il PTSWAK Comprehensive Extension Patch per i dettagli.
  
- ***SSDT-NDGP_OFF***

  - Interrogare il nome e il percorso del display solitario per confermare l'esistenza dei metodi `_ON` e `_OFF
  - Fate riferimento all'esempio e cambiate il suo nome e il suo percorso in modo che corrisponda al risultato della query
  
- ***SSDT-NDGP_PS3***

  - Interrogare il nome e il percorso della visualizzazione Solo per confermare l'esistenza dei metodi `_PS0`, `_PS3` e `_DSM
  - Fare riferimento all'esempio e modificare il nome e il percorso per far corrispondere il risultato della query
  
- **Nota**

  - Quando si cerca il nome e il percorso e `_ON`, `_OFF`, `_PS0`, `_PS3` e `_DSM`, si devono cercare tutti i file `ACPI`, che possono esistere nel file `DSDT` o in altri file `SSDT` di `ACPI`.
  - Il nome e il percorso dell'esempio sono: `_SB.PCI0.RP13.PXSX` .

## Attenzione.

- Sia ***SSDT-PTSWAK*** che ***SSDT-NDGP_OFF*** [o ***SSDT-NDGP_PS3***] devono essere utilizzati come richiesto da **combinazione di patch**
- Se entrambi ***SSDT-NDGP_OFF*** e ***SSDT-NDGP_PS3*** soddisfano i requisiti di utilizzo, si preferisce ***SSDT-NDGP_OFF***.

**Nota** : Il contenuto principale di cui sopra è tratto da [@RehabMan](https://github.com/rehabman)
