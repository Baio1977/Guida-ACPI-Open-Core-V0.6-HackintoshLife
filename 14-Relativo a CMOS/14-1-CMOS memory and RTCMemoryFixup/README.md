# CMOS Memoria e RTCMemoryFixup

## Descrizione

- Quando **AppleRTC** e **BIOS** sono in conflitto, puoi provare a utilizzare **RTCMemoryFixup** per simulare la memoria **CMOS** per evitare conflitti.
- **RTCMemoryFixup** Link per il download: <https://github.com/acidanthera/RTCMemoryFixup>

## **CMOS** Memoria

- **CMOS** La memoria memorizza dati importanti, come data, ora, informazioni sulla configurazione hardware, informazioni sulle impostazioni ausiliarie, impostazioni di avvio e informazioni sul sonno.

- **CMOS** Alcune definizioni di spazio di archiviazione:

  - Data, ora, configurazione hardware: `00-0D`
  - Area di memorizzazione delle informazioni sul sonno: `80-AB`
  - Gestione della potenza: `B0-B4`
  - altro

## Visualizza la memoria COMS

- `EFI \ OC \ Tools` installazione ***RtcRw.efi***
- Aggiungere ***RtcRw.efi*** `Project` nella configurazione
- Avviare l'interfaccia e immettere `Shell` (assicurarsi di aver installato ***OpenShell.efi***), accedere alla directory degli strumenti, immettere rtcrw per leggere XX e premere Invio. Dove XX è l'indirizzo di memoria CMOS. Ad esempio: rtcrw read 08 per visualizzare il mese corrente. Se il mese è maggio, il risultato è 0x05 (codice BCD).


## Analogico **Memoria CMOS**

- Installa **RTCMemoryFixup** in OC \ Kexts e aggiungi l'elenco dei driver.

- Boot **`boot-args`** Aggiungi` rtcfx_exclude = ... `

   Formato: `rtcfx_exclude = offset1, offset2, start_offset-end_offset, ...` Simile: `rtcfx_exclude = 0D`,` rtcfx_exclude = 40-AF`, `rtcfx_exclude = 2A, 2D, 80-AB, ecc.


## Precauzione

- Analog memoria **CMOS** cancellerà la funzione definita originale, si prega di **usarla con cautela**. Ad esempio: `rtcfx_exclude = 00-0D` farà sì che la data e l'ora della macchina non vengano più aggiornate durante il periodo di sospensione.

## Appendice: Definizione della memoria **CMOS** 00-3F 

| Descrizione indirizzo
| ----- | ------------------------------------------- ------- ----------------------------- |
| `0` | secondi
| `1` | Secondo allarme
| `2` | punto |
| `3` | Sub-alert |
| `4` | Orario lavorativo
| `5` | Allarme puntuale |
| `6` | settimana |
| `7` | giorno
| `8` | Mese |
| `9` | anno |
| `A` | Registro di stato A |
| `B` | Registro di stato B |
| `C` | Registro di stato C |
| `D` | Registro di stato D (0: batteria guasta; 80: batteria valida) |
| `E` | Byte di stato diagnostico |
| `F` | Byte di stato di arresto (definizione per diagnosi di avvio) |
| `10` | Tipo di unità disco floppy (Bit 7-4: Unità A, Bit 3-0: Unità B 1-360KB; 2-1,2MB; 6-1,44MB; 7-720KB) |
| `11` | Riservato |
| `12` | Tipo di disco rigido (bit 7-4: unità C, bit 3-0: unità D) |
| `13` | Riservato |
| `14` | Byte del dispositivo (numero di unità floppy, tipo di visualizzazione, coprocessore) |
| `15` | Low byte di memoria di base |
| `16` | Byte alto di memoria di base |
| `17` | Byte basso di memoria estesa |
| `18` | Byte alto di memoria estesa |
| `19` | Primo tipo di disco rigido principale |
| 1A | Primo tipo di disco rigido slave |
| `1B - 1C` | Riservato |
| `1D - 24` | Il cilindro, la testata, l'allineamento, ecc. Del primo disco rigido principale |
| `25—2C` | Il primo cilindro del disco rigido slave, testina magnetica, coassiale, ecc. |
| `2D` | Riservato |
| `2E - 2F` | checksum CMOS (somma 10-2D di ogni byte) |
| `30` | Memoria estesa byte basso |
| `31` | Byte alto di memoria estesa |
| `32` | Data secolo Byte (19H: XIX secolo) |
| `33` | Cartello informativo |
| `34—3F` | Riservato |
