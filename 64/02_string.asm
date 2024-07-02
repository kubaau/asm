global _start

section .rodata
    WRITE: equ 1
    READ: equ 0
    EXIT: equ 60

    STDIN: equ 0
    STDOUT: equ 1

    BUF_SIZE: equ 64

section .data
    str: db "0123456789", 10
    str_size: equ $ - str

section .bss
    buf: resb BUF_SIZE

section .text
_start:
    ; /usr/include/asm/unistd_64.h
    ; "The kernel interface uses %rdi, %rsi, %rdx, %r10, %r8 and %r9."

    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, str
    mov rdx, str_size
    syscall

    mov byte [str], 'a'
    mov rax, WRITE
    syscall

    mov word [str + 1], "bc"
    mov rax, WRITE
    syscall

    mov dword [str + 3], "defg"
    mov rax, WRITE
    syscall

    mov rax, 2
    mov byte [str + 2 * rax + 1], "x"   ; *(str + 2 * rax + 1) = 'x';
    mov rax, WRITE
    syscall

    mov rax, 2
    lea rsi, [str + rax * 2]            ; rsi = str + rax * 2;
    sub rdx, 4
    mov rax, WRITE
    syscall

    mov rax, READ
    mov rdi, STDIN
    mov rsi, buf
    mov rdx, BUF_SIZE
    syscall

    mov rdx, rax
    dec rax
    shr rax, 1
    mov byte [buf + rax], 10
    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, buf
    syscall

    mov rax, EXIT
    xor rdi, rdi
    syscall
