/*
 * GlobalVariables.h
 *
 *  Created on: Nov 24, 2020
 *      Author: ASUS
 */

#ifndef GLOBALVARIABLES_H_
#define GLOBALVARIABLES_H_

#include "GlobalDefine.h"
#include "IQMathlib.h"
#include <stdlib.h>
#include "DSP28_Device.h"

extern _iq T1, T2, T3, reciprocalTs;
extern _iq coeff_1;
extern _iq coeff_2;
extern _iq coeff_3;

extern long N1, N2, N3;
extern _iq15 *qVal_1, *qVal_2;
extern int *i_temp;
extern _iq15 *h_temp;
extern int temp_index;
extern unsigned int k;

extern long *encoderArray;
extern long encoderValue;
extern unsigned int turn;
extern unsigned long encoder;

extern unsigned long index;
extern unsigned long counter;
extern Uint16 timeValue;
extern unsigned int start_flag;
extern int direction; // Sign of velocity

extern _iq15 hVal[2];
extern _iq15 qVal_3[2];
extern long velocity;
extern long divisor;
extern unsigned long testValue;

// Motor 2
extern _iq15 *qVal_1_motor2, *qVal_2_motor2;
extern int *i_temp_motor2;
extern _iq15 *h_temp_motor2;
extern int temp_index_motor2;
extern _iq15 hVal_motor2[2];
extern _iq15 qVal_3_motor2[2];
extern long velocity_motor2;
extern long divisor_motor2;
extern unsigned int k_motor2;
extern unsigned long counter_motor2;
//

// Motor 3
extern _iq15 *qVal_1_motor3, *qVal_2_motor3;
extern int *i_temp_motor3;
extern _iq15 *h_temp_motor3;
extern int temp_index_motor3;
extern _iq15 hVal_motor3[2];
extern _iq15 qVal_3_motor3[2];
extern long velocity_motor3;
extern long divisor_motor3;
extern unsigned int k_motor3;
extern unsigned long counter_motor3;
//

// Motor 4
extern _iq15 *qVal_1_motor4, *qVal_2_motor4;
extern int *i_temp_motor4;
extern _iq15 *h_temp_motor4;
extern int temp_index_motor4;
extern _iq15 hVal_motor4[2];
extern _iq15 qVal_3_motor4[2];
extern long velocity_motor4;
extern long divisor_motor4;
extern unsigned int k_motor4;
extern unsigned long counter_motor4;
//


extern int cmdFlag;
extern unsigned int nMin;

extern unsigned long h;// TODO: make this reconfigurable
extern unsigned long q1_max;
extern unsigned long q2_max;
extern unsigned long q3_max;
extern _iq Ts;

extern unsigned int  *ExRamStart;

#endif /* GLOBALVARIABLES_H_ */
