# Metodo di visualizzazione indipendente con schermatura SSDT

## Due modi per bloccare la visualizzazione indipendente

- `config`

  - `DeviceProperties \ Add \ PciRoot (0x0) / Pci (0x2,0x0) `aggiungi

    `` testo
    disabilitare-gpu-esterno 01000000
    `` `

  - Aggiungere parametri di avvio

    `` testo
    boot-args -wegnoegpu
    `` `

- **Questo metodo** - Metodo di visualizzazione indipendente con schermatura SSDT

## SSDT schermatura processo di visualizzazione indipendente

- Disabilita visualizzazione indipendente durante la fase di inizializzazione.
- Abilita il display standalone durante la sospensione della macchina per evitare che il display standalone inserisca "S3" quando è disabilitato, il che potrebbe causare l'arresto anomalo del sistema.
- isabilitare nuovamente il display indipendente dopo che la macchina si è svegliata.

## Combinazione di patch

- Patch completa - ***SSDT-PTSWAK***
- Patch display indipendente dallo schermo—— ***SSDT-NDGP_OFF​​*** [o ***SSDT-NDGP_PS3***]

## Esempio

- ***-PTSWAK***

  Leggermente, vedere `PTSWAK Comprehensive Extension Patch` per i dettagli.
  
- ***SSDT-NDGP_OFF​​***

  -Query il nome e il percorso del display univoco e confermare l'esistenza dei metodi `_ON` e` _OFF`
  -Fare riferimento all'esempio, modificare il nome e il percorso in modo che siano coerenti con il risultato della query
  
- ***SSDT-NDGP_PS3***

  - Query il nome e il percorso del display indipendente e confermare l'esistenza dei metodi `_PS0`,` _PS3` e `_DSM`
  - Fare riferimento all'esempio, modificare il nome e il percorso in modo che siano coerenti con il risultato della query
  
- **Attenzione**

  - Quando si interroga il nome e il percorso univoci così come `_ON`,` _OFF`, `_PS0`,` _PS3` e `_DSM`, è necessario cercare tutti i file` ACPI`. Può esistere nel file `DSDT`, o può esistere in altri file` SSDT` di `ACPI`.
  - Il nome e il percorso univoci nell'esempio sono: `_SB.PCI0.RP13.PXSX`.

## Precauzioni

- In base ai requisiti della **combinazione di patch**, ***SSDT-PTSWAK*** e ***SSDT-NDGP_OFF​​*** devono essere utilizzati contemporaneamente [o ***SSDT-NDGP_PS3*** ]
- Se entrambi ***SSDT-NDGP_OFF​​*** e ***SSDT-NDGP_PS3*** soddisfano i requisiti di utilizzo, utilizzare prima ***SSDT-NDGP_OFF​​***

**Nota**: il contenuto principale di cui sopra proviene da [@RehabMan] (https://github.com/rehabman)
