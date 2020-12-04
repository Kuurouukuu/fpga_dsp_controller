

/**
 * main.c
 */


#include "GlobalDefine.h"
#include "GlobalVariables.h"
#include "IQMathLib.h"
#include <stdlib.h>
#include "DSP28_Device.h"
#include "DSP28_Globalprototypes.h"
#include "DSP28_Gpio.h"
#include "calculateTrajectory.h"
#include "InterruptFunction.h"

extern interrupt void ExtIntISR(void);
extern interrupt void TXAISR(void);
extern interrupt void RXAISR(void);

void printRequestString(const char * requestString);
void printInfoString(const char * infoString);


/*unsigned long q1_max = 136; // With assumption that 546.5 pulse is one round
unsigned long q2_max = 2720;
unsigned long q3_max = 76160;*/

int main(void)
{
    InitSysCtrl();

    DINT;
    IER = 0x0000;
    IFR = 0x0000;

    InitPieCtrl();

    InitPieVectTable();

    InitXIntrupt();

    InitGpio();

    InitSci();

    InitValue();

    EALLOW;
    PieVectTable.XINT1 = &ExtIntISR;//External interrupt 1 of the interrupt vector table points to the interrupt service register function
    PieVectTable.TXAINT = &TXAISR;
    PieVectTable.RXAINT = &RXAISR;
    EDIS;

    IER |= M_INT1 | M_INT9;                  //PIE packet of external interrupt 1
    PieCtrl.PIEIER1.bit.INTx4 = 1;  //The 4th bit in PIE group 1 where external interrupt 1 is located
    PieCtrl.PIEACK.all = 0xFFFF;
    EINT;   // Enable Global interrupt INTM
    ERTM;   // Enable Global realtime interrupt DBGM

    //DEBUG:
    GpioDataRegs.GPADAT.bit.GPIOA0 = 1;
    GpioDataRegs.GPADAT.bit.GPIOA0 = 0;
    while (1)
    {
        if (start_flag == 1)
        {
            calculateTrajectory(); // Took while some time.
            start_flag = 0;
        }
    }

	return 0;
}

/* TODO: Working on changing trajectory online. Did not work as expected

*/
void printRequestString(const char * requestString)
{
    ;
}

void printInfoString(const char * infoString)
{
    ;
}




