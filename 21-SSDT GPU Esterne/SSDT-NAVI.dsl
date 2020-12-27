/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200925 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLWEAbUm.aml, Sun Dec 27 10:23:37 2020
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000001E1 (481)
 *     Revision         0x02
 *     Checksum         0xF3
 *     OEM ID           "HACK"
 *     OEM Table ID     "NAVI"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200528 (538969384)
 */
DefinitionBlock ("", "SSDT", 2, "HACK", "NAVI", 0x00000000)
{
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.PEG0, DeviceObj)
    External (_SB_.PCI0.PEG0.PEGP, DeviceObj)

    Scope (\_SB)
    {
        Scope (PCI0)
        {
            Scope (PEG0)
            {
                Scope (PEGP)
                {
                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        If (_OSI ("Darwin"))
                        {
                            Return (Zero)
                        }
                        Else
                        {
                            Return (0x0F)
                        }
                    }
                }

                Device (EGP0)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    Method (_STA, 0, NotSerialized)  // _STA: Status
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

                    Device (EGP1)
                    {
                        Name (_ADR, Zero)  // _ADR: Address
                        Device (GFX0)
                        {
                            Name (_ADR, Zero)  // _ADR: Address
                            Name (_SUN, One)  // _SUN: Slot User Number
                            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                            {
                                If ((Arg2 == Zero))
                                {
                                    Return (Buffer (One)
                                    {
                                         0x03                                             // .
                                    })
                                }

                                Return (Package (0x02)
                                {
                                    "hda-gfx", 
                                    Buffer (0x0A)
                                    {
                                        "onboard-2"
                                    }
                                })
                            }
                        }

                        Device (HDAU)
                        {
                            Name (_ADR, One)  // _ADR: Address
                            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                            {
                                If ((Arg2 == Zero))
                                {
                                    Return (Buffer (One)
                                    {
                                         0x03                                             // .
                                    })
                                }

                                Return (Package (0x0A)
                                {
                                    "AAPL,slot-name", 
                                    "Built In", 
                                    "device_type", 
                                    Buffer (0x13)
                                    {
                                        "Controller HDMI/DP"
                                    }, 

                                    "name", 
                                    "High Definition Multimedia Interface", 
                                    "model", 
                                    Buffer (0x25)
                                    {
                                        "High Definition Multimedia Interface"
                                    }, 

                                    "hda-gfx", 
                                    Buffer (0x0A)
                                    {
                                        "onboard-2"
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }
}

