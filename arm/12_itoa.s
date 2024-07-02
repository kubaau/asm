.include "00_common.s"

.bss
    .lcomm buf, BUF_SIZE

.text
_start:
    ldr r0, =31337
    ldr r1, =buf
    bl itoa

    ldr r3, =buf
    mov r4, r0
    CALL_WRITE r3, r4

    EXIT

itoa:
    push {r11, lr}  @     enter 0, 0
                    @     push rbx

    eor r2, r2      @     xor rcx, rcx
.itoa_loop:
@     mov rax, rdi
@     mov rbx, 10
@     xor rdx, rdx
@     div rbx
    ldr r3, =0xcccccccd
    umull r11, r3, r0, r3
    mov r11, r3, lsr #3
@     mov rdi, rax
    ldr r3, =10
    mul r3, r11, r3
    sub r3, r0, r3
    mov r0, r11

    add r3, #'0'    @     add rdx, '0'
    strb r3, [r1, r2] @     mov byte [buf + rcx], dl
    add r2, #1      @     inc rcx

    tst r0, r0      @     test rdi, rdi
    beq .itoa_done  @     jz .done

    b .itoa_loop    @     jmp .loop

.itoa_done:
    mov r11, r2     @     mov rbx, rcx
    mov r0, r1      @     mov rdi, buf
    mov r1, r2      @     mov rsi, rcx
    bl revstr       @     call revstr

    mov r0, r11     @     mov rax, rbx
                    @     pop rbx
    pop {r11, pc}   @     leave
    bx lr           @     ret

revstr:
    push {r5, r6, r7, r8}
    eor r2, r2
    sub r1, #1
.loop:
    cmp r2, r1
    bge .done

    ldrb r5, [r0, r2]

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
