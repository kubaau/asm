.global _start

.section .rodata
    .set WRITE, 4
    .set READ, 3
    .set EXIT, 1

    .set STDIN, 0
    .set STDOUT, 1

    .set BUF_SIZE, 64

    PROMPT: .ascii "What is your name?\n"
    .set PROMPT_SIZE, . - PROMPT

    HELLO: .ascii "Hello, "
    .set HELLO_SIZE, . - HELLO

.bss
    .lcomm buf, BUF_SIZE

.text
_start:
    ldr r7, =WRITE
    ldr r0, =STDOUT
    ldr r1, =PROMPT
    ldr r2, =PROMPT_SIZE
    svc #0

    ldr r7, =READ
    ldr r0, =STDIN
    ldr r1, =buf
    ldr r2, =BUF_SIZE
    svc #0

    mov r3, r0

    ldr r7, =WRITE
    ldr r0, =STDOUT
    ldr r1, =HELLO
    ldr r2, =HELLO_SIZE
    svc #0

    ldr r7, =WRITE
    ldr r0, =STDOUT
    ldr r1, =buf
    mov r2, r3
    svc #0

    ldr r7, =EXIT
    eor r0, r0
    svc #0
