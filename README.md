
# guacenc  codificador  de videos  GUACAMOLE

### Descargar imagen Docker: 
`# docker pull caimandepamer/guacenc:02`

## Imagen en DockerHub: [caimandepamer - GUACENC](https://hub.docker.com/repository/docker/caimandepamer/guacenc)


### Volumenes 
* Directorio '/record' debe ser montado y contener los archivos de grabacion sin codificar

### Variables de entorno (opcionales)
* variables de entorno: size _(por defecto 1920x1080)_  y  bits _(por defecto 2000000)_.

### Modo de Ejecucion:
` # docker run --rm  -v $(pwd)/record:/record --name guacenc01  caimandepamer/guacenc:02 `

## El contenedor comenzara a convertir cada video y luego movera el archivo original y el video generado al directorio _"record/converted"_
![EjecudcionGuacenc](https://github.com/caimandepamer/guacenc/raw/main/Selection_119.png)


### Resultado:

En el directorio _"record/converted"_ se guardan los archivos de video codificados _(extencion .m4v)_ y los archivos originales.

## El video puede ser reproducido:
![ReproduccionVideo](https://github.com/caimandepamer/guacenc/raw/main/Selection_118.png)

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

