# Aero CTF 2021

## Reverse | BoatLouder

### Description
> I use this .hex to load firmware into my new PIC18F452 (OSC 8MHz)
> But unfourtunately I lost it.

### Files
- [BootLoader.hex](deploy/Boot_Loader.hex)

### Idea
    The .hex file that contains bootloader for PIC which allows to write in memory, 
    make offset and run the program. Teams shoud to develop code for PIC 
    which will dump CODE memory of the microcontroller. 
    
### Solution
    Dumper and Loader example in solve

### Flag
`Aero{Y0u_c4N_dmp_1t}`