## Scheda audio IRQ Patch

## Descrizione

- La scheda audio sulle macchine precedenti richiedeva la parte **HPET** **`PNP0103`** per fornire i numeri di interrupt `0` e `8`, altrimenti la scheda audio non avrebbe funzionato correttamente. In pratica quasi tutte le macchine hanno **HPET** che non forniscono numeri di interruzione. Normalmente, i numeri di interrupt `0` e `8` sono occupati da **RTC** **`PNP0B00`**, **TIMR** **`PNP0100`** rispettivamente
- Per risolvere il problema di cui sopra sono necessarie correzioni simultanee di **HPET**, **RTC**, **TIMR**.

## Principio della toppa

- Disattivare **HPET**, **RTC**, **TIMR** tre parti.
- Contraffare tre parti, cioè, **HPE0**, **RTC0**, **TIM0**.
- Rimuovere le `IRQNoFlags (){8}` da **RTC0** e `IRQNoFlags (){0}` da **TIM0** e aggiungere a **HPE0**.

## Metodo Patch

- Disattivare **HPET**, **RTC**, **TIMR**
  - **HPET**.
  
    Normalmente `_STA` è presente per HPET, quindi la disabilitazione di HPET richiede l'uso del metodo a variabili preimpostate. Per esempio.
  
    ````Swift
    Esterno (HPAE, IntObj) /* o esterno (HPTE, IntObj) */
    Ambito di applicazione (\)
    {
        Se (_OSI ("Darwin"))
        {
            HPAE =0 /* o HPTE =0 */
        }
    }
    ```
  
    Nota: La variabile `HPAE` all'interno di `_STA` può variare da macchina a macchina.
  
  - **RTC**  
  
    Le macchine precedenti hanno RTC senza `_STA`, disabilitare gli RTC premendo il `Metodo (_STA,` metodo. ad es.
  
    ````Swift
    Metodo (_STA, 0, non serializzato)
    {
        Se (_OSI ("Darwin"))
        {
            Ritorno (0)
        }
        Altrimenti
        {
            Ritorno (0x0F)
        }
    }
    ```
  
  - **TIMR**
  
    Come **RTC**
  
- File di patch:***SSDT-HPET_RTC_TIMR-fix***

  Vedi **Patch Principle** sopra per un esempio di riferimento.
  
  **Topcharge**
  
  Anche se le prime piattaforme (il mobile Intel 3 Ivy Bridge di generazione Ivy è il più comune) avevano comunemente problemi di `IRQ` che causavano il mancato funzionamento della scheda audio a bordo, come dimostrato da `AppleHDA.kext` che non riusciva a caricare e caricava solo `AppleHDAController.kext`, alcune macchine sulle piattaforme più recenti hanno ancora questo problema. Questo problema è dovuto al fatto che HPET è già un dispositivo obsoleto delle piattaforme Intel di generazione 6 ed è riservato solo come compatibile con le versioni precedenti dei sistemi, se si utilizzano piattaforme di generazione 6 o superiori e la versione di sistema Windows 8.1 + ha HPET (High Precision Event Timer) nel Device Manager è già nello stato di driver scaricato.
  Per macOS 10.12+, se il problema si verifica su piattaforme hardware Gen 6+, HPET può essere bloccato direttamente.
    
## Attenzione

- Questo cerotto non deve essere usato in combinazione con i seguenti cerotti.
  - ***SSDT-RTC_Y-AWAC_N*** delle variabili di rinomina binaria e di preimpostazione
  - Ufficiale di OC ***SSDT-AWAC****
  - Dispositivi di contraffazione" o il funzionario di OC ***SSDT-RTC0***
  - La patch di reset CMOS ***SSDT-RTC0-NoFlags***
- Il nome `LPCB`, il nome **Tri-Part** e il nome `IPIC` dovrebbero essere gli stessi del nome originale della parte `ACPI`.
- Se il cerotto tre in uno non si risolve, provare ***SSDT-IPIC*** con il cerotto tre in uno al suo posto. Disattivare il dispositivo ***IPIC*** come descritto sopra per ***HPET***, ***RTC*** e ***TIMR***, quindi impersonare un dispositivo ***IPI0*** con il contenuto del dispositivo ***IPIC*** o ***PIC*** nell'originale DSDT , e infine Basta rimuovere `IRQNoFlags{2}`, fare riferimento all'esempio.
