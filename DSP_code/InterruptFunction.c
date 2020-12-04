/*
 * InterruptFunction.c
 *
 *  Created on: Nov 24, 2020
 *      Author: ASUS
 */

#include "DSP28_Device.h"
#include "GlobalVariables.h"
#include "CalculateTrajectory.h"

unsigned int i = 0;
int WR0, WR6, WR7, CMD;

interrupt void ExtIntISR(void)
{
    PieCtrl.PIEACK.all = 0xFFFF;  //Responding to interrupts, write 1 to clear 0, allowing INT1~INT12 to initiate interrupts to the CPU
    PieCtrl.PIEIFR1.bit.INTx4 = 0;//The corresponding interrupt flag register is cleared to 0
    start_flag = 1;
}

interrupt void TXAISR(void)
{
    PieCtrl.PIEACK.bit.ACK9 = 1; // Clear ACK (by write 1 into ack regs ) to enable other interrupt in group 9
    PieCtrl.PIEIFR9.bit.INTx2 = 0;//The corresponding interrupt flag register is cleared to 0
    // Do nothing
}

interrupt void RXAISR(void)
{// Interrupt
    PieCtrl.PIEACK.bit.ACK9 = 1; // Clear ACK (by write 1 into ack regs ) to enable other interrupt in group 9
    PieCtrl.PIEIFR9.bit.INTx1 = 0;//The corresponding interrupt flag register is cleared to 0
    WR0 = SciaRegs.SCIRXBUF.bit.RXDT;

    WR6 = SciaRegs.SCIRXBUF.bit.RXDT;
    WR6 =  (WR6 << 8) +SciaRegs.SCIRXBUF.bit.RXDT;

    WR7 =  SciaRegs.SCIRXBUF.bit.RXDT;
    WR7 =  (WR7 << 8) + SciaRegs.SCIRXBUF.bit.RXDT;

    SciaRegs.SCITXBUF = 0xFF; // FF is ACK
    if (WR0 == 0x04) // Set value
    {
        hVal[0] = WR6;
        hVal[0] = (hVal[0] << 16);
        hVal[0] |= (0x0000FFFF & WR7);
        hVal[0] = _IQ1((float)hVal[0]); // Update position
        k = 0; //Start counting number of samples again;
    }
    SciaRegs.SCIFFRX.bit.RXFFINTCLR = 1; // Clear FIFO interrupt flag
    SciaRegs.SCIFFRX.bit.RXFIFORESET = 0;
    SciaRegs.SCIFFRX.bit.RXFIFORESET = 1;
}


