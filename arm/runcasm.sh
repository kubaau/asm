#!/bin/sh
if [ $# -gt 0 ]; then
mkdir -p build
as $1.s -o build/$1.s.o -g && cc $1.c build/$1.s.o -o build/$1 -no-pie && build/$1 $2 $3 $4
fi
