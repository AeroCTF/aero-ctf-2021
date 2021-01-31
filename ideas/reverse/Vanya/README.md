# Aero CTF 2021

## Reverse | Vanya

### Description

> My friend developed a ransomware and named it after himself. 
> 
> He encrypted the flag that I just wanted to give you.
> 
> Can you figure out what he did? 
> 
> password of dump.7z: ZmlEpnOSGH3qdH2kQLuj
>
> password of Vanya.7z: BGGjgkuFeUmhmfMc7P23
>
> dump.7z - https://drive.google.com/file/d/1TXXTCsC7H76e05yyBNsMDBF6W7z-j-I7/view?usp=sharing
>
> Vanya.7z - https://drive.google.com/file/d/13DXBfkUysUM9NKAX5qjdDhfCjtK1MBrf/view?usp=sharing

### Files

- [dump.7z_link](deploy/dump.7z_link)
- [Vanya.7z_link](deploy/Vanya.7z_link)

### Idea
    The executable file implements some virtual machine closely related to the native code. 
    The network traffic contains the converted encryption key, as well as an additional bytecode that performs encryption. 
    
### Solution
    1. Unpack binary
    2. Find bytecode and dump it after load
    3. Find some anti-RE patterns in bytecode (check locale, check debuger)
    4. Reverse logic of key generation
    5. Get a xor-key for SID mutate
    6. Decode SID from traffic
    7. Decrypt traffic bytecode
    8. Reverse logic of key generation algo for file encryption
    9. Decrypt file

   [solution with pictures](solve/solution.pdf)
### Flag

`Aero{cl4ss1c_n0t_p0pul4r_3ncrypt10n_4lg0r1thm_ac87740a2ad79da5dfcc41f0ae372736}`
