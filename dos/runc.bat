if not exist build mkdir build
bcc -nbuild %1.asm
build\%1.exe %2 %3 %4 %5