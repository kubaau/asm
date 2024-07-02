running without rpi:

sudo apt install gdb-multiarch qemu-user qemu-user-static gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu binutils-aarch64-linux-gnu-dbg gcc-arm-linux-gnueabihf binutils-arm-linux-gnueabihf binutils-arm-linux-gnueabihf-dbg

then replace as with arm-linux-gnueabihf-as (aarch64-linux-gnu-as for aarch64)
and ld with arm-linux-gnueabihf-ld (aarch64-linux-gnu-ld for aarch64)
and similar with other tools (like objdump)

