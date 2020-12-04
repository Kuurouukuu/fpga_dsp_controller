/*
 * calculateTrajectory.c
 *
 *  Created on: Nov 24, 2020
 *      Author: ASUS
 */

#include "IQMathLib.h"
#include "GlobalDefine.h"
#include "GlobalVariables.h"
#include "DSP28_Device.h"


void calculateTrajectory(void)
{
    if ( (k < nMin) )// Sampling time interrupted
    {
        k = k + 1;
        counter = counter + 1;
        //First filter
        qVal_1[0] = _IQmpy2(qVal_1[1]) - qVal_1[2];
        if (hVal[1] != hVal[0])
        {
            qVal_1[0] += _IQ1mpyIQX(coeff_1, 20, (hVal[0] - hVal[1]), 1);
            i_temp[temp_index] = counter;
            h_temp[temp_index] = hVal[0] - hVal[1];
            temp_index++;
            if (temp_index > BUFFER_LENGTH)
            {
                temp_index = BUFFER_LENGTH;
            }
        }

        if (counter == i_temp[0] + N1)
        {
            qVal_1[0] -= _IQ1mpyIQX(h_temp[0], 1, coeff_1, 20);
            temp_index -= 1;
            for (index = 0; index < BUFFER_LENGTH-1; index++)
            {
                h_temp[index] = h_temp[index+1];
                i_temp[index] = i_temp[index+1];
            }
            if (temp_index == 0)
            {
                counter = 0;
            }
            h_temp[BUFFER_LENGTH-1] = 0;
            i_temp[BUFFER_LENGTH-1] = 0;
        }

        for (index = N2; index > 0; index-= 1)
        {
            qVal_1[index] = qVal_1[index-1];
        }
        // Second filter
        qVal_2[0] = qVal_2[1] + _IQ1mpyIQX(coeff_2, 20, (qVal_1[0] - qVal_1[N2-1]), 1);
        for (index = N3; index > 0; index -= 1)
        {
            qVal_2[index] = qVal_2[index - 1];
        }

        // Third filter
        qVal_3[0] = qVal_3[1] + _IQ1mpyIQX(coeff_3, 20, (qVal_2[0] - qVal_2[N3-1]), 1);
        velocity = _IQ1int(_IQ1mpyIQX((qVal_3[0] - qVal_3[1]), 1, reciprocalTs, 20))*60;
        GpioDataRegs.GPADAT.bit.GPIOA1 = (velocity >> 31) & 0x0001; // get the 32th bit for the sign, or direction and set the pin accordingly
        timeValue = XIntruptRegs.XINT1CTR;
        divisor =  _IQ3int(_IQ3abs(_IQ3div(_IQ3(SYS_FREQ), _IQ3((float)velocity))));
        qVal_3[1] = qVal_3[0];

        hVal[1] = hVal[0]; // Shift
        start_flag = 0;
    } else
    {
        ; // No-op
    }
}

void InitValue(void)
{
    hVal[0] = hVal[1] = 0;
    qVal_3[0] = qVal_3[1] = 0;

    // Calculate parameter
    T1 = _IQ10div(_IQ10((float)h), _IQ10((float)q1_max));
    T2 = _IQ10div(_IQ10((float)q1_max), _IQ10((float)q2_max));
    T3 = _IQ10div(_IQ10((float)q2_max), _IQ10((float)q3_max));

    T1 = _IQ10toIQ(T1);
    T2 = _IQ10toIQ(T2);
    T3 = _IQ10toIQ(T3);

    reciprocalTs = _IQ20div(_IQ20(1.0f), Ts);

    N1 = _IQ10int(_IQ10mpy(_IQtoIQ10(T1), _IQtoIQ10(reciprocalTs)));
    N2 = _IQint(_IQdiv(T2, Ts));
    N3 = _IQint(_IQdiv(T3, Ts));

    coeff_1 = _IQ20div(_IQ20(1.0f), _IQ20((float)N1));
    coeff_2 = _IQ20div(_IQ20(1.0f), _IQ20((float)N2));
    coeff_3 = _IQ20div(_IQ20(1.0f), _IQ20((float)N3));

    hVal[0] = _IQ1((float)h);
    qVal_1 = calloc(N2+1, 2); // 2 bytes per _iq, each bytes is 16 bit
    qVal_2 = calloc(N3+1, 2); // Plus one due to truncating.
    nMin = _IQ20int(_IQ20div((T1+T2+T3), Ts));
    //nMin = _IQint(_IQ5div(_IQ5mpyIQX(_IQ5((float)h), 5, reciprocalTs, 20), _IQ5((float)q1_max)));

}
