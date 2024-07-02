%include "00_common.asm"

section .bss
    buf: resb BUF_SIZE

section .text
_start:
    ; /usr/include/asm/unistd_64.h
    ; "The kernel interface uses %rdi, %rsi, %rdx, %r10, %r8 and %r9."

    CALL_READ buf, BUF_SIZE

    mov r8, rax
    dec rax

    mov rdi, buf
    mov rsi, rax

    and rax, 1
    mov rbx, plusize
    xor rcx, rcx ; mask = 00000000
    sub rcx, rax ; mask = 11111111 if size is odd
    mov rdx, minusize - plusize
    and rdx, rcx ; offset &= mask;
    add rbx, rdx
    call rbx

    CALL_WRITE buf, r8

    EXIT

plusize:
    xor rcx, rcx
.loop:
    cmp rcx, rsi
    je .done
    mov byte [rdi + rcx], '+'
    inc rcx
    jmp .loop
.done:
    ret

minusize:
    xor rcx, rcx
.loop:
    cmp rcx, rsi
    je .done
    mov byte [rdi + rcx], '-'
    inc rcx
    jmp .loop
.done:
    ret
