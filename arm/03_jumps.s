.include "00_common.s"

.section .rodata
    UNUSED: .ascii "bla"
    .set UNUSED_SIZE, . - UNUSED

    LESS: .ascii "size < 16\n"
    .set LESS_SIZE, . - LESS

    MORE: .ascii "size >= 16\n"
    .set MORE_SIZE, . - MORE

.bss
    .lcomm buf, BUF_SIZE

.text
_start:
    b after_unused

    ldr r7, =WRITE
    ldr r0, =STDOUT
    ldr r1, =UNUSED
    ldr r2, =UNUSED_SIZE
    svc #0

after_unused:
    ldr r7, =READ
    ldr r0, =STDIN
    ldr r1, =buf
    ldr r2, =BUF_SIZE
    svc #0

    mov r3, r0

    cmp r0, #16
    blt .less

    ldr r7, =WRITE
    ldr r0, =STDOUT
    ldr r1, =MORE
    ldr r2, =MORE_SIZE
    svc #0

    b after_less

.less:
    ldr r7, =WRITE
    ldr r0, =STDOUT
    ldr r1, =LESS
    ldr r2, =LESS_SIZE
    svc #0

after_less:
    sub r3, #1

    eor r0, r0
loop_begin:
    cmp r0, r3
    beq loop_done

    ldr r1, =buf
    ldr r2, [r1, r0]
    add r2, #1
    str r2, [r1, r0]
    add r0, #1
    b loop_begin

loop_done:
    add r3, #1

    ldr r7, =WRITE
    ldr r0, =STDOUT
    ldr r1, =buf
    mov r2, r3
    svc #0

    EXIT
