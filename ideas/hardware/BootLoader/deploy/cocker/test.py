import socket

if __name__ == "__main__":
	conn = socket.socket()
	conn.connect(("localhost", 8686))
	for i in range(10):
		print(conn.recv(1))
	conn.send('r')
	for i in range(1):
		print(conn.recv(1))
	conn.close()