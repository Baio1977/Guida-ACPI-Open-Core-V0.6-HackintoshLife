# Patch speciale macchina ThinkPad

## Rinomina speciale

Come alcune macchine Lenovo, il DSDT delle macchine ThinkPad può contenere anche il campo `PNLF`. Cerca `PNLF` in DSDT, se c'è` PNLF`, devi aggiungere il seguente rinomina:

```text
Find:     504E4C46
Replace:  584E4C46
```

## Patch speciale

### Iniezione degli attributi del touchpad ThinkPad e patch anti-deriva a piccoli punti rossi

Il touchpad e il punto rosso di ThinkPad appartengono al tipo ELAN e utilizzano il protocollo `Synaptics` per connettersi tramite SMBus. Poiché attualmente non esiste un driver SMBus che possa essere utilizzato stabilmente in macOS, è possibile utilizzare solo VoodooPS2. Quando si utilizza VoodooPS2, per abilitare l'ottimizzazione ThinkPad incorporata in VoodooPS2, è necessario inserire gli attributi del trackpad tramite SSDT.

**SSDT-ThinkPad_ClickPad**

Se il tuo trackpad è uno dei due mostrati nell'immagine qui sotto, usa questa patch..

![](https://i.loli.net/2020/04/26/ceEyQfgikqzjapL.png)

**SSDT-ThinkPad_TouchPad**

Se il tuo trackpad è uno dei due mostrati nell'immagine sotto, usa questa patch.

![](https://i.loli.net/2020/04/26/FUxIp4nmAb2PSws.png)

----

Il percorso della tastiera della maggior parte delle macchine ThinkPad è `\ _SB.PCI0.LPC.KBD` o` \ _SB.PCI0.LPCB.KBD`. Le due patch fornite usano `_SB.PCI0.LPC.KBD` per impostazione predefinita. Verificare personalmente il nome del bus LPC e il nome della tastiera originali rispetto al DSDT e sostituire il percorso ACPI.

Entrambe le patch comportano la modifica della variabile RMCF del dispositivo tastiera. Se si utilizza contemporaneamente la patch di mappatura PS2 nel capitolo "Mappatura tastiera PS2", è necessario unire manualmente i contenuti delle variabili RMCF. Vedi ** SSDT-ThinkPad_ClickPad + PS2Map-AtoZ ** per l'esempio di unione. Questa patch include anche l'iniezione degli attributi ThinkPad ClickPad e la mappatura A -> Z PS2 Map.

Inoltre, il VoodooPS2Controller di Rebhabman è obsoleto. Si consiglia di utilizzare [VoodooPS2] di acidanthera (https://github.com/acidanthera/VoodooPS2) e di utilizzare [VoodooInput] (https://github.com/acidanthera/VoodooInput) per abilitare ThinkPad All i gesti del touchpad.

----

Quanto segue è una spiegazione delle varie configurazioni in SSDT, che è stata scritta da [@SukkaW] (https://github.com/SukkaW) sulla base del [README] di Rehabman, manutentore originale di VoodooPS2 (https://github.com/RehabMan / OS- X-Voodoo-PS2-Controller / blob / master / README.md) e i commenti sul codice in VoodooPS2 sono stati risolti.

-DragLockTempMask: tasto di scelta rapida per il blocco del trascinamento temporaneo. "0x40004" corrisponde a Control, "0x80008" a Command e "0x100010" a Option. Va notato che queste sono le relazioni originali mappate sulla tastiera fisica e non sono influenzate dalla sequenza di tasti funzione impostata nelle "Preferenze di Sistema".
-DynamicEWMode: modalità Dynamic EW. In modalità EW, i gesti con due dita (come lo scorrimento con due dita) divideranno equamente la larghezza di banda del touchpad. Quando la modalità EW dinamica è abilitata, il touchpad non sarà sempre in modalità EW, quindi può migliorare la velocità di risposta di scorrimento a due dita del touchpad ThinkPad ClickPad. (Nota del traduttore: quando si scorre con due dita, solo due dita sono in contatto allo stesso tempo. Il pannello di controllo e quindi il touchpad restituiscono solo la direzione e la distanza di scorrimento di un dito, risparmiando la larghezza di banda dell'altro dito). Durante il trascinamento del file (Nota del traduttore, un dito tiene il touchpad e l'altro dito scorre) ClickPad verrà premuto e la modalità EW sarà ancora abilitata. Questa opzione ha causato problemi con alcuni touchpad, quindi è disabilitata per impostazione predefinita.
-FakeMiddleButton: simula il clic del pulsante centrale quando tocchi il trackpad con tre dita contemporaneamente.
-HWResetOnStart: alcuni dispositivi touchpad (in particolare il touchpad ThinkPad e il piccolo punto rosso) devono abilitare questa opzione per funzionare correttamente.
-ForcePassThrough e SkipPassThrough: Il dispositivo di input PS2 può inviare un tipo speciale di pacchetto di dati a 6 byte di "Pass Through", che può realizzare la trasmissione del segnale interleaved tra il touchpad e lo stick di puntamento (come il punto rosso ThinkPad). VoodooPS2 ha realizzato il riconoscimento automatico dei pacchetti "Pass Through" di tipo dispositivo PS2, queste due opzioni sono solo a scopo di debug.
-PalmNoAction durante la digitazione: il palmo della mano potrebbe toccare accidentalmente il touchpad durante la digitazione. Abilitando questa opzione si evitano i tocchi accidentali.
-SmoothInput: dopo aver abilitato questa opzione, il driver calcolerà la media ogni tre punti di campionamento per ottenere una traccia di movimento regolare.
-UnsmoothInput: Dopo aver abilitato questa opzione, quando si interrompe l'immissione sul touchpad, la media di campionamento verrà annullata e la posizione quando si inserisce interrotto viene utilizzata come posizione finale della traccia. Questo perché alla fine della traiettoria, la media del campionamento può causare grandi errori o persino invertire le traiettorie. Per impostazione predefinita, questa opzione e SmoothInput sono entrambe abilitate.
-DivisorX e DivisorY: Imposta la larghezza del bordo del touchpad. L'area del bordo non fornirà alcuna risposta.
-MomentumScrollThreshY: usa il touchpad per scorrere con due dita e continua a scorrere dopo che le dita lasciano il touchpad, come se ci fosse inerzia. Questa opzione è abilitata per impostazione predefinita per imitare il più possibile l'esperienza del trackpad dei dispositivi Mac.
-MultiFingerHorizontalDivisor e MultiFingerVerticalDivisor: alcuni touch panel hanno un'area "barra di scorrimento" dedicata all'estrema destra e / o in basso. Questa parte dell'area non risponde ai passaggi con più dita per impostazione predefinita. Queste due opzioni forniscono le impostazioni per la larghezza dell'area non reattiva. Il valore predefinito è 1, il che significa che l'intero touchpad può rispondere a sfioramenti con più dita.
-Risoluzione: La "risoluzione" del touchpad, l'unità è il numero di pixel per pollice, cioè quanti pixel verranno disegnati sullo schermo quando un dito scorre di un pollice sul touchpad.
-ScrollDeltaThresh: valore di tolleranza, utilizzato per evitare il problema del jitter quando si scorre con due dita su macOS 10.9 Maverick. Il valore predefinito è 10.
