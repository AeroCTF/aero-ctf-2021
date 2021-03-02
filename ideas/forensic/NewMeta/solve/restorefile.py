import json

fd = open("out.file", 'wb')

buf = bytearray(0x9000)

BASE_ADDR = 0xfffff8013a370000
addrlist = []

with open('filedump.json') as json_file:
    data = json.load(json_file)
    for i in data:
        addr = int(i['_source']['layers']['kdnet']['kdnet.data_dec_tree']['kdnet.kd_data_tree']['kdnet.TargetBaseAddress'], 16)
        a = i['_source']['layers']['kdnet']['kdnet.data_dec_tree']['kdnet.kd_data_tree']['kdnet.blob'].replace(':', '')
        wdata = b"".fromhex(a)
        addr_to_write = addr - BASE_ADDR

        if addr_to_write > 0x9000 or addr_to_write < 0:
            continue
        if addr_to_write in addrlist:
            continue

        addrlist.append(addr_to_write)
        print(addr_to_write, wdata)
        buf[addr_to_write : addr_to_write + len(wdata)] = wdata

fd.write(bytes(buf))
fd.close()