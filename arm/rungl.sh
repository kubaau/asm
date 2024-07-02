#!/bin/sh
if [ $# -gt 0 ]; then
mkdir -p build
as $1 -o build/$1.o -g -mfpu=vfpv3 && cc build/$1.o -o build/$1 -lGL -lglut && build/$1 $2 $3 $4
fi
