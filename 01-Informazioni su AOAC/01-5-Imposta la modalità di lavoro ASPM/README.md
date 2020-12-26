# Dispositivo PCI ASPM

## Descrizione

-ASPM è l'acronimo di Active State Power Management, che è una soluzione di gestione dei collegamenti di alimentazione supportata dal sistema. In Gestione ASPM, prova ad accedere alla modalità di risparmio energetico quando il dispositivo PCI è inattivo.

-ASPM diverse modalità di lavoro
  -L0: modalità normale.
  -L0s: modalità Standby. La modalità L0s può entrare o uscire rapidamente dallo stato di inattività Dopo essere entrato nello stato di inattività, il dispositivo viene posto in un consumo energetico inferiore.
  -L1 — Modalità standby a basso consumo energetico. Rispetto a L0s, L1 ridurrà ulteriormente il consumo di energia. Ma il tempo per entrare o uscire dallo stato di inattività è più lungo di L0s.
  -L2 — Modalità alimentazione ausiliaria. leggermente.

-Per macchine con tecnologia "AOAC", provare a cambiare la modalità ASPM di "scheda di rete wireless" e "SSD" per ridurre il consumo energetico della macchina.

## Imposta la modalità di lavoro ASPM

### Metodo di iniezione delle proprietà [** Uso preferito **]

-Iniettare `pci-aspm-default` separatamente dal PCI ** dispositivo genitore ** e dal suo ** dispositivo figlio **

  - ** Dispositivo genitore **
    -Modalità L0s / L1: `pci-aspm-default` =` 03000000` [dati]
    -Modalità L1: `pci-aspm-default` =` 02000000` [dati]
    -Forbido ASPM: `pci-aspm-default` =` 00000000` [dati]
  - ** Dispositivo secondario **
    -Modalità L0s / L1: `pci-aspm-default` =` 03010000` [dati]
    -Modalità L1: `pci-aspm-default` =` 02010000` [dati]
    -Forbido ASPM: `pci-aspm-default` =` 00000000` [dati]

-Esempio

  L'ASPM predefinito della scheda di rete wireless Xiaoxin PRO13 è L0s / L1 e il percorso del dispositivo è: `PciRoot (0x0) / Pci (0x1C, 0x0) / Pci (0x0,0x0)`, facendo riferimento al metodo precedente, iniettando `pci-aspm-default `Cambia ASPM in L1. come segue:
  
  `` testo
  PciRoot (0x0) / Pci (0x1C, 0x0)
  pci-aspm-default = 02000000
  ......
  PciRoot (0x0) / Pci (0x1C, 0x0) / Pci (0x0,0x0)
  pci-aspm-default = 02010000
  `` `

#### Metodo patch `SSDT`

-La patch SSDT può anche impostare la modalità di lavoro ASPM. Ad esempio, impostare l'ASPM di un determinato dispositivo sulla modalità L1, vedere l'esempio per i dettagli.

-Il principio della patch è lo stesso di "Proibire dispositivi PCI", fare riferimento ad esso.

-Esempio: *** SSDT-PCI0.RPXX-ASPM ***

  ```Swift
  External (_SB.PCI0.RP05, DeviceObj)
  Scope (_SB.PCI0.RP05)
  {
      OperationRegion (LLLL, PCI_Config, 0x50, 0x01)
      Field (LLLL, AnyAcc, NoLock, Preserve)
      {
          L1,   1
      }
  }
  
  Scope (\)
  {
      If (_OSI ("Darwin"))
      {
          \_SB.PCI0.RP05.L1 = Zero  /* Set ASPM = L1 */
      }
  }
  ```
  
  ** Nota 1 **: il percorso della scheda di rete wireless Xiaoxin PRO13 è `_SB.PCI0.RP05`.

  ** Nota 2 **: Quando `\ _SB.PCI0.RP05.L1 = 1`, ASPM = L0s / L1; quando` \ _SB.PCI0.RP05.L1 = 0`, ASPM = L1.

  ## Precauzioni

  -Lo strumento *** Hackintool.app *** può visualizzare la modalità di lavoro ASPM del dispositivo.
  -Dopo aver modificato l'ASPM, se si verifica una situazione anomala, ripristinare l'ASPM.
  Ulteriori informazioni su questo testo di originePer avere ulteriori informazioni sulla traduzione è necessario il testo di origine
  Invia commenti
  Riquadri laterali
