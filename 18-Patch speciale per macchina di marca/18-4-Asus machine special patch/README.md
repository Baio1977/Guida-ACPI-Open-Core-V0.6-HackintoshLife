# Patch speciale per macchine Asus

## Richiesta

- Controlla se i seguenti `Metodo` e `Nome` esistono in ACPI, in caso contrario, ignora il contenuto di questo capitolo.
  - `Nome`: OSFG
  - `Metodo`: MSOS

## Rinomina speciale

PNLF renamed XNLF

```text
Find:     504E4C46
Replace:  584E4C46
```

C'è una variabile `PNLF` nel DSDT di alcune macchine Asus. Se `PNLF` e la patch di luminosità hanno lo stesso nome, potrebbero esserci dei conflitti. Usa il cambio di nome sopra per evitarlo.

## Patch speciale

- ***SSDT-OCWork-asus***
  - La maggior parte delle macchine Asus ha il metodo `MSOS`. Il metodo `MSOS` assegna un valore a `OSFG` e restituisce il valore dello stato corrente. Questo [valore dello stato corrente] determina la modalità di lavoro della macchina. Ad esempio, solo quando `MSOS`> =` 0x0100`, il metodo del tasto di scelta rapida della luminosità di ACPI funzionerà. Per impostazione predefinita, `MSOS` è bloccato su `OSME`. **Questa patch** cambia `MSOS` cambiando `OSME`. Per i dettagli sul metodo `MSOS`, fare riferimento al Metodo `MSOS`di DSDT...
    -`MSOS`> = `0x0100`, modalità win8, i tasti di scelta rapida della luminosità funzionano
  - Il valore di ritorno di `MSOS' dipende dal sistema operativo stesso. È necessario utilizzare **patch del sistema operativo** o utilizzare **questa patch** in uno stato di mela nera per soddisfare requisiti specifici.
