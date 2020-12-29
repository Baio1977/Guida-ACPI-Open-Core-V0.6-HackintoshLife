# CMOS correlato

## Patch di ripristino CMOS

### Descrizione

- Alcune macchine appariranno **`Errore di autotest all'accensione`** all'arresto o al riavvio, causato dal ripristino del CMOS.
- Quando si utilizza Clover, selezionare `ACPI \ FixRTC` per risolvere i problemi di cui sopra.
- Quando si utilizza OpenCore, vengono fornite ufficialmente le seguenti soluzioni, vedere ***Sample.plist***:
  - Installa **RTCMemoryFixup.kext**
  - Patch `Kernel \ Patch`: **__ ZN11BCM5701Enet14getAdapterInfoEv**
- Questo capitolo fornisce un metodo patch SSDT per risolvere i problemi di cui sopra. Questa patch SSDT è essenzialmente un RTC contraffatto, vedere `Preset Variable Method` e `Counterfeit Equipment`.

### soluzione

Vedere `Patch di ripristino 15-1-CMOS` per i dettagli.

## **CMOS** Memoria e RTCMemoryFixup

- Quando **AppleRTC** e **BIOS** sono in conflitto, puoi provare a utilizzare **RTCMemoryFixup** per simulare la memoria **CMOS** per evitare il conflitto.
- **RTCMemoryFixup** link per il download: <https://github.com/acidanthera/RTCMemoryFixup>

### **CMOS** Memoria

- **CMOS** La memoria memorizza dati importanti come data, ora, informazioni sulla configurazione hardware, informazioni sulle impostazioni ausiliarie, impostazioni di avvio e informazioni sul sonno.
- Alcune definizioni di spazio di memoria **CMOS**:
  - Data e ora: `00-0D`
  - Area di memorizzazione delle informazioni sul sonno: `80-AB`
  - Risparmio energetico: `B0-B4`
  - Altro

### Metodo di memoria **CMOS** di simulazione

Vedere `Memoria 15-2-CMOS e RTCMemoryFixup` per i dettagli.
