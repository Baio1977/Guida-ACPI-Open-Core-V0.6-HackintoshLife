# Proibisci il sonno `S3`

## Descrizione

- ** S3` Sonno vietato ** viene utilizzato per risolvere il problema di ** interruzione del sonno ** causato da alcune macchine per qualche motivo. ** Interruzione del sonno ** significa: la macchina non può essere riattivata normalmente dopo il sonno, viene visualizzato come un arresto anomalo, riavvio dopo il risveglio, spegnimento, ecc.

## Metodo patch

-Rinominato: `_S3 in XS3`

   `` testo
   Trova 5F53335F
   Sostituisci 5853335F
   `` `

-Patch
   - *** SSDT-NameS3-disable ***: È adatto per `ACPI` per descrivere il metodo di` S3` come il tipo di `Name`. Questo è il caso della maggior parte delle macchine.
   - *** SSDT-MethodS3-disable ***: Applicabile a "ACPI" per descrivere il metodo di "S3" come il tipo di "Method".

## Precauzioni

-Selezionare la patch corrispondente in base alla descrizione originale "ACPI" del metodo "S3" della macchina.
