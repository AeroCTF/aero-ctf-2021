#!/usr/bin/env python3.8

import socket

from gmpy2 import mpz, next_prime, powmod, lcm, legendre
from random import getrandbits
from functools import reduce
from itertools import combinations


def binluc(P, n, N):
    x, y = mpz(2), P
    
    for bit in reversed(range(n.bit_length() - 1)):
        if n.bit_test(bit):
            x, y = (y * y - 2) % N, (P * y * y - x * y - P) % N
        else:
            x, y = (x * y - P) % N, (y * y - 2) % N

    return y


def recover_primes(bits, N, rp, rq, error, limit):
    rp = (rp >> error) << error
    rq = (rq >> error) << error

    candidates = [(mpz(1), mpz(1))]

    for i in range(1, bits):
        next_candidates = set()

        for p, q in candidates:
            if (N - p * q).bit_test(i):
                next_candidates.add((p.bit_set(i), q))
                next_candidates.add((p, q.bit_set(i)))
            else:
                next_candidates.add((p, q))
                next_candidates.add((p.bit_set(i), q.bit_set(i)))

        candidates = set()

        for p, q in next_candidates:
            if (q, p) in candidates:
                continue
            
            if i <= error or (p & rp).bit_test(i) == rp.bit_test(i) and (q & rq).bit_test(i) == rq.bit_test(i):
                candidates.add((p, q))

        print(i, len(candidates))
        
        if not 0 < len(candidates) < limit:
            return None

    return candidates


def recover_exponent(pt, ct, p, q, phi, init, count):
    N = p * q
    primes = [next_prime(init)]

    for _ in range(5 * count // 2 - 1):
        primes.append(next_prime(primes[-1]))

    left, right = primes[:len(primes) // 2], primes[len(primes) // 2:]

    mul_right = reduce(lambda x, y: (x * y) % phi, right, 1)
    ct_inv = binluc(ct, powmod(mul_right, -1, phi), N)

    for split in range(count):
        print(split)
        steps = dict()

        for combination in combinations(left, r=count - split):
            power = reduce(lambda x, y: (x * y) % phi, combination, 1)
            result = binluc(pt, power, N)
            steps[result] = power

        print(len(steps))

        for combination in combinations(right, r=len(right) - split):
            power = reduce(lambda x, y: (x * y) % phi, combination, 1)
            result = binluc(ct_inv, power, N)
    
            if result in steps:
                return (steps[result] * mul_right * pow(power, -1, phi)) % phi


def load_parameters(address):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        sock.settimeout(3)
        sock.connect(address)
        file = sock.makefile('rw')

        file.readline()
        
        r = mpz(file.readline().strip())
        N = mpz(file.readline().strip())
        ct = mpz(file.readline().strip())
        flag = mpz(file.readline().strip())

    return r, N, ct, flag


def main():
    bits = 512
    init = 31337
    count = 16
    error = 10
    limit = 50_000

    pt = int.from_bytes(b'the boy who lived', 'big')
    
    while True:
        r, N, ct, flag = load_parameters(('0.0.0.0', 17101))
        primes = recover_primes(bits, N, r, r, error, limit)

        if primes is None:
            continue

        for p, q in primes:
            if p * q == N:
                break
        else:
            continue
        
        D = (pt * pt - 4) % N
        phi = lcm(p - legendre(D, p), q - legendre(D, q))
        e = recover_exponent(pt, ct, p, q, phi, init, count)

        if e is None:
            continue
        
        D = (flag * flag - 4) % N
        phi = lcm(p - legendre(D, p), q - legendre(D, q))
        d = powmod(e, -1, phi)
        flag = binluc(flag, d, N)

        print(int(flag).to_bytes(1024, 'big').strip(b'\x00'))
        break


if __name__ == '__main__':
    main()
