.global _start

.section .rodata
    .set WRITE, 4
    .set READ, 3
    .set EXIT, 1

    .set STDIN, 0
    .set STDOUT, 1

    .set BUF_SIZE, 64

.data
    str: .ascii "0123456789\n"
    .set str_size, . - str

.bss
    .lcomm buf, BUF_SIZE

.text
_start:
    ldr r7, =WRITE
    ldr r0, =STDOUT
    ldr r1, =str
    ldr r2, =str_size
    svc #0

    mov r0, #'a'
    strb r0, [r1]
    ldr r0, =STDOUT
    svc #0

    mov r0, #'c'
    lsl r0, r0, #8
    add r0, #'b'
    strh r0, [r1, #1]
    ldr r0, =STDOUT
    svc #0

    defg: .ascii "defg"
    ldr r0, defg
    str r0, [r1, #3]
    ldr r0, =STDOUT
    svc #0

    mov r0, #'x'
    mov r3, #2
    lsl r3, r3, #1
    add r3, #1
    strb r0, [r1, r3]
    ldr r0, =STDOUT
    svc #0

    add r1, #4
    sub r2, #4
    ldr r0, =STDOUT
    svc #0

    ldr r7, =READ
    ldr r0, =STDIN
    ldr r1, =buf
    ldr r2, =BUF_SIZE
    svc #0

    mov r2, r0
    sub r0, #1
    asr r0, r0, #1
    mov r3, #10
    strb r3, [r1, r0]
    ldr r7, =WRITE
    ldr r0, =STDOUT
    svc #0

    ldr r7, =EXIT
    eor r0, r0
    svc #0
