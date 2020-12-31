#!/usr/bin/env python3
import serial
import sys

sp = serial.Serial(
    port='COM7',
    baudrate=19200,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.EIGHTBITS
)

# setup [velocity/acceleration/jerk] [value]
if (sys.argv[1] == 'setup'):
	if (sys.argv[2] == 'velocity'):
		command = '05' +  format(int(sys.argv[3]), "08X");
	if (sys.argv[2] == 'acceleration'):
		command = '02' + format(int(sys.argv[3]), "08X");
	if (sys.argv[2] == 'jerk'):
		command = '00' + format(int(sys.argv[3]), "08X");
	if (sp.is_open):
		byteToSend = bytes.fromhex(command);
		print(byteToSend);
		sp.write(byteToSend)
		sp.close();
	else:
		print('Cannot open port')

# run (motor)[n] [distance]
if (sys.argv[1] == 'run'):
	if (sys.argv[2] == '1'):
		command = '04' + format(int(sys.argv[3]), "08X");
	if (sys.argv[2] == '2'):
		command = '14' + format(int(sys.argv[3]), "08X");
	if (sys.argv[2] == '3'):
		command = '24' + format(int(sys.argv[3]), "08X");
	if (sys.argv[2] == '4'):
		command = '34' + format(int(sys.argv[3]), "08X");		
	if (sp.is_open):
		byteToSend = bytes.fromhex(command);
		print(byteToSend);
		sp.write(byteToSend)
		sp.close();
	else:
		print('Cannot open port')

