# Imagen para convertir grabaciones codificadas de GUACAMOLE en videos
FROM debian:stable-backports as BUILDER
MAINTAINER caimandepamer  version: 02
WORKDIR /root/
RUN apt update && apt install -y build-essential libcairo2-dev libjpeg62-turbo-dev libpng-dev libtool-bin libossp-uuid-dev libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libpango1.0-dev libssh2-1-dev libvncserver-dev libtelnet-dev libssl-dev libvorbis-dev libwebp-dev libpulse-dev ffmpeg
ADD https://downloads.apache.org/guacamole/1.3.0/source/guacamole-server-1.3.0.tar.gz /root/
RUN tar zxvf guacamole-server-1.3.0.tar.gz
RUN cd /root/guacamole-server-1.3.0/ && ./configure --disable-guacd --disable-guaclog --disable-kubernetes --with-init-dir=/etc/init.d
RUN cd /root/guacamole-server-1.3.0/ && make && make install
RUN rm -rf  /root/guacamole-server-1.3.0 && apt clean && rm -rf /var/lib/apt/lists/*

FROM debian:stable-backports
# despues compilar el ffmpeg a ver si pesa menos
RUN apt update && apt install -y ffmpeg
WORKDIR /root/
ADD https://raw.githubusercontent.com/caimandepamer/guacenc/main/convert.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/convert.sh
COPY --from=BUILDER /usr/local/bin/guacenc /usr/local/bin/
RUN ldconfig
RUN export LC_ALL="en_US.UTF-8"
RUN apt clean && rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["/usr/local/bin/convert.sh"]
