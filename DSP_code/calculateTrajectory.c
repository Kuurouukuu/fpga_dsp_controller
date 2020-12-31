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


void calculateTrajectory_MOTOR1(void)
{
    if ( (k < nMin+100) )// Sampling time interrupted
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

        if ((counter == i_temp[0] + N1) && temp_index > 0)
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
        velocity = _IQ1mpyIQX((qVal_3[0] - qVal_3[1]), 1, reciprocalTs, 20);
        velocity = _IQ1int(_IQ1mpyIQX(velocity, 1, _IQ1(60.0), 1));
        //GpioDataRegs.GPADAT.bit.GPIOA1 = (velocity >> 31) & 0x0001; // get the 32th bit for the sign, or direction and set the pin accordingly
        //timeValue = XIntruptRegs.XINT1CTR;
        divisor =  _IQ3int(_IQ3abs(_IQ3div(_IQ3(SYS_FREQ), _IQ3((float)velocity))));
        qVal_3[1] = qVal_3[0];

        hVal[1] = hVal[0]; // Shift
        encoderValue = encoder;
        encoderArray[k] = encoderValue;
        start_flag = 0;
    } else
    {
        ; // no operation
//        if (turn == 0)
//        {
//            turn = 1;
//            k = 0;
//            hVal[0] = _IQ1(75000.0);
//        } else
//        if (turn == 1)
//        {
//            turn = 2;
//            k = 0;
//            hVal[0] = _IQ1(25000.0);
//        } else
//        if (turn == 2)
//        {
//            turn = 3;
//            k = 0;
//            hVal[0] = _IQ1(0.0);
//        }
    }
}

void calculateTrajectory_MOTOR2(void)
{
/*  k_motor2, counter_motor2, qVal_1_motor2, hVal_motor2, i_temp_motor2, h_temp_motor2, temp_index_motor2, counter_motor2, qVal_2_motor2, qVal_3_motor2, velocity_motor2, divisor_motor2*/
    if ( (k_motor2 < nMin+100) )// Sampling time interrupted
    {
        k_motor2 = k_motor2 + 1;
        counter_motor2 = counter_motor2 + 1;
        //First filter
        qVal_1_motor2[0] = _IQmpy2(qVal_1_motor2[1]) - qVal_1_motor2[2];
        if (hVal_motor2[1] != hVal_motor2[0])
        {
            qVal_1_motor2[0] += _IQ1mpyIQX(coeff_1, 20, (hVal_motor2[0] - hVal_motor2[1]), 1);
            i_temp_motor2[temp_index_motor2] = counter_motor2;
            h_temp_motor2[temp_index_motor2] = hVal_motor2[0] - hVal_motor2[1];
            temp_index_motor2++;
            if (temp_index_motor2 > BUFFER_LENGTH)
            {
                temp_index_motor2 = BUFFER_LENGTH;
            }
        }

        if ((counter_motor2 == i_temp_motor2[0] + N1) && temp_index_motor2 > 0)
        {
            qVal_1_motor2[0] -= _IQ1mpyIQX(h_temp_motor2[0], 1, coeff_1, 20);
            temp_index_motor2 -= 1;
            for (index = 0; index < BUFFER_LENGTH-1; index++)
            {
                h_temp_motor2[index] = h_temp_motor2[index+1];
                i_temp_motor2[index] = i_temp_motor2[index+1];
            }
            if (temp_index_motor2 == 0)
            {
                counter_motor2 = 0;
            }
            h_temp_motor2[BUFFER_LENGTH-1] = 0;
            i_temp_motor2[BUFFER_LENGTH-1] = 0;
        }

        for (index = N2; index > 0; index-= 1)
        {
            qVal_1_motor2[index] = qVal_1_motor2[index-1];
        }
        // Second filter
        qVal_2_motor2[0] = qVal_2_motor2[1] + _IQ1mpyIQX(coeff_2, 20, (qVal_1_motor2[0] - qVal_1_motor2[N2-1]), 1);
        for (index = N3; index > 0; index -= 1)
        {
            qVal_2_motor2[index] = qVal_2_motor2[index - 1];
        }

        // Third filter
        qVal_3_motor2[0] = qVal_3_motor2[1] + _IQ1mpyIQX(coeff_3, 20, (qVal_2_motor2[0] - qVal_2_motor2[N3-1]), 1);
        velocity_motor2 = _IQ1mpyIQX((qVal_3_motor2[0] - qVal_3_motor2[1]), 1, reciprocalTs, 20);
        velocity_motor2 = _IQ1int(_IQ1mpyIQX(velocity_motor2, 1, _IQ1(60.0), 1));
        //GpioDataRegs.GPADAT.bit.GPIOA1 = (velocity_motor2 >> 31) & 0x0001; // get the 32th bit for the sign, or direction and set the pin accordingly
        divisor_motor2 =  _IQ3int(_IQ3abs(_IQ3div(_IQ3(SYS_FREQ), _IQ3((float)velocity_motor2))));
        qVal_3_motor2[1] = qVal_3_motor2[0];

        hVal_motor2[1] = hVal_motor2[0]; // Shift
    }
}

void calculateTrajectory_MOTOR3(void)
{
/*  k_motor3, counter_motor3, qVal_1_motor3, hVal_motor3, i_temp_motor3, h_temp_motor3, temp_index_motor3, counter_motor3, qVal_2_motor3, qVal_3_motor3, velocity_motor3, divisor_motor3*/
    if ( (k_motor3 < nMin+100) )// Sampling time interrupted
    {
        k_motor3 = k_motor3 + 1;
        counter_motor3 = counter_motor3 + 1;
        //First filter
        qVal_1_motor3[0] = _IQmpy2(qVal_1_motor3[1]) - qVal_1_motor3[2];
        if (hVal_motor3[1] != hVal_motor3[0])
        {
            qVal_1_motor3[0] += _IQ1mpyIQX(coeff_1, 20, (hVal_motor3[0] - hVal_motor3[1]), 1);
            i_temp_motor3[temp_index_motor3] = counter_motor3;
            h_temp_motor3[temp_index_motor3] = hVal_motor3[0] - hVal_motor3[1];
            temp_index_motor3++;
            if (temp_index_motor3 > BUFFER_LENGTH)
            {
                temp_index_motor3 = BUFFER_LENGTH;
            }
        }

        if ((counter_motor3 == i_temp_motor3[0] + N1) && (temp_index_motor3 > 0))
        {
            qVal_1_motor3[0] -= _IQ1mpyIQX(h_temp_motor3[0], 1, coeff_1, 20);
            temp_index_motor3 -= 1;
            for (index = 0; index < BUFFER_LENGTH-1; index++)
            {
                h_temp_motor3[index] = h_temp_motor3[index+1];
                i_temp_motor3[index] = i_temp_motor3[index+1];
            }
            if (temp_index_motor3 == 0)
            {
                counter_motor3 = 0;
            }
            h_temp_motor3[BUFFER_LENGTH-1] = 0;
            i_temp_motor3[BUFFER_LENGTH-1] = 0;
        }

        for (index = N2; index > 0; index-= 1)
        {
            qVal_1_motor3[index] = qVal_1_motor3[index-1];
        }
        // Second filter
        qVal_2_motor3[0] = qVal_2_motor3[1] + _IQ1mpyIQX(coeff_2, 20, (qVal_1_motor3[0] - qVal_1_motor3[N2-1]), 1);
        for (index = N3; index > 0; index -= 1)
        {
            qVal_2_motor3[index] = qVal_2_motor3[index - 1];
        }

        // Third filter
        qVal_3_motor3[0] = qVal_3_motor3[1] + _IQ1mpyIQX(coeff_3, 20, (qVal_2_motor3[0] - qVal_2_motor3[N3-1]), 1);
        velocity_motor3 = _IQ1mpyIQX((qVal_3_motor3[0] - qVal_3_motor3[1]), 1, reciprocalTs, 20);
        velocity_motor3 = _IQ1int(_IQ1mpyIQX(velocity_motor3, 1, _IQ1(60.0), 1));
        //GpioDataRegs.GPADAT.bit.GPIOA1 = (velocity_motor3 >> 31) & 0x0001; // get the 32th bit for the sign, or direction and set the pin accordingly
        divisor_motor3 =  _IQ3int(_IQ3abs(_IQ3div(_IQ3(SYS_FREQ), _IQ3((float)velocity_motor3))));
        qVal_3_motor3[1] = qVal_3_motor3[0];

        hVal_motor3[1] = hVal_motor3[0]; // Shift
    }
}

void calculateTrajectory_MOTOR4(void)
{
/*  k_motor4, counter_motor4, qVal_1_motor4, hVal_motor4, i_temp_motor4, h_temp_motor4, temp_index_motor4, counter_motor4, qVal_2_motor4, qVal_3_motor4, velocity_motor4, divisor_motor4*/
    if ( (k_motor4 < nMin+100) )// Sampling time interrupted
    {
        k_motor4 = k_motor4 + 1;
        counter_motor4 = counter_motor4 + 1;
        //First filter
        qVal_1_motor4[0] = _IQmpy2(qVal_1_motor4[1]) - qVal_1_motor4[2];
        if (hVal_motor4[1] != hVal_motor4[0])
        {
            qVal_1_motor4[0] += _IQ1mpyIQX(coeff_1, 20, (hVal_motor4[0] - hVal_motor4[1]), 1);
            i_temp_motor4[temp_index_motor4] = counter_motor4;
            h_temp_motor4[temp_index_motor4] = hVal_motor4[0] - hVal_motor4[1];
            temp_index_motor4++;
            if (temp_index_motor4 > BUFFER_LENGTH)
            {
                temp_index_motor4 = BUFFER_LENGTH;
            }
        }

        if ((counter_motor4 == i_temp_motor4[0] + N1) && (temp_index_motor4 > 0))
        {
            qVal_1_motor4[0] -= _IQ1mpyIQX(h_temp_motor4[0], 1, coeff_1, 20);
            temp_index_motor4 -= 1;
            for (index = 0; index < BUFFER_LENGTH-1; index++)
            {
                h_temp_motor4[index] = h_temp_motor4[index+1];
                i_temp_motor4[index] = i_temp_motor4[index+1];
            }
            if (temp_index_motor4 == 0)
            {
                counter_motor4 = 0;
            }
            h_temp_motor4[BUFFER_LENGTH-1] = 0;
            i_temp_motor4[BUFFER_LENGTH-1] = 0;
        }

        for (index = N2; index > 0; index-= 1)
        {
            qVal_1_motor4[index] = qVal_1_motor4[index-1];
        }
        // Second filter
        qVal_2_motor4[0] = qVal_2_motor4[1] + _IQ1mpyIQX(coeff_2, 20, (qVal_1_motor4[0] - qVal_1_motor4[N2-1]), 1);
        for (index = N3; index > 0; index -= 1)
        {
            qVal_2_motor4[index] = qVal_2_motor4[index - 1];
        }

        // Third filter
        qVal_3_motor4[0] = qVal_3_motor4[1] + _IQ1mpyIQX(coeff_3, 20, (qVal_2_motor4[0] - qVal_2_motor4[N3-1]), 1);
        velocity_motor4 = _IQ1mpyIQX((qVal_3_motor4[0] - qVal_3_motor4[1]), 1, reciprocalTs, 20);
        velocity_motor4 = _IQ1int(_IQ1mpyIQX(velocity_motor4, 1, _IQ1(60.0), 1));
        //GpioDataRegs.GPADAT.bit.GPIOA1 = (velocity_motor4 >> 31) & 0x0001; // get the 32th bit for the sign, or direction and set the pin accordingly
        divisor_motor4 =  _IQ3int(_IQ3abs(_IQ3div(_IQ3(SYS_FREQ), _IQ3((float)velocity_motor4))));
        qVal_3_motor4[1] = qVal_3_motor4[0];

        hVal_motor4[1] = hVal_motor4[0]; // Shift
    }
}

void InitValue(void)
{
    hVal[0] = hVal[1] = 0;
    hVal_motor2[0] = hVal_motor2[1] = 0;
    hVal_motor3[0] = hVal_motor3[1] = 0;
    hVal_motor4[0] = hVal_motor4[1] = 0;

    qVal_3[0] = qVal_3[1] = 0;
    qVal_3_motor2[0] = qVal_3_motor2[1] = 0;
    qVal_3_motor3[0] = qVal_3_motor3[1] = 0;
    qVal_3_motor4[0] = qVal_3_motor4[1] = 0;

    hVal[0] = _IQ1((float)0);
    hVal_motor2[0] = _IQ1((float)0);
    hVal_motor3[0] = _IQ1((float)0);
    hVal_motor4[0] = _IQ1((float)0);
}

void CalculateParameters(void)
{
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

    i_temp = calloc(BUFFER_LENGTH, 1);
    h_temp = calloc(BUFFER_LENGTH, 1);
    i_temp_motor2 = calloc(BUFFER_LENGTH, 1);
    h_temp_motor2 = calloc(BUFFER_LENGTH, 1);
    i_temp_motor3 = calloc(BUFFER_LENGTH, 1);
    h_temp_motor3 = calloc(BUFFER_LENGTH, 1);
    i_temp_motor4 = calloc(BUFFER_LENGTH, 1);
    h_temp_motor4 = calloc(BUFFER_LENGTH, 1);

    qVal_1 = calloc(N2+1, 2); // 2 bytes per _iq, each bytes is 16 bit
    qVal_2 = calloc(N3+1, 2); // Plus one due to truncating.
    qVal_1_motor2 = calloc(N2+1, 2); // 2 bytes per _iq, each bytes is 16 bit
    qVal_2_motor2 = calloc(N3+1, 2); // Plus one due to truncating.
    qVal_1_motor3 = calloc(N2+1, 2); // 2 bytes per _iq, each bytes is 16 bit
    qVal_2_motor3 = calloc(N3+1, 2); // Plus one due to truncating.
    qVal_1_motor4 = calloc(N2+1, 2); // 2 bytes per _iq, each bytes is 16 bit
    qVal_2_motor4 = calloc(N3+1, 2); // Plus one due to truncating.

    nMin = _IQ20int(_IQ20div((T1+T2+T3), Ts));
    encoderArray = calloc(1500, 2);
    //nMin = _IQint(_IQ5div(_IQ5mpyIQX(_IQ5((float)h), 5, reciprocalTs, 20), _IQ5((float)q1_max)));

}
