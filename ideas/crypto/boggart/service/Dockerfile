FROM python:3.8

RUN apt update \
    && apt install -y socat

RUN pip install gmpy

RUN useradd -M -s /bin/false boggart

RUN mkdir -p /var/boggart/

WORKDIR /var/boggart/

COPY boggart.py flag.txt ./

USER boggart

ENTRYPOINT socat TCP-LISTEN:31337,reuseaddr,fork EXEC:"python -u boggart.py"
