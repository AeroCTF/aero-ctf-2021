import select
import serial
import socket
import os


serialPort_tnt2 = serial.Serial(port="/dev/tnt3", baudrate=9600, bytesize=8, timeout=2, stopbits=serial.STOPBITS_ONE)
SERVER_ADDRESS = ('0.0.0.0', 8686)

# Говорит о том, сколько дескрипторов единовременно могут быть открыты
MAX_CONNECTIONS = 10

# Откуда и куда записывать информацию
INPUTS = list()
OUTPUTS = list()


def get_non_blocking_server_socket():

    # Создаем сокет, который работает без блокирования основного потока
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.setblocking(0)

    # Биндим сервер на нужный адрес и порт
    server.bind(SERVER_ADDRESS)

    # Установка максимального количество подключений
    server.listen(MAX_CONNECTIONS)

    return server


def handle_readables(readables, server):
    """
    Обработка появления событий на входах
    """
    for resource in readables:

        # Если событие исходит от серверного сокета, то мы получаем новое подключение
        if resource is server:
            connection, client_address = resource.accept()
            connection.setblocking(0)
            INPUTS.append(connection)
            if connection not in OUTPUTS:
                    OUTPUTS.append(connection)
            os.popen('./squashfs-root/AppRun /main.pzw')
            print("new connection from {address}".format(address=client_address))

        # Если событие исходит не от серверного сокета, но сработало прерывание на наполнение входного буффера
        else:
            data = ""
            try:
                data = resource.recv(1)
                #print(b"recv %s"%data)
                serialPort_tnt2.write(data)

            # Если сокет был закрыт на другой стороне
            except ConnectionResetError:
                pass

            #if data:

                # Вывод полученных данных на консоль
                #print("getting data: {data}".format(data=str(data)))

                # Говорим о том, что мы будем еще и писать в данный сокет
                

            # Если данных нет, но событие сработало, то ОС нам отправляет флаг о полном прочтении ресурса и его закрытии
            #else:

                # Очищаем данные о ресурсе и закрываем дескриптор
             #   clear_resource(resource)


def clear_resource(resource):
    """
    Метод очистки ресурсов использования сокета
    """
    if resource in OUTPUTS:
        OUTPUTS.remove(resource)
    if resource in INPUTS:
        INPUTS.remove(resource)
    resource.close()
    conn = socket.socket()
    conn.connect(("localhost", 5000))
    conn.recv(1024)
    conn.send(b"exit\n")
    print("closing picsimlab %s"%conn.recv(1024))
    conn.close()
    print('closing connection ' + str(resource))


def handle_writables(writables):

    # Данное событие возникает когда в буффере на запись освобождается место
    for resource in writables:
        try:
            if(serialPort_tnt2.in_waiting > 0):
                serialString= serialPort_tnt2.read(1)
                resource.send(serialString)
                #print(b"send %s"%serialString)
        except OSError:
            clear_resource(resource)


if __name__ == '__main__':

    # Создаем серверный сокет без блокирования основного потока в ожидании подключения
    server_socket = get_non_blocking_server_socket()
    INPUTS.append(server_socket)

    print("server is running, please, press ctrl+c to stop")
    try:
        while INPUTS:
            readables, writables, exceptional = select.select(INPUTS, OUTPUTS, INPUTS)
            handle_readables(readables, server_socket)
            handle_writables(writables)
    except KeyboardInterrupt:
        clear_resource(server_socket)
        print("Server stopped! Thank you for using!")