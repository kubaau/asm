.include "00_common.s"

.section .rodata
    ARR: .word 3, 1, 3, 3, 7, 2
    .set ARR_END, .

.bss
    .lcomm max, 4

.text
_start:
    ldr r0, =ARR
    ldr r1, [r0]
    ldr r3, =ARR_END
store:
    mov r2, r1
no_store:
    add r0, #4
    cmp r0, r3
    beq done

    ldr r1, [r0]
    cmp r1, r2
    bgt store
    b no_store

done:
    add r2, #48
    ldr r1, =max
    str r2, [r1]

    ldr r7, =WRITE
    ldr r0, =STDOUT
    ldr r1, =max
    mov r2, #1
    svc #0

    ldr r7, =WRITE
    ldr r0, =STDOUT
    ldr r1, =ENDL
    svc #0

    EXIT
