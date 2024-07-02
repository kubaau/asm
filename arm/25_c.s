.macro CALL_WRITE buf, size
    mov r1, \buf
    mov r2, \size
    ldr r7, =WRITE
    ldr r0, =STDOUT
    svc #0
.endm

.global factorial
.global itoa2
.global atoi2

.section .rodata
    ATOI_ERROR: .ascii "Invalid atoi input\n"
    .set ATOI_ERROR_SIZE, . - ATOI_ERROR

    .set WRITE, 4

    .set STDOUT, 1

.text
factorial:
    push {r4, r11, lr}

    mov r4, r0

    tst r0, r0
    beq .zero

    sub r0, #1
    bl factorial

    mul r0, r4, r0
    b .factorial_done

.zero:
    mov r0, #1

.factorial_done:
    pop {r4, r11, pc}
    bx lr

atoi2:
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

itoa2:
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
.revstr_loop:
    cmp r2, r1
    bge .revstr_done

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
    b .revstr_loop
.revstr_done:
    pop {r5, r6, r7, r8}
    bx lr
