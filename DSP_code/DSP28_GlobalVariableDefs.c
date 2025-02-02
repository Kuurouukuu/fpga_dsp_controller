//
//      TMDX ALPHA RELEASE
//      Intended for product evaluation purposes
//
//###########################################################################
//
// FILE:	DSP28_GlobalVariableDefs.c
//
// TITLE:	DSP28 Global Variables and Data Section Pragmas.
//
//###########################################################################
//
//  Ver | dd mmm yyyy | Who  | Description of changes
// =====|=============|======|===============================================
//  0.55| 06 May 2002 | L.H. | EzDSP Alpha Release
//  0.56| 21 May 2002 | L.H. | Corrected case typo - PIE -> Pie
//  0.57| 27 May 2002 | L.H. | No change
//###########################################################################



//---------------------------------------------------------------------------
// Define Global Peripheral Variables:
//

#include "DSP28_Device.h"

#pragma DATA_SECTION(AdcRegs,"AdcRegsFile");
volatile struct ADC_REGS AdcRegs;

#pragma DATA_SECTION(CpuTimer0Regs,"CpuTimer0RegsFile");
volatile struct CPUTIMER_REGS CpuTimer0Regs;

#pragma DATA_SECTION(CpuTimer1Regs,"CpuTimer1RegsFile");
volatile struct CPUTIMER_REGS CpuTimer1Regs;

#pragma DATA_SECTION(CpuTimer2Regs,"CpuTimer2RegsFile");
volatile struct CPUTIMER_REGS CpuTimer2Regs;

#pragma DATA_SECTION(ECanaRegs,"ECanaRegsFile");
volatile struct ECAN_REGS ECanaRegs;

#pragma DATA_SECTION(ECanaMboxes,"ECanaMboxesFile");
volatile struct ECAN_MBOXES ECanaMboxes;

#pragma DATA_SECTION(EvaRegs,"EvaRegsFile");
volatile struct EVA_REGS EvaRegs;

#pragma DATA_SECTION(EvbRegs,"EvbRegsFile");
volatile struct EVB_REGS EvbRegs;

#pragma DATA_SECTION(GpioDataRegs,"GpioDataRegsFile");
volatile struct GPIO_DATA_REGS GpioDataRegs;

#pragma DATA_SECTION(GpioMuxRegs,"GpioMuxRegsFile");
volatile struct GPIO_MUX_REGS GpioMuxRegs;

#pragma DATA_SECTION(McbspaRegs,"McbspaRegsFile");
volatile struct MCBSP_REGS McbspaRegs;

#pragma DATA_SECTION(PieCtrl,"PieCtrlRegsFile");
volatile struct PIE_CTRL_REGS PieCtrl;

#pragma DATA_SECTION(PieVectTable,"PieVectTable");
struct PIE_VECT_TABLE PieVectTable;

#pragma DATA_SECTION(SciaRegs,"SciaRegsFile");
volatile struct SCI_REGS SciaRegs;

#pragma DATA_SECTION(ScibRegs,"ScibRegsFile");
volatile struct SCI_REGS ScibRegs;

#pragma DATA_SECTION(SpiaRegs,"SpiaRegsFile");
volatile struct SPI_REGS SpiaRegs;

#pragma DATA_SECTION(SysCtrlRegs,"SysCtrlRegsFile");
volatile struct SYS_CTRL_REGS SysCtrlRegs;

#pragma DATA_SECTION(DevEmuRegs,"DevEmuRegsFile");
volatile struct DEV_EMU_REGS DevEmuRegs;

#pragma DATA_SECTION(CsmRegs,"CsmRegsFile");
volatile struct CSM_REGS CsmRegs;

#pragma DATA_SECTION(CsmPwl,"CsmPwlFile");
volatile struct CSM_PWL CsmPwl;

#pragma DATA_SECTION(FlashRegs,"FlashRegsFile");
volatile struct FLASH_REGS FlashRegs;

#pragma DATA_SECTION(XintfRegs,"XintfRegsFile");
volatile struct XINTF_REGS XintfRegs;

#pragma DATA_SECTION(XIntruptRegs,"XIntruptRegsFile");
volatile struct XINTRUPT_REGS XIntruptRegs;

// My variable memory mapping

#pragma DATA_SECTION(hVal,"hval");
long hVal[2]; // used as _iq

#pragma DATA_SECTION(qVal_3,"qval3");
long qVal_3[2]; // used as _iq

#pragma DATA_SECTION(velocity, "velocity");
unsigned long velocity;

#pragma DATA_SECTION(divisor, "divisor");
unsigned long divisor;

#pragma DATA_SECTION(encoder, "encoder");
unsigned long encoder;

// Motor 2

#pragma DATA_SECTION(hVal_motor2,"hVal_motor2");
long hVal_motor2[2]; // used as _iq

#pragma DATA_SECTION(qVal_3_motor2,"qval3_motor2");
long qVal_3_motor2[2]; // used as _iq

#pragma DATA_SECTION(velocity_motor2, "velocity_motor2");
unsigned long velocity_motor2;

#pragma DATA_SECTION(divisor_motor2, "divisor_motor2");
unsigned long divisor_motor2;


// Motor 3

#pragma DATA_SECTION(hVal_motor3,"hVal_motor3");
long hVal_motor3[2]; // used as _iq

#pragma DATA_SECTION(qVal_3_motor3,"qval3_motor3");
long qVal_3_motor3[2]; // used as _iq

#pragma DATA_SECTION(velocity_motor3, "velocity_motor3");
unsigned long velocity_motor3;

#pragma DATA_SECTION(divisor_motor3, "divisor_motor3");
unsigned long divisor_motor3;

// Motor 4

#pragma DATA_SECTION(hVal_motor4,"hVal_motor4");
long hVal_motor4[2]; // used as _iq

#pragma DATA_SECTION(qVal_3_motor4,"qval3_motor4");
long qVal_3_motor4[2]; // used as _iq

#pragma DATA_SECTION(velocity_motor4, "velocity_motor4");
unsigned long velocity_motor4;

#pragma DATA_SECTION(divisor_motor4, "divisor_motor4");
unsigned long divisor_motor4;


