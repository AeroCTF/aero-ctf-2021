# Aero CTF 2021

## Forensic | NewMeta

### Description

> We started tracking this hacker not so long ago and were immediately able to intercept some traffic that was coming from him. 
> 
> During the detention, we were able to obtain a memory image. 
> 
> It seems he tested some kind of driver, possibly malicious. 
> 
> Try to find out what he was doing.
>
> password of mem.7z: R7cKGzpex7mzForWldTX
>
> traf.7z - https://drive.google.com/file/d/1utnsltBxBqWg9C3hGdcYK4ikKUjHa3mn/view?usp=sharing
>
> mem.7z - https://drive.google.com/file/d/1ayJLQHXHkbhGBVB8Ey5BZXsHfcwYoVtZ/view?usp=sharing

### Files

- [traf.7z_link](deploy/traf.7z_link)
- [mem.7z_link](deploy/memdump.7z_link)

### Idea
    We have two files: network dump and memory dump. From memory dump we need the key for traffic encryption. In network dump we can find encrypted traffic of windows kernel debug process. In memory dump we can found the WinDBG process wich do this debug. Flag is located on second machine and we dont have memory dump from this machine or other information. We can explore only traffic of debug.
### Solution
    1. vol.py -f mem.raw --profile=Win10x64_19041 memdump -D . -p 5440
    2. find image in memory (gimp)
    3. get fist part of key from image "17890"
    4. convert this to int36 and find in memory dump
    5. now you can dump all other pieces of key from dump and decrypt traffic
    6. decrypt traffic and dissect with kdnet-dissector - https://github.com/Lekensteyn/kdnet
    7. we find the list of kernel modules and see the test driver there
    8. we get the module address and find where this address was used for reading
    9. parse traffic and get module binary
    10. цe study the module a little and see a simple encoding algorithm, but it does not work, because the keys in memory are not correct, but were loaded through the debugger using the memory write command
    11. locate all "write" commands in traffic and get correct keys for XOR
    12. decode flag

    [solution with pictures](solve/solution.pdf)
### Flag

`Aero{f7301b4efb72fc507c5a9a0053077de1}`
