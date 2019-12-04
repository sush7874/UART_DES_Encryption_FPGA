import serial           # import the module
import time
ComPort = serial.Serial('COM9') # open COM24
ComPort.baudrate = 115200 # set Baud rate to 9600
ComPort.bytesize = 8    # Number of data bits = 8
ComPort.parity   = 'N'  # No parity
ComPort.stopbits = 1    # Number of Stop bits = 1
# Write character 'A' to serial port
#data=bytearray(b'A')
x=0b11110001
message =[0x01,0x23,0x45,0x67,0x89,0xab,0xcd,0xef]#[0x9b,0x37,0x6f,0xde,0xbd,0x7b,0xf7,0xef]
message.reverse()
addr=0
for x in message:
	ot= ComPort.write(bytes(chr(addr)))    #for sending data to FPGA
	#delay(0.1)
	ot= ComPort.write(bytes(chr(x)))    #for sending data to FPGA
	addr=addr+1
	#delay(0.1)
#key=00010011_00110100_01010111_01111001_10011011_10111100_11011111_11110001
key=[0x13,0x34,0x57,0x79,0x9b,0xbc,0xdf,0xf1]
key.reverse()
for x in key:
	ot= ComPort.write(bytes(chr(addr)))    #for sending data to FPGA
	#delay(0.1)
	ot= ComPort.write(bytes(chr(x)))    #for sending data to FPGA
	addr=addr+1
	#delay(0.1)

ot= ComPort.write(bytes(chr(55)))    #for sending data to FPGA
it=(ComPort.read(8))                #for receiving data from FPGA
print it.encode('hex'),
    

ComPort.close()         # Close the Com port