%include "00_common.asm"

section .rodata
    UNUSED: db "bla"
    UNUSED_SIZE: equ $ - UNUSED

    LESS: db 'size < 16', 10
    LESS_SIZE: equ $ - LESS

    MORE: db 'size >= 16', 10
    MORE_SIZE: equ $ - MORE

section .bss
    buf: resb BUF_SIZE

section .text
_start:
    ; /usr/include/asm/unistd_64.h
    ; "The kernel interface uses %rdi, %rsi, %rdx, %r10, %r8 and %r9."

    jmp after_unused

    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, UNUSED
    mov rdx, UNUSED_SIZE
    syscall

after_unused:
    mov rax, READ
    mov rdi, STDIN
    mov rsi, buf
    mov rdx, BUF_SIZE
    syscall

    mov rbx, rax

    cmp rax, 16
    jl .less

    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, MORE
    mov rdx, MORE_SIZE
    syscall

    jmp after_less

.less:
    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, LESS
    mov rdx, LESS_SIZE
    syscall

after_less:
    dec rbx

    xor rcx, rcx
loop_begin:
    cmp rcx, rbx
    je loop_done

    inc byte [buf + rcx]
    inc rcx
    jmp loop_begin

loop_done:
    inc rbx

    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, buf
    mov rdx, rbx
    syscall

    EXIT
