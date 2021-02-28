# Aero CTF 2021 | custom

## Description

> Just another object creation primitive. Please, obtain the flag.
> 
> `nc IP 17102`
> 
> __Hint__: `FROM mcr.microsoft.com/dotnet/runtime:5.0`

## Static

- [custom.tar.gz](custom.tar.gz)

## Solution

TL;DR

The main idea is based on [https://habr.com/en/post/448338/](https://habr.com/en/post/448338/), but I used it in a different case.

There is no unsafe code, but the main vulnerability is using `StructLayoutAttribute`.

`[FieldOffset(0)]` means that the content of the field (value or pointer) will be located exactly at the offset `0` in the struct. If we use that attribute in many fields, each of the field will be located at the offset `0`, and they will be overlapped in memory. Something like a C++'s union.

When we call a method of the overlapped field, runtime is trying to jump to the method's table and call the specified method. But runtime doesn't know which object is actually located in memory. So, in our case, if the field contains a `string` object, but we calling the method from `CustomerInfo`, the corresponding method from `string` class will be called, and vice versa. Of course it works not only with methods, but with fields too.

I didn't get an RCE in this challenge, but I'm not sure that it's impossible, so if you reach an RCE, please write about it. So here is the intended solution:

The private field `Length` of the `String` class and the field `Id` of the `CustomerInfo` class are located in the same offset in memory. So when the `Customer` struct contains `CustomerInfo` object, and we're trying to use it as a `String` object and print the string, the `Id` will be used as `Length` of the string and we will get the memory leak. The memory will be printed UTF-8 encoded, so we need to decode it later.

The flag was read into the memory, so we want to get some address near the flag, to calculate the flag's address itself. Luckily the leak described above contains such address. To calculate an offset to the flag, I just put a random flag in the file and run the program. It seems that the offset is constant for every flag length, even with ASLR.

So, returning to overlapping classes. The `CustomerInfo.BuyItem(long)` method overlaps with `String.CompareTo(string)` method. So when we call `CustomerInfo.BuyItem(long)` for the `String` object, the long value is interpreting as a string address, and `CompareTo` is calling. We can use it to bruteforce the flag char-by-char. 

[Example exploit](exploit.py)

## Flag

`Aero{wewillwewillmanageyou}`
