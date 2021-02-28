# Aero CTF 2021

## Forensic | Target Attack

### Description

> This was clearly a targeted attack to retrieve our files.
>
> We learned that there is another computer that was attacked, but we only have its SID.
>
> We were told that the flag.txt file was stolen from it.
>
> machine SID: S-1-5-21-322384183-3735928559-3237920990
>
> task.7z - https://drive.google.com/file/d/1-UHwX_i7qtN1svUJjIF1UIKYUTRj816A/view

### Files

- [task.7z_link](deploy/task.7z_link)

### Idea
    Black box analysis of binary protocol

### Solution
    1. Find python script in proc.dmp
    2. Examine the script and traffic and understand that this is some kind of custom protocol that writes files to the server 
    3. The structure of the protocol is quite typical, but you do not have a complete set of commands, so you need to determine which fields in the package are responsible for commands and learn about new commands by errors in server responses.
    4. We find a command that allows you to get the file size (an example with it at the end of the script). This command has an extension that allows you to get the full path of a file on the server. This will help you understand how directory names work. 
    5. The directory name is a printable sequence of 16 bytes, which is the key for hmac during authorization 
    6. Since I will give you the SID of the machine from which the flag was stolen, you can find out the name of the directory on the server where it is located. 
    7. After you know the name of the directory, you need to use the read command (it was the only one that was not presented in the script) and read the file by traversing the directory. 


    An example of fuzzing commands, as well as getting a file with a flag, is presented in the [script](solve/fuzz_cmds.py)
### Flag

`Aero{6ee721d4dd05bf9df25f1fced831b4e0}`
