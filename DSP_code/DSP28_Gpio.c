//
//      TMDX ALPHA RELEASE
//      Intended for product evaluation purposes
//
//###########################################################################
//
// FILE:	DSP28_Gpio.c
//
// TITLE:	DSP28 General Purpose I/O Initialization & Support Functions.
//
//###########################################################################
//
//  Ver | dd mmm yyyy | Who  | Description of changes
// =====|=============|======|===============================================
//  0.55| 06 May 2002 | L.H. | EzDSP Alpha Release
//  0.56| 20 May 2002 | L.H. | No change
//  0.57| 27 May 2002 | L.H. | No change
//###########################################################################

#include "DSP28_Device.h"

//---------------------------------------------------------------------------
// InitGpio: 
//---------------------------------------------------------------------------
// This function initializes the Gpio to a known state.
//
void InitGpio(void)
{
    EALLOW;
    // GPIO A0 for done signal
    GpioMuxRegs.GPAMUX.bit.PWM1_GPIOA0 = 0; // Use GPIOA0 as GPIO
    GpioMuxRegs.GPADIR.bit.GPIOA0 = 1; // GPIOA0 as Output
    // GPIO A1 for rotating direction
    GpioMuxRegs.GPAMUX.bit.PWM2_GPIOA1 = 0; // Use GPIOA1 as GPIO
    GpioMuxRegs.GPADIR.bit.GPIOA1 = 1; // GPIOA1 as Output
    // GPIO A2 for encoder requirement
    GpioMuxRegs.GPAMUX.bit.PWM3_GPIOA2 = 0; // Use GPIOA2 as GPIO
    GpioMuxRegs.GPADIR.bit.GPIOA2 = 1; // GPIOA2 as Output
    // GPIO A3 for calculating indicator
    GpioMuxRegs.GPAMUX.bit.PWM4_GPIOA3 = 0; // Use GPIOA2 as GPIO
    GpioMuxRegs.GPADIR.bit.GPIOA3 = 1; // GPIOA2 as Output
    EDIS;
}	
	
//===========================================================================
// No more.
//===========================================================================
