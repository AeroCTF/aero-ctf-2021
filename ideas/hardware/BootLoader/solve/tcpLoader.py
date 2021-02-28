import socket
import time
from time import sleep
conn = socket.socket()
conn.connect(("localhost", 38686))
a = open('code.bin', 'rb')
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
		conn.sendall(b"r") 
		step += 1
		continue
	if(serialString == b'g'):
		continue
	if(serialString == b'c'):
		if(step > 0x200):
			conn.sendall(b'R')
			while(1):
				serialString = conn.recv(1)
				print(serialString)
			exit(0)
		if(f1 == 1):
			conn.sendall(b'\x00')	
		else:
			conn.sendall(b'\x80')
			f1 = 1
		continue
	if(not f):
		try:
			s = a.read(1)
			#if(step%3 != 1):
			conn.sendall(s)
		except:
			f = 1
			conn.sendall(b"\x00")
	step += 1
	#time.sleep(0.5	)
	#if(step == 29000):
	#	exit(0)
	# exit
	#break