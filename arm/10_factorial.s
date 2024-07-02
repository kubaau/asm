.include "00_common.s"

.text
_start:
    mov r0, #5
    bl factorial

    EXIT

factorial:
    push {r4, r11, lr}

    mov r4, r0

    tst r0, r0
    beq .zero

    sub r0, #1
    bl factorial

    mul r0, r4, r0
    b .done

.zero:
    mov r0, #1

.done:
    pop {r4, r11, pc}
    bx lr
