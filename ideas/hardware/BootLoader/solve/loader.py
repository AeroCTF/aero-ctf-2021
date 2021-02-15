import serial

serialPort_tnt0 = serial.Serial(port = "/dev/tnt0", baudrate=9600,
						   bytesize=8, timeout=2, stopbits=serial.STOPBITS_ONE)
serialPort_tnt3 = serial.Serial(port = "/dev/tnt3", baudrate=9600,
						   bytesize=8, timeout=2, stopbits=serial.STOPBITS_ONE)
#serialPort_tnt0.write(b"hello there \r\n")

a = open('/home/anon/code.bin', 'rb')
step = 0
f = 0
f1 = 0
while(1):
	# Wait until there is data waiting in the serial buffer
	if(serialPort_tnt3.in_waiting > 0):
		# Read data out of the buffer until a carraige return / new line is found
		serialString = serialPort_tnt3.read(1)
		# Print the contents of the serial data
		print(serialString)
		if(step == 0):
			serialPort_tnt3.write(b"r")
			step += 1
			continue
		if(serialString == b'c'):
			if(step > 0x200):
				serialPort_tnt3.write(b'R')
				while(1):
					serialString = serialPort_tnt3.read(1)
					print(serialString)
				exit(0)
			if(f1 == 1):
				serialPort_tnt3.write(b'\x00')	
			else:
				serialPort_tnt3.write(b'\x80')
				f1 = 1
			continue
		if(not f):
			try:
				s = a.read(1)
				#if(step%3 != 1):
				serialPort_tnt3.write(s)
			except:
				f = 1
				serialPort_tnt3.write(b"\x00")
		step += 1
		#if(step == 29000):
		#	exit(0)
		# exit
		#break