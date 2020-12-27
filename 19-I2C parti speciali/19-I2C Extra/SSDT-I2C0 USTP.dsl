/*
 * Find USTP:          55 53 54 50 08
 * Replace XSTP:       58 53 54 50 08
 */
DefinitionBlock ("", "SSDT", 2, "hack", "I2C", 0x00000000)
{
    External (_SB_.PCI0.I2C1, DeviceObj)

    Scope (_SB.PCI0.I2C1)
    {
        If (_OSI ("Darwin"))
        {
            Name (USTP, One)
        }
    }
}
