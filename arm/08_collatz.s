.include "00_common.s"

.text
_start:
    mov r0, #17
    bl countCollatz

    bl countCollatz

    mov r0, #2
    ldr lr, =.after_ret
    ldr pc, =countCollatz
.after_ret:
    EXIT

countCollatz:
    eor r2, r2

.loop:
    cmp r0, #1
    ble .done

    add r2, #1

    tst r0, #1
    bne .odd

.even:
    asr r0, #1
    b .loop

.odd:
    mov r1, #3
    mul r0, r1, r0
    add r0, #1
    b .loop

.done:
    mov r0, r2
    bx lr
