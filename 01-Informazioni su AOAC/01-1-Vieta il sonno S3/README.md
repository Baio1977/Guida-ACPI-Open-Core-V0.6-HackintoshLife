# Proibisci il sonno `S3`

## Descrizione

- **`S3` Sonno vietato** viene utilizzato per risolvere il problema di **interruzione del sonno** causato da alcune macchine per qualche motivo. **Interruzione del sonno** significa: la macchina non può essere riattivata normalmente dopo la sospensione, viene visualizzata come un crash, riavvio, spegnimento dopo il risveglio, ecc

## Metodo patch

- Rinominato: da `_S3 a XS3`

    `` testo
    Find 5F53335F
    Replace 5853335F
    `` `

- Patch
    - ***SSDT-NameS3-disable***: È adatto per `ACPI` per descrivere il metodo di` S3` come il tipo di `Name`. Questo è il caso della maggior parte delle macchine.
    - ***SSDT-MethodS3-disable***: Applicabile a `ACPI` per descrivere il metodo di` S3` come il tipo di `Method`.

## Precauzioni

- Selezionare la patch corrispondente in base alla descrizione originale `ACPI` della macchina del metodo `S3`.
