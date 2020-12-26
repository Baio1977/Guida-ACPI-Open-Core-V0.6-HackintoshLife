# Disabilita EHCx

## descrizione

I bus EHC1 ed EHC2 devono essere disabilitati in una delle seguenti situazioni:

- ACPI include EHC1 o EHC2 e la macchina stessa non dispone di hardware correlato.
-ACPI include EHC1 o EHC2. La macchina ha hardware correlato ma nessuna porta di uscita effettiva (esterna e interna)。


## patch

- *** SSDT-EHC1_OFF *** ： Disabilita `EHC1`。
- *** SSDT-EHC2_OFF *** ： Disabilita `EHC2`。
- *** SSDT-EHCx_OFF *** ： È la patch unita di *** SSDT-EHC1_OFF *** e *** SSDT-EHC2_OFF ***。

## Istruzioni

- Impostazione del BIOS prioritario: `XHCI Mode` =` Enabled`。
- Se il BIOS non ha l'opzione `XHCI Mode`, allo stesso tempo soddisfa la ** descrizione di ** un caso, utilizzando la patch。

### Precauzioni

- Applicabile a macchine della serie 7, 8, 9 e macOS 10.11 o superiore.
- Per le macchine della serie 7, *** SSDT-EHC1_OFF *** e *** SSDT-EHC2_OFF *** non possono essere utilizzati contemporaneamente。
- Applicare la patch `Scope (\)` sotto il metodo `_INI` aggiunto, e se altre patch di duplicazione` _INI`, dovrebbero unire `_INI` i contenuti。
