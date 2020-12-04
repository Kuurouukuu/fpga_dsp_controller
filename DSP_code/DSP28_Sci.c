//
//      TMDX ALPHA RELEASE
//      Intended for product evaluation purposes
//
//###########################################################################
//
// FILE:	DSP28_Sci.c
//
// TITLE:	DSP28 SCI Initialization & Support Functions.
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
// InitSPI: 
//---------------------------------------------------------------------------
// This function initializes the SPI(s) to a known state.
//
void InitSci(void)
{
	// Initialize SCI-A:

	EALLOW; // To edit Protected register
	GpioMuxRegs.GPFMUX.bit.SCITXDA_GPIOF4 = 1; //Enable SPI in GPIOMUX
	GpioMuxRegs.GPFMUX.bit.SCIRXDA_GPIOF5 = 1;
	EDIS;

	SciaRegs.SCICCR.all = 0x07; // 1 bit stop, disable parity, idle mode, 8 bits data
	SciaRegs.SCICTL1.all = 0x03; // No RX error interrupt, reset SCICTL2 and SCIRXST, no using TxWake, no sleep, Enable TX and RX
	SciaRegs.SCICTL2.all = 0x03; // Enable RX and TX interrupt
	SciaRegs.SCIHBAUD = 0x00;
	SciaRegs.SCILBAUD = 0xF3; //LSPCLOCK is 37.5Mhz, using datasheet, 0x00F3 is 19200 baud rate
	SciaRegs.SCICTL1.all = 0x23; // No RX error interrupt, reset SCICTL2 and SCIRXST, no using TxWake, no sleep, Enable TX and RX

	//Using FIFO to buffer 4 byte
	SciaRegs.SCIFFTX.bit.SCIFFENA = 1; // Enable SCIA FIFO buffer
	SciaRegs.SCIFFRX.bit.RXFFIL = 5; // Interrupt when FIFO is 10 word (10 byte),
	SciaRegs.SCIFFRX.bit.RXFFIENA = 1; // Enable FIFO interrupt for receiver

	//Enable Interrupt PIE for TX and RX
	PieCtrl.PIEIER9.bit.INTx1 = 1; // Enable SCI RX INT A
	PieCtrl.PIEIER9.bit.INTx2 = 1; // Enable SCI TX INT A

}	
//===========================================================================
// No more.
//===========================================================================
