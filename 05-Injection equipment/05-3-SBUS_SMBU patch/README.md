# SSDT-SBUS(SMBU) patch

## Device name

DSDT Search for `0x001F0003` (before the 6th generation) or `0x001F0004` (for the 6th generation and later) in DSDT to view the name of the device to which it belongs.

## patch

- The device name is `SBUS`，使用 ***SSDT-SBUS***
- The device name is `SMBU`，使用  ***SSDT-SMBU***
- The device name is another name, modify the patch related content by yourself

## Remarks

TP machines are mostly `SMBU`。
