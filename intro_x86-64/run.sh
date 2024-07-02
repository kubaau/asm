#!/bin/sh
if [ $# -gt 0 ]; then
mkdir -p build
nasm $1 -o build/$1.o -f elf64 -g && ld build/$1.o -o build/$1 && build/$1
fi
