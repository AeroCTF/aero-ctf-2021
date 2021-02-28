FROM python:3.8

RUN apt update

RUN useradd -M -s /bin/false server

RUN mkdir -p /tmp/home/
RUN mkdir -p /tmp/home/cfbfa0607dc4e1903191d181e37d0f34/

WORKDIR /tmp/home/
RUN chown server /tmp/home 
COPY server.py netfs.py ./
COPY flag.txt /tmp/home/cfbfa0607dc4e1903191d181e37d0f34/

USER server

ENTRYPOINT python -u server.py