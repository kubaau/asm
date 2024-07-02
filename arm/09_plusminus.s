.include "00_common.s"

.bss
    .lcomm buf, BUF_SIZE

.text
_start:
    ldr r3, =buf
    ldr r4, =BUF_SIZE
    CALL_READ r3, r4

    mov r8, r0
    mov r2, r0
    sub r2, #1

    ldr r0, =buf
    mov r1, r2

    and r2, #1
    ldr r3, =plusize
    eor r4, r4
    sub r4, r2
    mov r5, #minusize
    sub r5, #plusize
    and r5, r4
    add r3, r5
    ldr lr, =.ret
    mov pc, r3

.ret:
    ldr r3, =buf
    CALL_WRITE r3, r8

    EXIT

plusize:
    eor r2, r2
    mov r3, #'+'
.loop_plus:
    cmp r2, r1
    beq .done_plus
    strb r3, [r0, r2]
    add r2, #1
    b .loop_plus
.done_plus:
    bx lr

minusize:
    eor r2, r2
    mov r3, #'-'
.loop_minus:
    cmp r2, r1
    beq .done_minus
    strb r3, [r0, r2]
    add r2, #1
    b .loop_minus
.done_minus:
    bx lr
