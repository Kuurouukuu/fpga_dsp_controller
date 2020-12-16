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
extern int i_temp[BUFFER_LENGTH];
extern _iq15 h_temp[BUFFER_LENGTH];
extern int temp_index;
extern unsigned int k;

extern unsigned long encoderValue;
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

extern int cmdFlag;
extern unsigned int nMin;

extern unsigned long h;// TODO: make this reconfigurable
extern unsigned long q1_max;
extern unsigned long q2_max;
extern unsigned long q3_max;
extern _iq Ts;


#endif /* GLOBALVARIABLES_H_ */
