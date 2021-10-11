
# guacenc  codificador  de videos  GUACAMOLE

### Imagen en: 
_docker push caimandepamer/guacen:02_

### Volumenes 
* Directorio '/record' debe ser montado y contener los archivos de grabacion sin codificar

### Variables de entorno (opcionales)
* variables de entorno: size _(por defecto 1920x1080)_  y  bits _(por defecto 2000000)_.

### Modo de Ejecucion:
` # docker run --rm  -v $(pwd)/record:/record --name guacenc01  caimandepamer/guacenc:02 `

### Resultado:

En el directorio _"record/converted"_ se guardan los archivos de video codificados _(extencion .m4v)_ y los archivos originales.


## Script en el contenedor que hace la conversion:

> ENTRYPOINT: /usr/local/bin/convert.sh

```Bash
#!/bin/bash
size=$size
bits=$bits
#========== eval size env ======================
if [ "$size" == "" ] ; then 
	size=1920x1080;
fi
#========== eval bits env ======================
if [ "$bits" == "" ] ; then 
	bits=2000000;
fi
#========== eval if /record/converted exists ===
WORK=/record
if [ ! -d "$WORK" ]; then echo "No esta mintado /record";exit 1; fi
DIR=/record/converted
if [ ! -d "$DIR" ]; then echo "creando $DIR"; mkdir -p $DIR; fi
#=========== start the convertion of ===========
#=========== all files in /record    ===========
for file in $(ls $WORK | grep -v converted | grep -vE  ".m4v$"); do
	echo "/usr/local/bin/guacenc -s $size -r $bits $WORK/$file";
	/usr/local/bin/guacenc -s $size -r $bits "$WORK/$file";
	mv "$WORK/$file".m4v "$DIR"/
	mv "$WORK/$file" "$DIR"/
	echo "$file converted."
done
```

***

# Dockerbuild  _(en proceso)_

```Bach
FROM debian:stable-backports

guacamole-server-1.3.0.tar.gz

RUN apt install -y build-essential libcairo2-dev libjpeg62-turbo-dev libpng-dev libtool-bin libossp-uuid-dev libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libpango1.0-dev libssh2-1-dev libvncserver-dev libtelnet-dev libssl-dev libvorbis-dev libwebp-dev libpulse-dev

tar zxvf guacamole-server-1.3.0.tar.gz
cd guacamole-server-1.3.0/
./configure --disable-guacd --disable-guaclog --disable-kubernetes --with-init-dir=/etc/init.d
make
make install
ldconfig
export LC_ALL="en_US.UTF-8"
/usr/local/bin/convert.sh
chmod +x /usr/local/bin/convert.sh

 ENTRYPOINT ["/usr/local/bin/convert.sh"]
```
