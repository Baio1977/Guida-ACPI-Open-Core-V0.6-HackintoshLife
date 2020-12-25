# Disable EHCx

## description

EHC1 and EHC2 buses need to be disabled in one of the following situations:

- ACPI includes EHC1 or EHC2, and the machine itself does not have related hardware.
-ACPI includes EHC1 or EHC2. The machine has related hardware but no actual output port (external and internal)。


## patch

- ***SSDT-EHC1_OFF***：Disable `EHC1`。
- ***SSDT-EHC2_OFF***：Disable `EHC2`。
- ***SSDT-EHCx_OFF***：It is the merged patchof ***SSDT-EHC1_OFF*** and ***SSDT-EHC2_OFF***。

## Instructions

- Priority BIOS setting: `XHCI Mode` = `Enabled`。
- If the BIOS does not have `XHCI Mode` the option, at the same time meet the **description of** one case, using the patch。

### Precautions

- Applicable to 7, 8, 9 series machines, and macOS is 10.11 or above.
- For 7 series machines,***SSDT-EHC1_OFF*** and ***SSDT-EHC2_OFF*** cannot be used at the same time。
- Patch  `Scope (\)`   under the added `_INI` method, and if other patches of `_INI` duplication, should merge `_INI` the contents。
