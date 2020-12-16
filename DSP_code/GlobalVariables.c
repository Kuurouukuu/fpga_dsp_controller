/*
 * GlobalVariables.c
 *
 *  Created on: Nov 24, 2020
 *      Author: ASUS
 */

#include "IQMathLib.h"
#include "GlobalDefine.h"
#include <stdlib.h>
#include "DSP28_Device.h"

_iq T1, T2, T3, reciprocalTs;
_iq coeff_1;
_iq coeff_2;
_iq coeff_3;

long N1, N2, N3;
_iq1 *qVal_1, *qVal_2;
int i_temp[BUFFER_LENGTH] = {0};
_iq1 h_temp[BUFFER_LENGTH] = {0};
int temp_index = 0;

unsigned long index = 0;
unsigned long counter = 0;
Uint16 timeValue = 0;
unsigned int start_flag = 0;
int direction = 0; // Sign of velocity

unsigned int k = 0;
long encoderValue = 0;

extern _iq1 hVal[2];
extern _iq1 qVal_3[2];
extern long velocity;
extern long divisor;
extern unsigned long encoder;

int cmdFlag = 0;
unsigned int nMin = 0;

unsigned long h = 100000;
// TODO: make this reconfigurable
unsigned long q1_max = 8533; // With assumption that 2048 pulse is  one round
unsigned long q2_max = 8533;
unsigned long q3_max = 17066;
_iq Ts = _IQ20((float)0.01);
