%include "00_common.asm"

section .bss
    buf: resb BUF_SIZE

section .text
_start:
    ; /usr/include/asm/unistd_64.h
    ; "The kernel interface uses %rdi, %rsi, %rdx, %r10, %r8 and %r9."

    CALL_READ buf, BUF_SIZE

    mov rbx, rax

    mov rdi, buf
    lea rsi, [rbx - 1]
    call revstr

    CALL_WRITE buf, rbx

    EXIT

revstr:
    xor rax, rax
    dec rsi
.loop:
    cmp rax, rsi
    jge .done

    mov dl, byte [rdi + rax]
    xchg dl, byte [rdi + rsi]
    mov byte [rdi + rax], dl

    inc rax
    dec rsi
    jmp .loop
.done:
    ret
