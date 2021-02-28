import struct
import time
import hmac
import hashlib

p8 = lambda x : struct.pack("!B", x)
p16 = lambda x : struct.pack("!H", x)
p32 = lambda x : struct.pack("!L", x)
p64 = lambda x : struct.pack("!Q", x)

u8 = lambda x : struct.unpack("!B", x)[0]
u16 = lambda x : struct.unpack("!H", x)[0]
u32 = lambda x : struct.unpack("!L", x)[0]
u64 = lambda x : struct.unpack("!Q", x)[0]

# packet struct
# MAGIC 2 bytes == NF
# CMD class <get file, write file, list files>
# CMD type 
# Payload size
# <payload>

MAGIC = 0x4e46

white_list = [b'\x10\x11\x12\x13\x10\x11\x12\x13']

class errs:
    BAD_MAGIC = 0x1001
    BAD_LEN = 0x1002
    BAD_CMD_TYPE = 0x1003
    PERMS_DENIED = 0x1004
    UNDEF_CMD_CLASS = 0x1005
    UNDEF_CMD_TYPE = 0x1006
    BAD_FILE_SIZE = 0x1007
    BAD_FILE_NAME = 0x1008
    DIR_CREATE_ERR = 0x1009
    BAD_PACKET_FORMAT = 0x1010

class cmd:
    CHECKIN = 0x0 # send some info, wich help to determ machine and key
    AUTH = 0x1 # send token
    CHANGE = 0x2 # change directory
    MKDIR = 0x3 # create directory
    STAT = 0x4 # view status of file/directory/disk: size, modes
    READ = 0x5 # read file
    WRITE = 0x6 # write file
    LIST = 0x7 # list files/dirs
    ERROR = 0x8 # errors 

    AUTH_CLIENT_CHALL_REQ = 0x10
    AUTH_SERVER_CHALL_RESP = 0x11
    AUTH_CLIENT_CHALL_RESP = 0x12

    WRITE_ABS_PATH = 0x60
    WRITE_REL_PATH = 0x61
    WRITE_CORRECT = 0x62
    WRITE_CREATE_ABS = 0x63
    WRITE_CREATE_REL = 0x64

    READ_ABS_PATH = 0x50
    READ_REL_PATH = 0x51
    READ_CORRECT = 0x52

    STAT_FILE_SIZE = 0x40
    STAT_FILE_INFO = 0x41
    STAT_FILE_INFO_CORRECT = 0x43
    STAT_FILE_SIZE_CORRECT = 0x42
    STAT_FILE_NOT_EXIST = 0x44

    CORRECT_AUTH = 0x13
    INCORRECT_AUTH = 0x14

class NetFS:

    def __init__(self):
        return None
    
    def gen_stat_packet_info(self, size, path, statData):
        data = b''
        data += p16(MAGIC)
        data += p8(cmd.STAT)
        data += p8(cmd.STAT_FILE_INFO_CORRECT)
        data += p32(size)
        data += path.encode()
        data += p32(statData.st_mode)
        data += p32(statData.st_ino)
        data += p32(statData.st_dev)
        data += p32(statData.st_nlink)
        data += p32(statData.st_uid)
        data += p32(statData.st_gid)
        data += p32(statData.st_size)
        data += p32(int(statData.st_atime))
        data += p32(int(statData.st_mtime))
        data += p32(int(statData.st_ctime))

        return data

    def gen_incorrect_filename_resp(self):
        data = self.error_packet(errs.BAD_FILE_NAME)
        return data

    def gen_stat_packet_file_not_exist(self):
        data = b''
        data += p16(MAGIC)
        data += p8(cmd.STAT)
        data += p8(cmd.STAT_FILE_NOT_EXIST)
        return data

    def gen_stat_packet_size(self, size):
        data = b''
        data += p16(MAGIC)
        data += p8(cmd.STAT)
        data += p8(cmd.STAT_FILE_SIZE_CORRECT)
        data += p32(size)
        return data

    def gen_read_packet_req(self, payload):
        data = b''
        data += p16(MAGIC)
        data += p8(cmd.READ)
        data += p8(cmd.READ_CORRECT)
        data += p16(len(payload))
        data += payload
        return data

    def gen_write_packet_req(self):
        data = b''
        data += p16(MAGIC)
        data += p8(cmd.WRITE)
        data += p8(cmd.WRITE_CORRECT)
        return data

    def gen_correct_auth_packet(self):
        data = b''
        data += p16(MAGIC)
        data += p8(cmd.AUTH)
        data += p8(cmd.CORRECT_AUTH)
        return data

    def gen_incorrect_auth_packet(self):
        data = b''
        data += p16(MAGIC)
        data += p8(cmd.AUTH)
        data += p8(cmd.INCORRECT_AUTH)
        return data

    def error_packet(self, errCode):
        data = b''
        data += p16(MAGIC)
        data += p8(cmd.ERROR)
        data += p16(errCode)
        return data

    def make_chall_packet(self, challenge):
        data = b''
        data += p16(MAGIC)
        data += p8(cmd.AUTH)
        data += p8(cmd.AUTH_SERVER_CHALL_RESP)
        data += p8(8)
        data += p64(challenge)
        return data

    def parse_packet(self, data, access=0):
        answer = {}
        if u16(data[0:2]) != MAGIC:
            answer['verdict'] = 'error'
            answer['packet'] = self.error_packet(errs.BAD_MAGIC)
            return answer
        
        if len(data) < 4:
            answer['verdict'] = 'error'
            answer['packet'] = self.error_packet(errs.BAD_LEN)
            return answer

        cmd_class = data[2]
        
        if cmd_class == cmd.CHECKIN:
            answer['cmd'] = 'chekin'
            cmd_type = data[3]

            if cmd_type != 0x0:
                answer['verdict'] = 'error'
                answer['packet'] = self.error_packet(errs.BAD_CMD_TYPE)
                return answer

            if len(data) < 6:
                answer['verdict'] = 'error'
                answer['packet'] = self.error_packet(errs.BAD_PACKET_FORMAT)
                return answer

            payloadSize = u16(data[4:6])

            if payloadSize != 12:
                answer['verdict'] = 'error'
                answer['packet'] = self.error_packet(errs.BAD_LEN)
                return answer

            if len(data[6:]) != payloadSize:
                answer['verdict'] = 'error'
                answer['packet'] = self.error_packet(errs.BAD_LEN)
                return answer
                
            machineSign = data[6:6 + payloadSize]
            hmacKey = hashlib.md5(machineSign).digest()
            answer['verdict'] = 'accept'
            answer['hmacKey'] = hmacKey
                
            # if machineSign not in white_list:
            #     answer['access'] = 'guest'
            # else:
            answer['access'] = 'user'
            
            return answer
        
        if cmd_class == cmd.AUTH:
            answer['cmd'] = 'auth'
            cmd_type = data[3]

            if cmd_type == cmd.AUTH_CLIENT_CHALL_REQ:
                # auth by token
                answer['verdict'] = 'accept'
                challenge = int(round(time.time()))
                answer['packet'] = self.make_chall_packet(challenge)
                answer['challenge'] = p64(challenge)
                return answer

            elif cmd_type == cmd.AUTH_CLIENT_CHALL_RESP:
                if len(data) < 6:
                    answer['verdict'] = 'error'
                    answer['packet'] = self.error_packet(errs.BAD_LEN)
                    return answer

                payloadSize = u16(data[4:6])
                
                if payloadSize < 16:
                    answer['verdict'] = 'error'
                    answer['packet'] = self.error_packet(errs.BAD_LEN)
                    return answer

                payload = data[6:6 + payloadSize]
                answer['response'] = payload
                answer['verdict'] = 'access'
                return answer
            else:
                answer['verdict'] = 'error'
                answer['packet'] = self.error_packet(errs.BAD_CMD_TYPE)
                return answer
                
        if cmd_class == cmd.WRITE:
            cmd_type = data[3]
            answer['cmd'] = 'write'

            if cmd_type == cmd.WRITE_CREATE_REL:
                if len(data) < 72:
                    answer['verdict'] = 'error'
                    answer['packet'] = self.error_packet(errs.BAD_LEN)
                    return answer

                if access == 1:
                    off = 4
                    filePath = data[off:off+64].replace(b'\x00', b'')
                    off += 64

                    fileSize = u32(data[off:off+4])
                    off += 4
                    
                    # 10Kbyte - is max size
                    if fileSize > (10*1024):
                        answer['verdict'] = 'error'
                        answer['packet'] = self.error_packet(errs.BAD_FILE_SIZE)
                        return answer

                    answer['verdict'] = 'accept'
                    answer['create'] = 1
                    answer['size'] = fileSize

                    if cmd_type == cmd.WRITE_ABS_PATH:
                        answer['path'] = filePath
                    else:
                        answer['path'] = b'./' + filePath
                    
                    return answer
                else:
                    answer['verdict'] = 'error'
                    answer['packet'] = self.error_packet(errs.PERMS_DENIED)
                    return answer

            if cmd_type == cmd.WRITE_REL_PATH:
                if access == 1:
                    if len(data) < 6:
                        answer['verdict'] = 'error'
                        answer['packet'] = self.error_packet(errs.BAD_LEN)
                        return answer

                    payloadSize = u16(data[4:6])
                    
                    if payloadSize < 74:
                        answer['verdict'] = 'error'
                        answer['packet'] = self.error_packet(errs.BAD_LEN)
                        return answer
                    
                    off = 6
                    filePath = data[off:off+64].replace(b'\x00', b'')
                    off += 64

                    fileOffset = u32(data[off:off+4])
                    off += 4
                    
                    writeSize = u16(data[off:off+2])
                    off += 2

                    if writeSize > 0x200:
                        answer['verdict'] = 'error'
                        answer['packet'] = self.error_packet(errs.BAD_LEN)
                        return answer

                    if (off+writeSize-6) > payloadSize:
                        answer['verdict'] = 'error'
                        answer['packet'] = self.error_packet(errs.BAD_LEN)
                        return answer

                    if (off+writeSize) > (10*1024):
                        answer['verdict'] = 'error'
                        answer['packet'] = self.error_packet(errs.BAD_LEN)
                        return answer
                        
                    writeData = data[off:off+writeSize]

                    if cmd_type == cmd.WRITE_ABS_PATH:
                        answer['path'] = filePath
                    else:
                        answer['path'] = b"./" + filePath

                    answer['verdict'] = 'accept'
                    answer['offset'] = fileOffset
                    answer['size'] = writeSize
                    answer['data'] = writeData
                    return answer

                else:
                    answer['verdict'] = 'error'
                    answer['packet'] = self.error_packet(errs.PERMS_DENIED)
                    return answer
            else:
                answer['verdict'] = 'error'
                answer['packet'] = self.error_packet(errs.BAD_CMD_TYPE)
                return answer

        if cmd_class == cmd.READ:
            cmd_type = data[3]
            answer['cmd'] = 'read'

            if cmd_type == cmd.READ_REL_PATH:
                if len(data) < 74:
                    answer['verdict'] = 'error'
                    answer['packet'] = self.error_packet(errs.BAD_LEN)
                    return answer
                
                off = 4
                filePath = data[off:off+64].replace(b'\x00', b'')
                off += 64

                fileOffset = u32(data[off:off+4])
                off += 4
                
                readSize = u16(data[off:off+2])
                off += 2
                
                if (readSize + fileOffset) > (10*1024):
                    answer['verdict'] = 'error'
                    answer['packet'] = self.error_packet(errs.BAD_LEN)
                    return answer

                if cmd_type == cmd.READ_ABS_PATH and access == 1:
                    answer['path'] = filePath
                elif cmd_type == cmd.READ_REL_PATH:
                    answer['path'] = b"./" + filePath
                else:
                    answer['verdict'] = 'error'
                    answer['packet'] = self.error_packet(errs.PERMS_DENIED)
                    return answer

                answer['verdict'] = 'accept'
                answer['offset'] = fileOffset
                answer['size'] = readSize
                return answer

            else:
                answer['verdict'] = 'error'
                answer['packet'] = self.error_packet(errs.BAD_CMD_TYPE)
                return answer
        
        if cmd_class == cmd.STAT:
            cmd_type = data[3]
            answer['cmd'] = 'stat'

            if cmd_type == cmd.STAT_FILE_SIZE or cmd_type == cmd.STAT_FILE_INFO:
                if len(data) < 68:
                    answer['verdict'] = 'error'
                    answer['packet'] = self.error_packet(errs.BAD_LEN)
                    return answer

                filePath = data[4:68].replace(b'\x00', b'')

                if cmd_type == cmd.STAT_FILE_INFO:
                    answer['info'] = 1
                
                answer['verdict'] ='accept'
                answer['path'] = b'./' + filePath
                return answer
            else:
                answer['verdict'] = 'error'
                answer['packet'] = self.error_packet(errs.BAD_CMD_TYPE)
                return answer

        answer['verdict'] = 'error'
        answer['packet'] = self.error_packet(errs.UNDEF_CMD_CLASS)
        return answer