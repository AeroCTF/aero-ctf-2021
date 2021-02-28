FROM keltecc/nsjail:latest

RUN apt-get update && apt-get install gcc gcc-multilib -yyq
RUN mkdir /chroot/
WORKDIR /chroot/

RUN mkdir -p ./usr/lib/ && \
    cp -R /lib* . && \
    cp -R /usr/lib* ./usr/

RUN mkdir ./dev && \
    mknod ./dev/null c 1 3 && \
    mknod ./dev/zero c 1 5 && \
    mknod ./dev/random c 1 8 && \
    mknod ./dev/urandom c 1 9 && \
    chmod 666 ./dev/*

RUN mkdir -p ./bin/ && \
    cp /bin/sh \
       /bin/ls \
       /bin/cat \
       /bin/pwd \
       ./bin/ && \
    ln -s /bin/sh ./bin/bash && \
    chmod 111 ./bin/*

RUN mkdir -p ./usr/bin/ && \
    cp /usr/bin/id \
       /usr/bin/whoami \
       ./usr/bin/ && \
    chmod 111 ./usr/bin/*

RUN mkdir ./etc/ && \
    cp /etc/passwd ./etc/ && \
    chmod 444 ./etc/*

RUN mkdir ./tmp/ && \
    chmod 777 ./tmp/ && \
    chmod +t ./tmp/

RUN mkdir -p ./var/task/

ADD shmstr2 ./var/task/
ADD flag.txt ./tmp/

RUN chmod 444 ./tmp/flag.txt && \
    chmod 111 ./var/task/shmstr2

WORKDIR /

ADD nsjail/nsjail.sh /nsjail.sh
RUN chmod 555 /nsjail.sh

ENTRYPOINT ["/nsjail.sh"]
CMD ["/var/task/shmstr2"]