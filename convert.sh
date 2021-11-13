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
	/usr/bin/ffmpeg -i $WORK/$file".m4v "$DIR"/"$file".webm
	mv "$WORK/$file".m4v "$DIR"/
	mv "$WORK/$file" "$DIR"/
	echo "$file converted to m4v and webm"
done
