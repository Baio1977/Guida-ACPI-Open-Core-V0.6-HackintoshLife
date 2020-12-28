# Metodo patch OCI2C-TPXX

## Descrizione

Questo metodo fornisce una soluzione per implementare le patch Hotpatch sui dispositivi I2C. Questo metodo non coinvolge il processo specifico e i dettagli della patch I2C. Per ulteriori informazioni su I2C, vedere:

- @ penghubingzhou: [https://www.penghubingzhou.cn] (https://www.penghubingzhou.cn)
- @ 神 楽 小白 (GZ 小白): [https://blog.gzxiaobai.cn/] (https://blog.gzxiaobai.cn/)
- @ 神 楽 小白 (GZ 小白) Libreria di esempi di hot patch per touchpad: [https://github.com/GZXiaoBai/Hackintosh-TouchPad-Hotpatch”(https://github.com/GZXiaoBai/Hackintosh-TouchPad- Hotpatch)
-Documento ufficiale di VoodooI2C: [https://voodooi2c.github.io/#GPIO%20Pinning/GPIO%20Pinning”(https://voodooi2c.github.io/#GPIO%20Pinning/GPIO%20Pinning)
-VoodooI2C post di supporto ufficiale [https://www.tonymacx86.com/threads/voodooi2c-help-and-support.243378/”(https://www.tonymacx86.com/threads/voodooi2c-help-and-support. 243378 /)
-Q gruppo: `837538729` (1 gruppo è pieno),` 921143329` (2 gruppi)

## Principio e processo della patch

-Proibire il dispositivo I2C originale. Vedere "Rinomina binaria e variabili preimpostate" per i dettagli.

  ```Swift
  /*
   * GPI0 enable
   */
  DefinitionBlock("", "SSDT", 2, "OCLT", "GPI0", 0)
  {
      External(GPEN, FieldUnitObj)
      // External(GPHD, FieldUnitObj)
      Scope (\)
      {
          If (_OSI ("Darwin"))
          {
              GPEN = 1
              // GPHD = 2
          }
      }
  }
  ```

-Crea un nuovo dispositivo I2C `TPXX` e migra tutti i contenuti del dispositivo originale in` TPXX`.

-Modifica il contenuto di `TPXX`:

  -Sostituisci tutto il `nome` del dispositivo I2C originale con `TPXX`

  - **Modifica** La parte `_STA` è:

    ```Swift
    Method (_STA, 0, NotSerialized)
    {
        If (_OSI ("Darwin"))
        {
            Return (0x0F)
        }
        Else
        {
            Return (Zero)
        }
    }
    ```
    
  - **Risolto** per vietare il `contenuto correlato` delle variabili utilizzate nel dispositivo I2C originale, in modo che sia conforme alla relazione logica.

  - **Risolto il problema con** il `contenuto rilevante` relativo alla variabile del sistema operativo OSYS per renderlo coerente con la relazione logica.

-Elimina gli errori.

-Patch I2C.

### Esempio (Dell Latitude 5480, percorso del dispositivo: `\ _SB.PCI0.I2C1.TPD1`)

-Utilizzare "Legge sulle variabili preimpostate" per vietare `TPD1`.


  ```Swift
  Scope (\)
  {
      If (_OSI ("Darwin"))
      {
          SDS1 = 0
      }
  }
  ```

-Crea un nuovo dispositivo `TPXX` e migra tutti i contenuti dell'originale` TPD1` in `TPXX`.


  ```Swift
  External(_SB.PCI0.I2C1, DeviceObj)
  Scope (_SB.PCI0.I2C1)
  {
      Device (TPXX)
      {
         原TPD1内容
      }
  }
  ```

-Modifica il contenuto di `TPXX`

   -Sostituisci tutto `TPD1` con` TPXX`.
  
   -Sostituisci la parte `_STA` della patch con:
  
    ```Swift
    Method (_STA, 0, NotSerialized)
    {
        If (_OSI ("Darwin"))
        {
            Return (0x0F)
        }
        Else
        {
            Return (Zero)
        }
    }
    ```
  
  -Cercare `SDS1` (variabile usata quando `TPD1` è proibito) e modificare l'originale `If (SDS1 ...)` in `If (uno)`.
  
  -Trova `OSYS` ed elimina (commenta) quanto segue:
  
    ```Swift
    //If (LLess (OSYS, 0x07DC))
    //{
    //    SRXO (GPDI, One)
    //}
    ```
   Nota: quando `OSYS` è minore di `0x07DC`, il dispositivo I2C non funziona (`0x07DC` sta per Windows8).
  
-Aggiungere il riferimento esterno `External ...` per correggere tutti gli errori.

-Patch I2C (omesso)
