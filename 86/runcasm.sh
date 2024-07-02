#!/bin/sh
if [ $# -gt 0 ]; then
mkdir -p build
nasm $1.asm -o build/$1.asm.o -f elf32 -g && cc $1.c build/$1.asm.o -o build/$1 -no-pie -m32 && build/$1 $2 $3 $4
fi
