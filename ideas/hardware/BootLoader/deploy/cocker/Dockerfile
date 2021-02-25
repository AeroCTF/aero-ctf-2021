FROM ubuntu:20.10

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get upgrade -yyq
RUN apt-get install make -yyq
RUN apt-get install g++ -yyq
RUN apt-get install socat -yyq
RUN apt-get install git -yyq
RUN apt-get install sudo -yyq
RUN apt-get install autoconf -yyq
RUN apt-get install minizip -yyq
RUN apt-get install libminizip-dev -yyq
RUN apt-get install libopenal1 libopenal-dev -yyq
RUN apt-get install libz-dev -yyq
RUN apt-get install xdg-utils -yyq
RUN apt-get install wget -yyq

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    echo keyboard-configuration keyboard-configuration/layout select 'English (US)' | debconf-set-selections && \
    echo keyboard-configuration keyboard-configuration/layoutcode select 'us' | debconf-set-selections && \
    echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections

RUN wget https://github.com/lcgamboa/picsimlab/releases/download/v0.8.6/PICSimLab_NOGUI-0.8.6-x86_64.AppImage
RUN wget https://github.com/lcgamboa/picsimlab/releases/download/v0.8.6/picsimlab_0.8.6_experimetal_Ubuntu_20.10_amd64.deb

RUN apt-get install gtkwave -yyq
RUN apt-get install gpsim -yyq
RUN apt-get install cutecom -yyq
RUN apt-get install gedit -yyq
RUN apt-get install libwxbase3.0-0v5 -yyq
RUN apt-get install libwxgtk3.0-gtk3-0v5 -yyq
RUN apt-get install libarchive-tools -yyq
RUN dpkg -i picsimlab_0.8.6_experimetal_Ubuntu_20.10_amd64.deb

RUN chmod 700 ./PICSimLab_NOGUI-0.8.6-x86_64.AppImage
RUN apt-get install supervisor -yyq
RUN apt-get install python -yyq
RUN apt-get install python3-pip -yyq
RUN pip install pyserial
RUN apt-get install net-tools -yyq
RUN apt-get install netcat -yyq
ADD ./supervisor /supervisor
RUN ./PICSimLab_NOGUI-0.8.6-x86_64.AppImage --appimage-extract
COPY ./listener.py /listener.py
COPY ./main.pzw /main.pzw
CMD ["supervisord","-c","/supervisor/service_script.conf"]

#RUN ./PICSimLab_NOGUI-0.8.6-x86_64.AppImage --appimage-extract && ./squashfs-root/AppRun 	 && rm -rf ./squashfs-root

#//socat /dev/ttyUSB0,b115200,raw,echo=0,crnl -
#sudo socat tcp-l:5760 /dev/ttyS21,raw,echo=0,b9600,fork system:echo "123"