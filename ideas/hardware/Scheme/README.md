# Aero CTF 2021

## Hardware | Scheme

### Description
> Someone left this scheme here but I can't understand what it doing.

### Files
- [Scheme.pdf](deploy/Scheme.PDF)
- [Scheme.DSN](deploy/Scheme.DSN)

### Idea
    This scheme contains a lot of discrete components. Some of them named "F[0-9]*"
    The duration of positive part of signal is a flag symbol. 
    
### Solution
    1. Open the scheme
    2. Find "F1" component it's NE555 timer
    3. Find NE555 calculator (like this https://ohmslawcalculator.com/555-astable-calculator)
    4. Put parameters and get first 8 symbols
    5. At F9 you need to calculate 2 counters
    6. At F12 you need to calculate NE555 at monostable mode

### Flag
`I think it`
`Aero{ce294h6a24c245}`