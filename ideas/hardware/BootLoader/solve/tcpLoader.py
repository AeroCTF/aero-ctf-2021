import socket

conn = socket.socket()
conn.connect(("localhost", 8686))

a = open('/home/anon/code.bin', 'rb')
step = 0
f = 0
f1 = 1
while(1):
	# Wait until there is data waiting in the serial buffer
	# Read data out of the buffer until a carraige return / new line is found
	serialString = conn.recv(1)
	print(serialString)
	# Print the contents of the serial data
	if(step == 0):
		conn.send(b"r")
		step += 1
		continue
	if(serialString == b'c'):
		if(step > 0x1000):
			conn.send(b'R')
			while(1):
				serialString = conn.recv(1)
				print(serialString)
			exit(0)
		if(f1 == 1):
			conn.send(b'\x00')	
		else:
			conn.send(b'\x80')
			f1 = 1
		continue
	if(not f):
		try:
			s = a.read(1)
			#if(step%3 != 1):
			conn.send(s)
		except:
			f = 1
			conn.send(b"\x00")
	step += 1
	#if(step == 29000):
	#	exit(0)
	# exit
	#break