global main

section .text
main:
    push rbp
    mov rbp, rsp

    mov rax, 1      ; int result = 1;
    mov rbx, 3      ; unsigned n = 3;
    mov rcx, 19     ; unsigned power = 19;

loop_start:
    test rcx, rcx   ; if (not power) goto loop_end;
    je loop_end

    test rcx, 1     ; if (power & 1 == 0) goto loop_tail;
    je loop_tail

    mul rbx         ; result *= n;
    dec rcx         ; --power;

loop_tail:
    mov rdi, rax    ; int temp = result;
    mov rax, rbx    ; result = n;
    mul rbx         ; result *= n;
    mov rbx, rax    ; n = result;
    mov rax, rdi    ; result = temp;
    shr rcx, 1      ; power /= 2;
    jmp loop_start

loop_end:
    leave
    ret
