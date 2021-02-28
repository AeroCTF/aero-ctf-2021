# Aero CTF 2021

## Pwn | House Builder

### Description

> We made an application for creating our own houses and selling them. 
> 
> Everything seems to be safe, don't you think so? 
> 
> flag in /tmp/flag.txt
> 
> housebuilder.7z - https://drive.google.com/file/d/1Ej7QH0M8Vl7x7Lu-afClviblKz7azGPY/view?usp=sharing
>
> nc {ip}:17174
> 

### Files

- [housebuilder.7z](deploy/housebuilder.7z)

### Idea
    Heap overflow -> AW -> pivot stack to .bss -> ROP chain
    
### Solution
- [solution](solve/sploit.py)

### Flag

`Aero{f39fffcbbd52b117d9fa79541e60c9af}`
