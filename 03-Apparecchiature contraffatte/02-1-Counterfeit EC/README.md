## Descrizione

OpenCore richiede che il nome del controller EC non venga modificato, ma per caricare la gestione dell'alimentazione USB, potrebbe essere necessario falsificare un altro EC.

## Istruzioni per l'uso

Cerca "PNP0C09" in DSDT per visualizzare il nome del dispositivo a cui appartiene. Se il nome non è "EC", usa questa patch; se è "EC", ignora questa patch.

## Nota

-Se vengono trovati più "PNP0C09", il dispositivo "PNP0C09" reale ed effettivo dovrebbe essere confermato.
-`LPCB` viene utilizzato nella patch, se non è `LPCB`, modificare personalmente il contenuto della patch.
