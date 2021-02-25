# Aero CTF 2021 | boggart

## Description

> Welcome to another Defence Against the Dark Arts lesson.
> 
> Today I will show you a new powerful charm — Riddikulus. Enjoy!
> 
> `nc IP 17101`

## Static

- [boggart.py](service/boggart.py)

## Solution

TL;DR

1. Recognize LUC cryptosystem, it uses `N = p * q` just like RSA
2. `cast_riddikulus` is a linear exponentiation function, so we need to rewrite it as a binary exponentiation function, using some Lucas sequence properties
2. Recover `p, q` primes using `neutral_magic` hint and Hensel lifting method
3. Recover public exponent `e` using known pair `PT-CT` and Meet-in-the-middle method
4. Calculate private exponent `d` and decrypt the flag

Here is my not optimized solution, it works for about a few minutes.

[Example solver](solver.py)

## Flag

`Aero{Do_you_know_Peter_Pettigrew?}`
