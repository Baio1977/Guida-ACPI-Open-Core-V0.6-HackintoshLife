### Patch: *** SSDT-PNLF-ACPI ***

Potrebbe essere necessario modificare la patch in base alle proprie esigenze. Metodo di modifica:

-Estrarre ACPI nativi
-Cercare `_BCL`,` _BCM`, `_BQC` in tutti i file ACPI e registrare il nome del dispositivo a cui appartengono, ad esempio` LCD`.
-Modificare "DD1F" nel file patch con il nome registrato in precedenza ("DD1F" viene sostituito con "LCD"). Fare riferimento a *** 《Diagramma modificato》 ***.
-Modifica la "IGPU" del file di patch con il nome della scheda grafica ACPI (per esempio, sostituisci "IGPU" con "GFX0").

### Guidare

-ACPIBacklight.kext
