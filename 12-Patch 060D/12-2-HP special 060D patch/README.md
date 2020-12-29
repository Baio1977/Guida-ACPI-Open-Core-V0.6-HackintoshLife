# Patch speciale HP `0D6D`

- Per il contenuto correlato di `0D/6D patch`, fare riferimento ad alcuni `0D6D Patch`

Macchine HP, alcune parti di `ACPI` (relative a` 0D6D`) `_PRW` Il metodo è il seguente:

  ```swift 
  Method (_PRW, 0, NotSerialized) 
  { 
      Local0 = Package (0x02) 
      { 
          Zero, 
          Zero 
      } 
      Local0 [Zero] = 0x6D 
      If ((USWE == One)) /* Note USWE */ 
      { 
          Local0 [One] = 0x03 
      } 
      Return (Local0) 
  } 
  ```In 

  Questa situazione può essere realizzata utilizzando il `Metodo variabile preimpostata`Patch 0D/6D , come ad esempio:

  ```swift 
  Scope (\) 
  { If (_OSI ("Darwin ")) 
      { 
          USWE = 0 
      }
  } 
  ``` 

- Example: ***SSDT-0D6D-HP*** 

   ***SSDT-0D6D-HP*** Applicabile a `HP 840 G3`, la patch corregge` XHC`, `GLAN` di` _PRW `Valore di ritorno

- File di esempio di riferimento per altre macchine con situazioni simili.
