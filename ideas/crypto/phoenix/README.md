# Aero CTF 2021 | phoenix

## Description

> If you want to become a member of the Order of the Phoenix, you need to:
> 
> 1. be able to perfectly control the magic wand
> 2. be able to crack the following cipher
> 
> ...but maybe some of this is not needed

## Static

- [phoenix.sage](phoenix.sage)
- [output.txt](output.txt)

## Solution

TL;DR

The `Cipher` is almost linear, except for the single non-linear component with 5 multiplications.

Since the probability of `(non-linear component != zero)` is small, we can use information set decoding (ISD) attack to recover the key. When we know the key, we just need to run the Cipher again to decrypt the flag (because it uses XOR).

I've used `LeeBrickellISDAlgorithm` from sagemath. To calculate the error range, I just calculated the errors many times for random keys and took average values for lower in upper bounds.

[Example solver](solver.sage)

## Flag

`Aero{n1c3_ISD_4tt4ck_g00d_j0b!!}`
