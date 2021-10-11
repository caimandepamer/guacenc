# Imagen para convertir grabaciones codificadas de GUACAMOLE en videos
FROM debian:stable-backports
MAINTAINER caimandepamer  version: 02
WORKDIR /root/
RUN apt update && apt install -y build-essential libcairo2-dev libjpeg62-turbo-dev libpng-dev libtool-bin libossp-uuid-dev libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libpango1.0-dev libssh2-1-dev libvncserver-dev libtelnet-dev libssl-dev libvorbis-dev libwebp-dev libpulse-dev
ADD https://raw.githubusercontent.com/caimandepamer/guacenc/main/convert.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/convert.sh
ADD https://downloads.apache.org/guacamole/1.3.0/source/guacamole-server-1.3.0.tar.gz /root/
RUN tar zxvf guacamole-server-1.3.0.tar.gz
RUN cd /root/guacamole-server-1.3.0/ && ./configure --disable-guacd --disable-guaclog --disable-kubernetes --with-init-dir=/etc/init.d
RUN cd /root/guacamole-server-1.3.0/ && make && make install
RUN ldconfig
RUN export LC_ALL="en_US.UTF-8"
RUN rm -rf  /root/guacamole-server-1.3.0 && apt clean && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/local/bin/convert.sh"]
