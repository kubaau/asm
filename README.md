Collection of personal experiments with assembly programming for various architectures, created circa 2020.

`git clone --recursive git@github.com:kubaau/asm.git`

## Requires

### x64

`sudo apt install build-essential freeglut3-dev libsctp-dev nasm`

### x86

`sudo apt install build-essential freeglut3-dev:i386 gcc-multilib libsctp-dev:i386 nasm`

### ARM64

`sudo apt install binutils-aarch64-linux-gnu binutils-aarch64-linux-gnu-dbg build-essential gcc-aarch64-linux-gnu gdb-multiarch qemu-user qemu-user-static`

### ARM32

`sudo apt install binutils-arm-linux-gnueabihf binutils-arm-linux-gnueabihf-dbg build-essential gcc-arm-linux-gnueabihf gdb-multiarch qemu-user qemu-user-static`

### DOS

Tested with [Borland C++ 3.1 from Fabien Sanglard](http://fabiensanglard.net/Compile_Like_Its_1992/tools/BCPP31.zip)

## ARM hints

Helper scripts are currently meant for [ARM32 on emulated Raspberry Pi](#arm32-on-emulated-raspberry-pi).

### ARM64 and ARM32 on x86

["Running ARM Binaries on x86 with QEMU-User" by Azeria Labs](https://azeria-labs.com/arm-on-x86-qemu-user/)

TLDR commands in case this gets taken down:

#### ARM64

```
aarch64-linux-gnu-gcc -o hello64sta hello64.c -static
./hello64sta
aarch64-linux-gnu-gcc -o hello64dyn hello64.c
qemu-aarch64 -L /usr/aarch64-linux-gnu ./hello64dyn

aarch64-linux-gnu-as asm64.s -o asm64.o && aarch64-linux-gnu-ld asm64.o -o asm64 && ./asm64

aarch64-linux-gnu-objdump -d asm64

aarch64-linux-gnu-gcc -o hello64sta hello64.c -static -ggdb3
qemu-aarch64 -L /usr/aarch64-linux-gnu/ ./hello64sta -g 1234 &
gdb-multiarch -q --nh -ex 'set architecture arm64' -ex 'file hello64sta' -ex 'target remote localhost:1234' -ex 'layout split' -ex 'layout regs'

(gdb) set solib-search-path /usr/aarch64-linux-gnu/lib/
```

#### ARM32

```
arm-linux-gnueabihf-gcc -o hello32sta hello32.c -static
./hello32sta
arm-linux-gnueabihf-gcc -o hello32dyn hello32.c
qemu-arm -L /usr/arm-linux-gnueabihf ./hello32dyn

arm-linux-gnueabihf-as asm32.s -o asm32.o && arm-linux-gnueabihf-ld -static asm32.o -o asm32 && ./asm32

arm-linux-gnueabihf-objdump -d asm32

arm-linux-gnueabihf-gcc -o hello32sta hello32.c -static -ggdb3
qemu-arm -L /usr/arm-linux-gnueabihf ./hello32sta -g 1234 &
gdb-multiarch -q --nh -ex 'set architecture arm' -ex 'file hello32sta' -ex 'target remote localhost:1234' -ex 'layout split' -ex 'layout regs'

(gdb) set solib-search-path /usr/arm-linux-gnueabihf/lib/
```

For many tools, basically just replace `tool` with `aarch64-linux-gnu-tool` for ARM64 or `arm-linux-gnueabihf-tool` for ARM32 (`as`, `ld`, `objdump`, etc.).

### ARM32 on emulated Raspberry Pi

["Emulate Raspberry Pi with QEMU" by Azeria Labs](https://azeria-labs.com/emulate-raspberry-pi-with-qemu/)
