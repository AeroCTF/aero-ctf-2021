# Aero CTF 2021

## Reverse | Dummyper

### Description

> This stupid program has encrypted our flag. 
> 
> We only have a dump left.
> 
> dump.7z - https://drive.google.com/file/d/1RxzL4bk2cDnI0tpZtkGENOGbfqP_wLzp/view?usp=sharing
>

### Files

- [dump.7z_link](deploy/dump.7z_link)

### Idea
    Encrypt flag by random key and save in memory.
    Encrypt some funcs and dump all sections of ELF+heap
    
### Solution
    1. Decrypt code by key in memory
    2. Find AES-key by tool "aeskeyfind"
    3. Find an initialization vector near a key 
    4. Decrypt flag
    
    solution in dir solve/

### Flag

`Aero{d37fd6db2f8d562422aaf2a83dc62043}`
