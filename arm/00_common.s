.global _start

.section .rodata
    .set WRITE, 4
    .set READ, 3
    .set EXIT, 1

    .set STDIN, 0
    .set STDOUT, 1

    .set BUF_SIZE, 64

    ENDL: .word 10

.macro EXIT
    ldr r7, =EXIT
    eor r0, r0
    svc #0
.endm

.macro CALL_READ buf, size
    mov r1, \buf
    mov r2, \size
    ldr r7, =READ
    ldr r0, =STDIN
    svc #0
.endm

.macro CALL_WRITE buf, size
    mov r1, \buf
    mov r2, \size
    ldr r7, =WRITE
    ldr r0, =STDOUT
    svc #0
.endm
