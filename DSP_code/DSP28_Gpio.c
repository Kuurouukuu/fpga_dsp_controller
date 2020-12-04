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
    GpioMuxRegs.GPAMUX.bit.PWM1_GPIOA0 = 0; // Use GPIOA0 as GPIO
    GpioMuxRegs.GPADIR.bit.GPIOA0 = 1; // GPIOA0 as Output
    GpioMuxRegs.GPAMUX.bit.PWM1_GPIOA1 = 0; // Use GPIOA1 as GPIO
    GpioMuxRegs.GPADIR.bit.GPIOA1 = 1; // GPIOA1 as Output
    EDIS;
}	
	
//===========================================================================
// No more.
//===========================================================================
