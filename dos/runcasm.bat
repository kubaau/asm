if not exist build mkdir build
bcc -nbuild %1.c %1asm.asm
build\%1.exe %2