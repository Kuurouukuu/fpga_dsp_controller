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
int *i_temp;
_iq1 *h_temp;
int temp_index = 0;

unsigned long index = 0;
unsigned long counter = 0;
Uint16 timeValue = 0;
unsigned int start_flag = 0;
int direction = 0; // Sign of velocity

unsigned int k = 0;
unsigned int turn = 0;
long encoderValue = 0;

long *encoderArray;
extern _iq1 hVal[2];
extern _iq1 qVal_3[2];
extern long velocity;
extern long divisor;
extern unsigned long encoder;

// For motor 2
_iq1 *qVal_1_motor2, *qVal_2_motor2;
int *i_temp_motor2;
_iq1 *h_temp_motor2;
int temp_index_motor2 = 0;

unsigned long counter_motor2 = 0;
unsigned int k_motor2 = 0;

extern _iq1 hVal_motor2[2];
extern _iq1 qVal_3_motor2[2];
extern long velocity_motor2;
extern long divisor_motor2;
//

// For motor 3
_iq1 *qVal_1_motor3, *qVal_2_motor3;
int *i_temp_motor3;
_iq1 *h_temp_motor3;
int temp_index_motor3 = 0;

unsigned long counter_motor3 = 0;
unsigned int k_motor3 = 0;

extern _iq1 hVal_motor3[2];
extern _iq1 qVal_3_motor3[2];
extern long velocity_motor3;
extern long divisor_motor3;
//

// For motor 4
_iq1 *qVal_1_motor4, *qVal_2_motor4;
int *i_temp_motor4;
_iq1 *h_temp_motor4;
int temp_index_motor4 = 0;

unsigned long counter_motor4 = 0;
unsigned int k_motor4 = 0;

extern _iq1 hVal_motor4[2];
extern _iq1 qVal_3_motor4[2];
extern long velocity_motor4;
extern long divisor_motor4;
//

int cmdFlag = 0;
unsigned int nMin = 0;

unsigned long h = 50000;
// TODO: make this reconfigurable
unsigned long q1_max = 12798; // 2^17 pulses is one round -> q1_max = max_velocity (RPS) * 2^17 * B/A where A and B is electronic gear;
unsigned long q2_max = 12798;
unsigned long q3_max = 25596;
_iq Ts = _IQ20((float)0.01);

unsigned int  *ExRamStart = (unsigned  int *)0x100000;
