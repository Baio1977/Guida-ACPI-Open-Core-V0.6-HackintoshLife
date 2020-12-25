# OC-PNLF injection method

## Brightness (`PNLF`) The composition of the control part

- drive:

  - WhateverGreen.kext built-in brightness driver (requires Lilu.kext)

   By default, WhateverGreen.kext will load the brightness driver. If you use other brightness drivers, you should disable its built-in brightness driver.

    - Disable method:

      - Add boot parameters `applbkl=0`
      - Modify the drive `Info.plist\IOKitPersonalities\AppleIntelPanelA\IOProbeScore=5500`。

    - Download link:：<https://github.com/acidanthera/WhateverGreen/releases>

  - IntelBacklight.kext
  
    - Download link: <https://bitbucket.org/RehabMan/os-x-intel-backlight/src/master/>
  
  - ACPIBacklight.kext
  
    - Download link: <https://bitbucket.org/RehabMan/os-x-acpi-backlight/src/master/>
  
- patch

  - Custom brightness patch

    - ***SSDT-PNLF-SNB_IVY*** : 2nd and 3rd generation brightness patch.
    - ***SSDT-PNLF-Haswell_Broadwell***: 4th and 5th generation brightness patch.
    - ***SSDT-PNLF-SKL_KBL***：6th and 7th generation brightness patch.
    - ***SSDT-PNLF-CFL***：8th generation + brightness patch

The above patch is inserted in`_SB`。

  - RehabMan Brightness Patch
  
    - [https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-PNLF.dsl](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-PNLF.dsl)
  
    - [https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-PNLFCFL.dsl](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-PNLFCFL.dsl)
  
    - [https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-RMCF.dsl](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-RMCF.dsl)
  
  Inserted into the patch RehabMan brightness  `_SB.PCI0.IGPU`，when using the patch file `IGPU` , is renamed to the original name ACPI （such as:：`GFX0`）。

## Common injection methods

- Drive: WhateverGreen
- Patch: Custom brightness patch or RehabMan brightness patch

## ACPI injection method

- Driver: ACPIBacklight.kext (Need to disable WhateverGreen.kext built-in brightness driver, see the disable method above)
- Patch: See "ACPI Brightness Patch" method

## Other injection methods

Try it yourself according to the principle of driver + patch.

## Precautions

- When selecting an injection method, the drivers, patches, settings, etc. related to other methods should be cleared.

- When using a custom brightness patch, the patch is to be noted in`_SB`the next injection`PNLF`device, when the original  `ACPI`exists in`PNLF`the time field, need to be renamed, otherwise it will affect`Windows`can also be used . Renamed as follows:[`RehabManPatches](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/tree/master/hotpatch)。更名如下：

  ```text
  // PNLF to XNLF
  Find:    504E 4C46
  Replace: 584E 4C46
  ```
