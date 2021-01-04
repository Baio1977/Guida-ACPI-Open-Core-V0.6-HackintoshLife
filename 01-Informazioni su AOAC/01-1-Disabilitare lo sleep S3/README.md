# Disabilitare lo sleep 'S3' #

## Descrizione

- **Disabilitare lo sleep `S3`** viene utilizzato per risolvere il problema dello **Sleep perenne** causato da alcune macchine per alcuni motivi. Lo **Sleep perenne** in sintesi consiste nel non poter più "risvegliare" la macchina normalmente dopo lo sleep, presentandosi come morta, oppure che si riavvii o si spenga dopo il risveglio, ecc.

## Metodo di Patch

- Rinominando: `_S3` in `XS3`.

  ````testo
  Find 5F53335F
  Replace 5853335F
  ```

- Patch
  - ***SSDT-NameS3-disable***: si applica se `ACPI` descrive che il metodo `S3` è del tipo `Name`, che è il caso della maggior parte delle macchine.
  - ***SSDT-MethodS3-disable*** : Si applica se `ACPI` descrive il metodo `S3` come di tipo `Method`.

## Attenzione

- Selezionare la patch corrispondente in base alla descrizione originale `ACPI` del metodo `S3` della macchina.
