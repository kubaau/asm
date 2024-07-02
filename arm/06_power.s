.global _start

.text
_start:
    mov r1, #3      @ unsigned n = 3;
    mov r2, #19     @ unsigned power = 19;
    mov r3, #1      @ int result = 1;

loop_start:
    tst r2, r2
    beq loop_end

    tst r2, #1
    beq loop_tail

    mul r3, r1, r3
    sub r2, #1

loop_tail:
    mov r0, r1
    mul r1, r0, r1
    asr r2, #1
    b loop_start

loop_end:
    mov r7, #1
    eor r0, r0
    svc #0
