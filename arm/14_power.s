.global main

.text
main:
    push {r11, lr}  @     push rbp
                    @     mov rbp, rsp

    mov r3, #1      @     mov rax, 1      ; int result = 1;
    mov r1, #3      @     mov rbx, 3      ; unsigned n = 3;
    mov r2, #19     @     mov rcx, 19     ; unsigned power = 19;

loop_start:
    tst r2, r2      @     test rcx, rcx   ; if (not power) goto loop_end;
    beq loop_end    @     je loop_end

    tst r2, #1      @     test rcx, 1     ; if (power & 1 == 0) goto loop_tail;
    beq loop_tail   @     je loop_tail

    mul r3, r1, r3  @     mul rbx         ; result *= n;
    sub r2, #1      @     dec rcx         ; --power;

loop_tail:
    mov r0, r1      @     mov rdi, rax    ; int temp = result;
                    @     mov rax, rbx    ; result = n;
    mul r1, r0, r1  @     mul rbx         ; result *= n;
                    @     mov rbx, rax    ; n = result;
                    @     mov rax, rdi    ; result = temp;
    asr r2, #1      @     shr rcx, 1      ; power /= 2;
    b loop_start    @     jmp loop_start

loop_end:
    pop {r11, pc}   @     leave
    bx lr           @     ret
