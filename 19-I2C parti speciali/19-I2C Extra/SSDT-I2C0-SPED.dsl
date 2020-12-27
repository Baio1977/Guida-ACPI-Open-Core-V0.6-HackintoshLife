/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200925 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLQ2iCWC.aml, Sun Dec 27 01:31:45 2020
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x0000010D (269)
 *     Revision         0x02
 *     Checksum         0x26
 *     OEM ID           "hack"
 *     OEM Table ID     "I2C0SPED"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200925 (538970405)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "I2C0SPED", 0x00000000)
{
    External (_SB_.PCI0.I2C0, DeviceObj)
    External (FMD0, IntObj)
    External (FMH0, IntObj)
    External (FML0, IntObj)
    External (SSD0, IntObj)
    External (SSH0, IntObj)
    External (SSL0, IntObj)

    Scope (_SB.PCI0.I2C0)
    {
        If (_OSI ("Darwin"))
        {
            Method (PKGX, 3, Serialized)
            {
                Name (PKG, Package (0x03)
                {
                    Zero, 
                    Zero, 
                    Zero
                })
                PKG [Zero] = Arg0
                PKG [One] = Arg1
                PKG [0x02] = Arg2
                Return (PKG) /* \_SB_.PCI0.I2C0.PKGX.PKG_ */
            }
        }

        If (_OSI ("Darwin"))
        {
            Method (SSCN, 0, NotSerialized)
            {
                Return (PKGX (SSH0, SSL0, SSD0))
            }
        }

        If (_OSI ("Darwin"))
        {
            Method (FMCN, 0, NotSerialized)
            {
                Name (PKG, Package (0x03)
                {
                    0x0101, 
                    0x012C, 
                    0x62
                })
                Return (PKG) /* \_SB_.PCI0.I2C0.FMCN.PKG_ */
            }
        }
    }
}

