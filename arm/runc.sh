#!/bin/sh
if [ $# -gt 0 ]; then
mkdir -p build
as $1 -o build/$1.o -g && cc build/$1.o -o build/$1 -no-pie && build/$1 $2 $3 $4
fi
