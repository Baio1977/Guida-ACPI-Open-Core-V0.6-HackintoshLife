# Aggiungi parti mancanti

## Descrizione

L'aggiunta di parti mancanti è solo una soluzione perfetta, non necessaria!

### Istruzioni per l'uso

** DSDT: **

-Cerca `PNP0200`, se manca, aggiungi *** SSDT-DMAC ***.

-Cerca `MCHC`, se manca, aggiungi *** SSDT-MCHC ***.

-Cerca `PNP0C01`, se manca, aggiungi *** SSDT-MEM2 ***.

-Cerca `0x00160000`, se manca, aggiungi *** SSDT-IMEI ***.

-Per macchine di sesta generazione e superiori, cerca "0x001F0002", se mancante, aggiungi *** SSDT-PPMC ***.

-Per macchine di 8a generazione e superiori, cerca `PMCR` e` APP9876`, se mancano, aggiungi *** SSDT-PMCR ***.

  Nota: @ 请 叫 我 官人 Fornisci il metodo, che è diventato l'esempio SSDT ufficiale di OpenCore.
  > Il chipset Z390 PMC (D31: F2) può essere avviato solo tramite MMIO. Poiché non è presente alcun dispositivo PMC nella specifica ACPI, Apple ha introdotto il proprio nome "APP9876" per accedere a questo dispositivo dal driver AppleIntelPCHPMC. In altri sistemi operativi, generalmente utilizzare `HID: PNP0C02`,` UID: PCHRESV` per accedere a questo dispositivo.
  > Le piattaforme che includono APTIO V non possono leggere o scrivere NVRAM (congelata in modalità SMM) prima di inizializzare il dispositivo PMC.
  > Anche se non so perché questo accada, vale la pena notare che PMC e SPI si trovano in aree di memoria diverse.PCHRESV mappa queste due aree contemporaneamente, ma AppleIntelPCHPMC di Apple mappa solo l'area in cui si trova PMC.
  > Il dispositivo PMC non ha nulla a che fare con il bus LPC.Questo SSDT serve esclusivamente per velocizzare l'inizializzazione di PMC e aggiungere il dispositivo al bus LPC. Se viene aggiunto al bus PCI0, PMC verrà avviato solo dopo che la configurazione PCI è stata completata, il che è troppo tardi per l'operazione che deve leggere la NVRAM.

-Cerca `PNP0C0C`, se manca, aggiungi *** SSDT-PWRB ***.

-Cercare "PNP0C0E", se manca, è possibile aggiungere *** SSDT-SLPB ***, "PNP0C0E Metodo di correzione del sonno" richiede questo componente.

### Nota

Quando si utilizzano alcune delle patch precedenti, si noti che il nome di "LPCB" dovrebbe essere coerente con il nome ACPI originale.
