.include "00_common.s"

.section .rodata
    .set FIBS_SIZE, 24
    LOOKUP: .ascii " lookup successful\n"
    .set LOOKUP_SIZE, . - LOOKUP

.bss
    .lcomm buf, BUF_SIZE

    .lcomm fibs, FIBS_SIZE * 2

.text
.macro PRINT_FIB n
    ldr r0, =\n
    bl fib
    ldr r1, =buf
    bl itoa
    ldr r3, =buf
    mov r4, r0
    CALL_WRITE r3, r4
    ldr r3, =ENDL
    mov r4, #1
    CALL_WRITE r3, r4
.endm

_start:
    eor r0, r0
    ldr r1, =fibs
    eor r2, r2      @     xor rcx, rcx
    ldr r3, =FIBS_SIZE
 .fibsZeroLoop:
    teq r2, r3      @     cmp rcx, FIBS_SIZE
    beq .fibsZeroed @     je .fibsZeroed
    lsl r2, #1
    strh r0, [r1, r2] @     mov word [fibs + rcx * 2], 0
    lsr r2, #1
    add r2, #1      @     inc rcx
    b .fibsZeroLoop @     jmp .fibsZeroLoop

 .fibsZeroed:
     PRINT_FIB 0
     PRINT_FIB 1
     PRINT_FIB 2
     PRINT_FIB 3
     PRINT_FIB 4
     PRINT_FIB 5
     PRINT_FIB 6
     PRINT_FIB 7
     PRINT_FIB 8
     PRINT_FIB 9
     PRINT_FIB 10
     PRINT_FIB 11
     PRINT_FIB 12
     PRINT_FIB 13
     PRINT_FIB 23
     PRINT_FIB 24
     PRINT_FIB 25

    EXIT

fib:
    push {r4, r5, r6, r8, r11, lr}  @     push rbx                ; {
                    @     push r12

    mov r4, r0
    ldr r5, =fibs
    ldr r6, =buf

    ldr r1, =FIBS_SIZE
    cmp r4, r1      @     cmp rdi, FIBS_SIZE
    bge .noLookup   @     jge .noLookup    
    eor r0, r0      @     xor ax, ax
    lsl r4, #1
    ldrh r0, [r5, r4] @     mov ax, [fibs + rdi * 2];   fib_n = fibs[n];
    lsr r4, #1
    tst r0, r0      @     test ax, ax             ;   if (fib_n > 0) return fib_n;
    beq .noLookup   @     jz .noLookup

.retByLookup:
    mov r8, r0      @     mov rbx, rax

                    @     mov rdi, rax
    mov r1, r6      @     mov rsi, buf
    bl itoa         @     call itoa
    CALL_WRITE r6, r0 @     CALL_WRITE buf, rax
    ldr r1, =LOOKUP
    ldr r2, =LOOKUP_SIZE
    CALL_WRITE r1, r2 @     CALL_WRITE LOOKUP, LOOKUP_SIZE

    mov r0, r8      @     mov rax, rbx

    b .fib_done     @     jmp .done

.noLookup:
    mov r8, r4      @     mov rbx, rdi            ;   temp_n = n;

    tst r4, r4      @     test rdi, rdi           ;   if (n == 0) return 0;
    beq .ret0       @     jz .ret0

    cmp r4, #2      @     cmp rdi, 2              ;   if (n <= 2) return 1;
    ble .ret1       @     jle .ret1

    mov r0, r4
    sub r0, #1      @     dec rdi                 ;   --n;
    bl fib          @     call fib                ;   ret = fib(n);
    mov r6, r0      @     mov r12, rax            ;   temp_ret = ret;

    mov r0, r8      @     mov rdi, rbx            ;   n = temp_n;
    sub r0, #2      @     sub rdi, 2              ;   n -= 2;
    bl fib          @     call fib                ;   ret = fib(n);
    add r0, r6      @     add rax, r12            ;   return ret + temp_ret;

    ldr r1, =FIBS_SIZE
    cmp r8, r1      @     cmp rbx, FIBS_SIZE
    bge .fib_done   @     jge .done
    b .save         @     jmp .save

.ret0:
    eor r0, r0      @     xor rax, rax
    b .save         @     jmp .save
.ret1:
    mov r0, #1      @     mov rax, 1
.save:
    lsl r8, #1
    strh r0, [r5, r8] @     mov word [fibs + rbx * 2], ax
    lsr r8, #1
.fib_done:
    pop {r4, r5, r6, r8, r11, pc}   @     pop r12
                    @     pop rbx                 ; }
    bx lr           @     ret ; fib

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
