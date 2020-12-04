/*
 * InterruptFunction.h
 *
 *  Created on: Nov 24, 2020
 *      Author: ASUS
 */

#ifndef INTERRUPTFUNCTION_H_
#define INTERRUPTFUNCTION_H_

interrupt void ExtIntISR(void);
interrupt void TXAISR(void);
interrupt void RXAISR(void);

#endif /* INTERRUPTFUNCTION_H_ */
