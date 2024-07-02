#!/bin/sh
if [ $# -gt 0 ]; then
mkdir -p build
nasm $1 -o build/$1.o -f elf64 -g && cc build/$1.o -o build/$1 -no-pie -lGL -lglut && build/$1 $2 $3 $4
fi
