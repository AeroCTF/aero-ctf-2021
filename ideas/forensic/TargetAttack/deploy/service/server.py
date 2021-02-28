import socket
import threading
import socketserver
import hmac
import hashlib
import os
from time import sleep
from netfs import NetFS, errs
import shutil

RECV_BUF_SIZE = 1024 

blocklist = ["/bin","/boot","/dev","/etc","/home","/init","/lib","/lib32","/lib64","/libx32","/lost+found","/media","/mnt","/opt","/proc","/root","/run","/sbin","/snap","/srv","/sys","/tmp","/usr","/var", ".py", ".zip"]

regs = {}

ROOT_DIR = "/tmp/"
HOME_DIR = "/tmp/home/"
FLAG_DIR_NAME = "cfbfa0607dc4e1903191d181e37d0f34"

def cleanWorker(timeout=180):
    while 1:
        sleep(timeout)

        dirs = os.listdir(HOME_DIR)
        for i in dirs:
            if i == FLAG_DIR_NAME:
                continue

            shutil.rmtree(HOME_DIR+i, ignore_errors=True)

def checkFilePath(buf):
    for i in blocklist:
        if i in buf:
            #print(i, buf)
            return False
    return True

class ThreadedTCPRequestHandler(socketserver.BaseRequestHandler):

    def handle(self):
        # get reg request from client
        data = self.request.recv(RECV_BUF_SIZE)
        #print("data = ", data)
        out = NetFS().parse_packet(data)
        access = 0 
        key = None

        # if no errors, store key and set access
        if out['verdict'] == 'error':
            self.request.sendall(out['packet'])
            return None
        else:
            key = out['hmacKey']
            try:
                os.mkdir(HOME_DIR+key.hex())
            except:
                # some error in create dir
                packet = NetFS().error_packet(errs.DIR_CREATE_ERR)
                self.request.sendall(packet)
                self.request.close()
                return None

            if out['access'] == 'guest':
                access = 0
            else:
                access = 1

        # get request to challenge response auth
        data = self.request.recv(RECV_BUF_SIZE)
        out = NetFS().parse_packet(data)

        if out['verdict'] == 'error':
            self.request.sendall(out['packet'])
            return None
        else:
            # sendall challenge
            self.request.sendall(out['packet'])
            correctHmac = hmac.new(key, out['challenge'], hashlib.sha256).digest()
            
        # get hmac from user
        data = self.request.recv(RECV_BUF_SIZE)
        out = NetFS().parse_packet(data)

        if out['verdict'] == 'error':
            self.request.sendall(out['packet'])
            return None
        else:
            # check response
            if correctHmac == out['response']:
                #print("correct!")
                out = NetFS().gen_correct_auth_packet()
                self.request.sendall(out)
            else:
                #print("incorrect!")
                out = NetFS().gen_incorrect_auth_packet()
                self.request.sendall(out)
                return None
        
        # loop of user requests
        sleepCnt = 0
        while True:
            try:
                data = self.request.recv(RECV_BUF_SIZE)
            except:
                return None

            # print("data = ", data)
            if len(data) != 0 and len(data) > 3:
                out = NetFS().parse_packet(data, access=access)
                
                if out['verdict'] == 'error':
                    self.request.sendall(out['packet'])
                    continue
                
                if out['cmd'] == 'write':
                    filePath = None
                    userPath = out['path'][2:].decode()

                    if not checkFilePath(userPath):
                        packet = NetFS().gen_incorrect_filename_resp()
                        self.request.sendall(packet)
                        continue

                    if "../" in userPath or "/" in userPath:
                        packet = NetFS().gen_incorrect_filename_resp()
                        self.request.sendall(packet)
                        continue

                    if b"./" in out['path']:
                        filePath = HOME_DIR+key.hex()+out['path'][1:].decode()
                    else:
                        filePath = ROOT_DIR + out['path'][1:].decode()

                    if "create" in out.keys():
                        fd = open(filePath, 'wb')
                        fd.write(b'\x00' * out['size'])
                        fd.close()
                        continue

                    fd = open(filePath, 'r+b')
                    fd.seek(out['offset'])
                    fd.write(out['data'])
                    fd.close()

                    packet = NetFS().gen_write_packet_req()
                    self.request.sendall(packet)
                    continue

                elif out['cmd'] == 'read':
                    filePath = None
                    userPath = out['path'][1:].decode()

                    if not checkFilePath(userPath):
                        packet = NetFS().gen_incorrect_filename_resp()
                        self.request.sendall(packet)
                        continue

                    if b"./" in out['path']:
                        filePath = HOME_DIR+key.hex()+out['path'][1:].decode()
                    else:
                        filePath = ROOT_DIR + out['path'][1:].decode()

                    fileSize = os.stat(filePath).st_size
                    if out['offset'] > fileSize:
                        packet = NetFS().error_packet(errs.BAD_LEN)
                        self.request.sendall(packet)
                        continue
                    
                    fd = open(filePath, 'rb')
                    fd.seek(out['offset'])
                    data = fd.read(out['size'])
                    fd.close()

                    packet = NetFS().gen_read_packet_req(data)
                    self.request.sendall(packet)
                    continue

                elif out['cmd'] == 'list':
                    pass
                elif out['cmd'] == 'stat':
                    filePath = HOME_DIR + key.hex() + out['path'][1:].decode()
                    
                    if not os.path.isfile(filePath):
                        packet = NetFS().gen_stat_packet_file_not_exist()
                        self.request.sendall(packet)
                        continue
                    
                    fileSize = os.path.getsize(filePath)

                    if "info" in out.keys():
                        packet = NetFS().gen_stat_packet_info(fileSize, os.path.abspath(filePath), os.stat(filePath))
                        self.request.sendall(packet)
                        continue

                    packet = NetFS().gen_stat_packet_size(fileSize)
                    self.request.sendall(packet)
                    continue
                     
                else:
                    if "packet" in out.keys():
                        self.request.sendall(out['packet'])
            else:
                sleep(0.3)
                sleepCnt += 1

                if sleepCnt == 3:
                    return None

        return None

class ThreadedTCPServer(socketserver.ThreadingMixIn, socketserver.TCPServer):
    pass

if __name__ == "__main__":

    try:
        os.mkdir(HOME_DIR)
    except:
        pass

    # run cleaner
    cleanThr = threading.Thread(target=cleanWorker)
    cleanThr.start()

    # Port 0 means to select an arbitrary unused port
    HOST, PORT = "0.0.0.0", 8786

    server = ThreadedTCPServer((HOST, PORT), ThreadedTCPRequestHandler)
    with server:
        ip, port = server.server_address

        # Start a thread with the server -- that thread will then start one
        # more thread for each request
        server_thread = threading.Thread(target=server.serve_forever)
        # Exit the server thread when the main thread terminates
        server_thread.daemon = True
        server_thread.start()
        print("Server loop running in thread:", server_thread.name)
        while True:
            sleep(1000)
            continue
        #server.shutdown()