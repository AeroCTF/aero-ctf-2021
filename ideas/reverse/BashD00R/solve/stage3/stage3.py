import idautils
from idaapi import *
from idc import *

data = {}

if __name__ == "__main__":
    start = 0x8F
    print("=" * 80)
    insAddrs = []

    for i in idautils.FuncItems(143):
        insAddrs.append(i)
    
    flagIdx = 0
    idx = 6
    for i in range(64 * 32):
        if GetMnem(insAddrs[idx]) == 'movzx':
            powN =    Dword(insAddrs[idx + 3] + 1)
            modul =   Dword(insAddrs[idx + 2] + 1)
            res =     Dword(insAddrs[idx + 6] + 1)
            #print("flagIdx: {}, powN: {}, modul: {}, res: {}".format(flagIdx, powN, modul, res))
            flagIdx = 0
            idx += 11
        else:
            flagIdx = Byte(insAddrs[idx] + 3)
            powN =    Dword(insAddrs[idx + 4] + 1)
            res =     Dword(insAddrs[idx + 7] + 1)
            modul =   Dword(insAddrs[idx + 3] + 1)

            idx += 12
        
        if flagIdx not in data.keys():
            data[flagIdx] = [[powN, modul, res]]
        else:
            data[flagIdx].append([powN, modul, res])
    
    flag = ['\x00' for i in range(64)]
    print(len(data[0]))

    for i in data.keys():
        for j in range(32, 127):
            correct = 0
            
            for k in range(len(data[i])):
                powN = data[i][k][0]
                modul = data[i][k][1]
                res = data[i][k][2]

                if pow(j, powN, modul) != res:
                    continue
                else:
                    correct += 1
            
            if correct == 32:
                flag[i] = chr(j)
                break
            if correct == 31:
                flag[i] = chr(j)
    
    print(''.join(flag))
