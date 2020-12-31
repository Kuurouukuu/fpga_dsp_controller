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

interrupt void ExtIntISR(void) // SamplingTime interrupt
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
    switch (WR0)
    {
        case 0x00:
        {
            q3_max = WR6;
            q3_max = (q3_max << 16);
            q3_max |= (0x0000FFFF & WR7);
            //q3_max = _IQ1((float)hVal[0]); // Update position
            break;
        }
        case 0x02:
        {
            q2_max = WR6;
            q2_max = (q2_max << 16);
            q2_max |= (0x0000FFFF & WR7);
            //q3_max = _IQ1((float)hVal[0]); // Update position
            break;
        }
        case 0x04:
        {
            hVal[0] = WR6;
            hVal[0] = (hVal[0] << 16);
            hVal[0] |= (0x0000FFFF & WR7);
            hVal[0] = _IQ1((float)hVal[0]); // Update position
            k = 0; //Start counting number of samples again;
            break;
        }
        case 0x05:
        {
            q1_max = WR6;
            q1_max = (q1_max << 16);
            q1_max |= (0x0000FFFF & WR7);
            break;
        }
        case 0x14:
        {
            hVal_motor2[0] = WR6;
            hVal_motor2[0] = (hVal_motor2[0] << 16);
            hVal_motor2[0] |= (0x0000FFFF & WR7);
            hVal_motor2[0] = _IQ1((float)hVal_motor2[0]); // Update position
            k_motor2 = 0; //Start counting number of samples again;
            break;
        }
        case 0x24:
        {
            hVal_motor3[0] = WR6;
            hVal_motor3[0] = (hVal_motor3[0] << 16);
            hVal_motor3[0] |= (0x0000FFFF & WR7);
            hVal_motor3[0] = _IQ1((float)hVal_motor3[0]); // Update position
            k_motor3 = 0; //Start counting number of samples again;
            break;
        }
        case 0x34:
        {
            hVal_motor4[0] = WR6;
            hVal_motor4[0] = (hVal_motor4[0] << 16);
            hVal_motor4[0] |= (0x0000FFFF & WR7);
            hVal_motor4[0] = _IQ1((float)hVal_motor4[0]); // Update position
            k_motor4 = 0; //Start counting number of samples again;
            break;
        }
    }
    SciaRegs.SCIFFRX.bit.RXFFINTCLR = 1; // Clear FIFO interrupt flag
    SciaRegs.SCIFFRX.bit.RXFIFORESET = 0;
    SciaRegs.SCIFFRX.bit.RXFIFORESET = 1;
}


