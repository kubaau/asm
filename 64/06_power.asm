global _start

section .text
_start:
    mov rbx, 3      ; unsigned n = 3;
    mov rcx, 19     ; unsigned power = 19;
    mov rdi, 1      ; int result = 1;

loop_start:
    test rcx, rcx   ; if (not power) goto loop_end;
    jz loop_end

    mov rax, rcx
    and rax, 1      ; if (power & 1 == 0) goto loop_tail;
    jz loop_tail

    mov rax, rdi    ; int temp = result;
    mul rbx         ; temp *= n;
    mov rdi, rax    ; result = temp;
    dec rcx         ; --power;

loop_tail:
    mov rax, rbx    ; temp = n;
    mul rbx         ; temp *= n;
    mov rbx, rax    ; n = temp;
    shr rcx, 1      ; power /= 2;
    jmp loop_start

loop_end:
    mov rax, 60
    xor rdi, rdi
    syscall
