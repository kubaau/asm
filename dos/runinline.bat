if not exist build mkdir build
bcc -nbuild %1.c
build\%1.exe