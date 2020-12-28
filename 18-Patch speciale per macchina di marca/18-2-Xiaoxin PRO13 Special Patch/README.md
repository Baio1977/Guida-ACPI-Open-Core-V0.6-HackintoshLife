# Xiaoxin PRO13 Patch speciale

## Rinomina speciale

PNLF renamed XNLF

```text
Find:     504E4C46
Replace:  584E4C46
```

Il DSDT di Xiaoxin PRO ha la variabile `PNLF`,` PNLF` e il nome della patch di luminosità potrebbe essere in conflitto, quindi usa la modifica del nome sopra per evitarlo.

## Patch speciale AOAC

- ***SSDT-NameS3-disable*** ——Vedi `S3 Sleep Prohibition` in `AOAC Method`
- ***SSDT-NDGP_OFF-AOAC*** —— Fare riferimento a `AOAC Prohibit Independent Display` in `AOAC Method`
- ***SSDT-DeepIdle*** ——Vedi `Gestione alimentazione inattiva` in `Metodo AOAC`
- ***SSDT-PCI0.LPCB-Wake-AOAC*** —— Vedi `Metodo di riattivazione AOAC` in `Metodo AOAC`

## Altre patch (riferimento)

- ***SSDT-PLUG-_SB.PR00*** - vedi `Iniezione X86`
- ***SSDT-EC*** - vedere `Apparecchiature contraffatte-EC contraffatte`
- ***SSDT-PNLF-CFL*** ——Vedere `Metodo di iniezione PNLF`
- ***SSDT-PMCR*** - vedi `Aggiungere parti mancanti`
- ***SSDT-SBUS*** ——Vedi `Patch SBUS / SMBU`
- ***SSDT-OCBAT1-lenovoPRO13*** - Vedi `Patch batteria`
- ***SSDT-I2CxConf*** ——Vedere `Componenti dedicati I2C`
- ***SSDT-OCI2C-TPXX-lenovoPRO13*** ——Vedere `Parti speciali I2C`
- ***SSDT-CB-01_XHC*** ——Vedere `Porta USB personalizzata ACPI`
- ***SSDT-GPRW*** ——Vedi `060D Patch`
- ***SSDT-RTC_Y-AWAC_N*** —— vedi `Rinomina binaria e variabili preimpostate`
- ***SSDT-RMCF-PS2Map-LenovoPRO13*** ——Questa patch del capitolo, fare riferimento a `Mappa della tastiera PS2`
- ***SSDT-OCPublic-Merge*** —— Patch in questo capitolo, vedere la descrizione dell '**allegato**
- ***SSDT-BATS-PRO13*** - vedi `Patch della batteria`

**Nota**: la modifica del nome richiesta dalla patch precedente si trova nel commento del file della patch corrispondente.

## Osservazioni

-Si prega di leggere `Metodo AOAC`

## Allegato: unione di patch comuni

-Per semplificare l'operazione e ridurre il numero di patch, alcune patch pubbliche sono state unite in: ***SSDT-OCPublic-Merge***.

#### Patch unita

- ***SSDT-EC-USBX*** —— **USBX** parte dall'esempio di patch ufficiale OC
- ***SSDT-ALS0*** —— La patch originale si trova in `Counterfeit Device-Counterfeit Ambient Light Sensor`
- ***SSDT-MCHC*** - La patch originale si trova in `Aggiungi parti mancanti`

#### Precauzioni

- ***SSDT-OCPublic-Merge*** si applica a tutte le macchine.
-Dopo aver utilizzato ***SSDT-OCPublic-Merge***, le patch elencate sopra **<u> Patch unite </u>** non sono più applicabili.

