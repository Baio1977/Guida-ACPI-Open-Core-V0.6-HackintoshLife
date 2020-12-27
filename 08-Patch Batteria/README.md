# Battery information auxiliary patch

## Overview

-The newer ***VirtualSMC.kext*** and its components ***kext*** [after August 14] provide an interface for displaying battery auxiliary information. Through the customized SSDT patch, the battery's `PackLotCode`, `PCBLotCode`, `firmware version`, `hardware correction` and `battery correction` can be displayed under the action of the driver.
-This patch comes from the official patch of ***VirtualSMC.kext*** with some adjustments
-This patch and the `battery` patch have no master-slave relationship. Non-essential!
-This patch applies to all laptops

### Patch Notes

-In the ACPI specification, `_BST` defines some battery information, and the patch uses the methods `CBIS` and `CBSS` to inject this information. For details on the definition of `_BST`, please refer to the ACPI specification
-The practical application of `CBSS` could not be found in the example, just use `Return (Buffer (Zero){})`. **Note** `CBSS` content cannot be deleted
-In order to be able to work on **machines that do not need a `battery` patch**, the example patch adds the B1B2 method under the battery path

### SSDT-BATS-PRO13 example

-`Battery` path: `_SB.PCI0.LPCB.H_EC.BAT1`

  When using, ensure that the battery path of the original ACPI is consistent with the battery path of the example
-`CBIS` method
  
  -Find the corresponding variable according to the content of `_BST`, and press `low byte` and `high byte` to write B1B2. For example: PKG1 [0x02]=B1B2 (`FUSL`, `FUSH` ), if this variable is double-byte, please refer to the battery patch split data method to split the data and redefine the data
  -If you can't confirm the variables, you can also view battery-related information [**Not verified**] under win or Linux, and fill in directly. For example: `Firmware version` is 123, directly set PKG1 [0x04] = B1B2 (0x23, 0x01)

-`CBSS` method

  The data filling method is the same as `CBIS`. If you don't need to fill in any content, use `Return (Buffer (Zero)())`
