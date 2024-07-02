.include "00_common.s"

.section .rodata
    ATOI_ERROR: .ascii "Invalid atoi input\n"
    .set ATOI_ERROR_SIZE, . - ATOI_ERROR

.bss
    .lcomm buf, BUF_SIZE

.text
_start:
    ldr r3, =buf
    ldr r4, =BUF_SIZE
    CALL_READ r3, r4

    mov r1, r0
    sub r1, #1
    mov r0, r3
    bl atoi

    EXIT

atoi:
    eor r4, r4
    eor r5, r5
.loop:
    cmp r5, r1
    bge .done

    mov r6, #10
    mul r4, r6, r4

    eor r6, r6
    ldrb r6, [r0, r5]
    sub r6, #'0'
    cmp r6, #9
    bgt .error

    add r4, r6
    add r5, #1
    b .loop
.error:
    ldr r3, =ATOI_ERROR
    ldr r4, =ATOI_ERROR_SIZE
    CALL_WRITE r3, r4
    mov r4, #-1
.done:
    mov r0, r4
    bx lr
