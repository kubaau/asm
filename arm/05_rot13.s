.include "00_common.s"

.bss
    .lcomm buf, BUF_SIZE

.text
_start:
    ldr r4, =buf
    ldr r3, =BUF_SIZE
    CALL_READ r4, r3

    mov r3, r0

    eor r2, r2
    sub r3, #1

begin:
    cmp r2, r3
    beq done

    ldr r1, =buf
    add r1, r2
    eor r0, r0
    ldrb r0, [r1]
    orr r0, #32

    cmp r0, #'a'
    blt next_iteration
    cmp r0, #'z'
    bgt next_iteration

    add r0, #13
    cmp r0, #'z'
    ble next_iteration
    sub r0, #26

next_iteration:
    eor r4, r4
    ldrb r4, [r1]
    and r4, #32
    orr r4, #255-32
    and r0, r4

    strb r0, [r1]
    add r2, #1
    b begin

done:
    add r3, #1
    ldr r4, =buf
    CALL_WRITE r4, r3

    EXIT
