%include "00_common.asm"

section .text
_start:
    ; /usr/include/asm/unistd_64.h
    ; "The kernel interface uses %rdi, %rsi, %rdx, %r10, %r8 and %r9."
    ; callee-saved: rbx, rbp, rsp, r12-r15

    mov rdi, 5
    call factorial

    EXIT

factorial:
    push rbp
    mov rbp, rsp

    push rbx

    mov rbx, rdi

    cmp rdi, 0
    je .zero

    dec rdi
    call factorial

    mul rbx
    jmp .done

.zero:
    mov rax, 1

.done:
    pop rbx

    mov rsp, rbp
    pop rbp
    ret
