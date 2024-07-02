#!/bin/sh
if [ $# -gt 0 ]; then
mkdir -p build
as $1 -o build/$1.o -g && ld build/$1.o -o build/$1 && build/$1
fi
