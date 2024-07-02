%include "00_common.asm"

section .bss
    buf: resb BUF_SIZE

section .text
_start:
    ; /usr/include/asm/unistd_64.h
    ; "The kernel interface uses %rdi, %rsi, %rdx, %r10, %r8 and %r9."
    ; callee-saved: rbx, rbp, rsp, r12-r15

    mov rdi, 31337
    mov rsi, buf
    call itoa

    CALL_WRITE buf, rax

    EXIT

itoa:                       ; int itoa(int n, char* dest)
    enter 0, 0
    push rbx

    xor rcx, rcx
.loop:
    mov rax, rdi
    mov rbx, 10
    xor rdx, rdx
    div rbx

    mov rdi, rax

    add rdx, '0'
    mov byte [buf + rcx], dl
    inc rcx

    test rdi, rdi
    jz .done

    jmp .loop

.done:
    mov rbx, rcx

    mov rdi, buf
    mov rsi, rcx
    call revstr

    mov rax, rbx
    pop rbx
    leave
    ret

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
