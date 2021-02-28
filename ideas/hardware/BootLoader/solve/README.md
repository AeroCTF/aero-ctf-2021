### Solve
- Bootloader getting 3 bytes: c-cmd, yx-data. After read 64 data bytes it's write to the memory.
- cmd can be 'R' - Run the program or shift address (c*0x40)
- So you need to write memory dumper which dumps the second half of FW and then write dumper
which dumps first half of FW.

#### DumperExample
Code that dumps first 0x1000 bytes

#### loader.py
Script that load binary, run it and then reading result.