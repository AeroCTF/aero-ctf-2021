# Aero CTF 2021 | horcrux

## Description

> Imagine that you are a dark wizard (as dark as Voldemort). And you want to reach immortality.
> 
> What could be your plan?

## Static

- [horcrux.py](horcrux.py)
- [output.txt](output.txt)

## Solution

TL;DR

Let 

- Horcrux #1 = `U1`
- Horcrux #2 = `U2`
- wizard.magic = `G`
- wizard.soul = `s`

Notice that

```
U1 = (s / 2 - 1) * G = s*G / 2 - G
U2 = (s / 2 / 2 - 1) * G = s*G / 4 - G
```

We can express `s*G / 2` from the first equation:

```
s*G / 2 = U1 + G
```

Then

```
U2 = (U1 + G) / 2 - G
2 * U2 = U1 + G - 2 * G
U1 - U2 = U2 + G
```

In the output we know only the most significant `3000 - 32` bits of each coordinate. Denote known part as `Wi`, error part as `Ei`. Then

```
U1 = W1 + E1 = (W1.x + e1, W1.y + f1)
U2 = W2 + E2 = (W2.x + e2, W2.y + f2)
```

We will use Elliptic curve addition formula to translate equation `U1 - U2 = U2 + G` to two congruences respectively for `x` and `y` coordinates:

```
x_congruence: ec_add(U1, -U2).x - ec_add(U2, G).x == 0 (mod p)
y_congruence: ec_add(U1, -U2).y - ec_add(U2, G).y == 0 (mod p)
```

In resulting two congruences we can substitute `Ui = Wi + Ei`. Notice that `Wi` parts are known to us, `G` coordinates are also know, so now we get two another congruences of only four variables `(e1, e2, f1, f2)`:

```
L1(e1, e2, f1, f2) == 0 (mod p)
L2(e1, e2, f1, f2) == 0 (mod p)
```

Since each value of `(e1, e2, f1, f2)` is small, and the maximum degree is 4, we can use LLL to solve it.

[Example solver](solver.sage)

## Flag

`Aero{"Voldemort," said Riddle softly, "is my past, present, and future, Harry Potter...."}`
