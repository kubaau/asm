.include "00_common.s"

.bss
    .lcomm buf, BUF_SIZE

.text
_start:
    ldr r3, =buf
    ldr r4, =BUF_SIZE
    CALL_READ r3, r4

    mov r4, r0

    ldr r0, =buf
    mov r1, r4
    sub r1, #1
    bl revstr

    CALL_WRITE r3, r4

    EXIT

revstr:
    push {r5, r6, r7, r8}
    eor r2, r2
    sub r1, #1
.loop:
    cmp r2, r1
    bge .done

    ldrb r5, [r0, r2]

@    xchg dl, byte [rdi + rsi]
.xchg:
    mov r6, r0
    add r6, r1
    ldrexb r7, [r6]
    strexb r8, r5, [r6]
    tst r8, r8
    bne .xchg
    mov r5, r7

    strb r5, [r0, r2]

    add r2, #1
    sub r1, #1
    b .loop
.done:
    pop {r5, r6, r7, r8}
    bx lr
