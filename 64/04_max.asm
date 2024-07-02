%include "00_common.asm"

section .rodata
    ARR: dd 3, 1, 3, 3, 7, 2
    ARR_END: equ $

section .bss
    max: resd 1

section .text
_start:
    ; /usr/include/asm/unistd_64.h
    ; "The kernel interface uses %rdi, %rsi, %rdx, %r10, %r8 and %r9."

    mov rax, ARR            ; addr = arr;
    mov ebx, [rax]          ; val = *addr;
store:
    mov ecx, ebx            ; max = val;
no_store:
    add rax, 4              ; ++addr;
    cmp rax, ARR_END        ; if (addr == ARR_END) goto done;
    je done

    mov ebx, [rax]          ; val = *addr;
    cmp ebx, ecx            ; if (val > max) goto store_max;
    jg store
    jmp no_store            ; else goto max_no_store;

done:
    add ecx, 48             ; to ASCII
    mov [max], ecx

    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, max
    mov rdx, 1
    syscall

    mov rax, WRITE
    mov rsi, ENDL
    syscall

    EXIT
