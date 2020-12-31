# Dispositivo PCI ASPM

## Descrizione

- ASPM, **Active State Power Management**, è uno schema di gestione dei collegamenti elettrici supportato a livello di sistema. Sotto la gestione ASPM, i dispositivi PCI tentano di entrare in modalità di risparmio energetico quando sono inattivi.

- L'ASPM opera in diverse modalità
  - Modalità L0-Normale.
  - Modalità L0s-Standby. la modalità L0s consente di entrare e uscire velocemente dallo stato di inattività. il dispositivo viene posto ad un consumo di energia inferiore dopo essere entrato nello stato di inattività.
  - L1-Low power standby mode. l1 ridurrà ulteriormente il consumo di energia rispetto a L0s. Tuttavia, il tempo per entrare o uscire dallo stato di inattività è più lungo di L0s.
  - L2-Modalità di alimentazione ausiliaria. Un po'.

- Per le macchine con tecnologia `AOAC`, provare a cambiare la modalità ASPM di `Wireless NIC`, `SSD` per ridurre il consumo di energia della macchina.

## Impostare il modo operativo ASPM

### metodo di iniezione "Properties" [**uso preferito**].

- Iniettare il `pci-aspm-default` nel **dispositivo genitore** del PCI e nel suo **dispositivo per bambini** rispettivamente

  - **Dispositivo genitore**
    - Modo L0s/L1: `pci-aspm-default` = `03000000` [dati].
    - Modo L1: `pci-aspm-default` = `02000000` [dati
    - Disattivare ASPM: `pci-aspm-default` = `0000000000` [dati
  - **sottodispositivo**
    - Modo L0s/L1: `pci-aspm-default` = `03010000` [dati
    - Modo L1: `pci-aspm-default` = `02010000` [dati
    - Disattivare ASPM: `pci-aspm-default` = `0000000000` [dati

- Esempio

  L'ASPM di default della scheda wireless Xiaoxin PRO13 è L0s/L1, e il percorso del dispositivo è: `PciRoot(0x0)/Pci(0x1C,0x0)/Pci(0x0,0x0)` , fare riferimento al metodo sopra descritto, cambiare l'ASPM a L1 iniettando `pci-aspm-default` come segue
  
  ``testo
  PciRoot(0x0)/Pci(0x1C,0x0)
  pci-aspm-default = 0200000000
  ......
  PciRoot(0x0)/Pci(0x1C,0x0)/Pci(0x0,0x0)
  pci-aspm-default = 02010000
  ```

#### Metodo della patch "SSDT

- La patch SSDT può anche impostare il modo operativo ASPM. Ad esempio, impostare un dispositivo ASPM in modalità L1, vedere l'esempio.

- Il principio della patch è lo stesso di ``Disable PCI Devices``, vedi.

- Esempio: ***SSDT-PCI0.RPXX-ASPM***

  ````Swift
  Esterno (_SB.PCI0.RP05, DeviceObj)
  Ambito di applicazione (_SB.PCI0.RP05)
  Ambito di applicazione (_SB.PCI0.RP05) {
      OperationRegion (LLLL, PCI_Config, 0x50, 0x01)
      Campo (LLLL, AnyAcc, NoLock, Preserve)
      {
          L1, 1
      }
  }
  
  Ambito di applicazione (\)
  {
      Se (_OSI ("Darwin"))
      {
          \_SB.PCI0.RP05.L1 = Zero /* Set ASPM = L1 */
      }
  }
  ```

**Nota 1**: Il percorso della scheda wireless Xiaoxin PRO13 è `_SB.PCI0.RP05`.

**Nota 2**: `\_SB.PCI0.RP05.L1 = 1`, ASPM = L0s/L1; `\_SB.PCI0.RP05.L1 = 0`, ASPM = L1.

## Attenzione.

- Il tool ***Hackintool.app*** consente di visualizzare la modalità di funzionamento dell'apparecchio ASPM.
- Dopo aver cambiato ASPM, si prega di ripristinare ASPM se si verifica una condizione anomala.
