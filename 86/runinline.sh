#!/bin/sh
if [ $# -gt 0 ]; then
mkdir -p build
cc $1 -o build/$1 -no-pie -m32 && build/$1 $2 $3 $4
fi
