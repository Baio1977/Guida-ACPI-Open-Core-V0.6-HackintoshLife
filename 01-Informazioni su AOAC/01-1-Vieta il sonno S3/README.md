# Proibire il sonno 'S3' #

## Descrizione

- **Disabilitare il `S3` sonno** viene utilizzato per risolvere il problema del **sonno di sonno** causato da alcune macchine per alcuni motivi. **Fallimento del sonno** è: la macchina non può essere svegliata normalmente dopo il sonno, si presenta come morta, si riavvia o si spegne dopo il risveglio, ecc.

## Metodo Patch

- Cambiare il nome: `_S3 in XS3`.

  ````testo
  Find 5F53335F
  Replace 5853335F
  ```

- Patch
  - ***SSDT-NameS3-disable***: si applica se `ACPI` descrive che il metodo `S3` è del tipo `Name`, che è il caso della maggior parte delle macchine.
  - ***SSDT-MethodS3-disable*** : Si applica se `ACPI` descrive il metodo `S3` come di tipo `Method`.

## Attenzione

- Selezionare la patch corrispondente in base alla descrizione originale `ACPI` del metodo `S3` della macchina.
