global _start

section .rodata
    WRITE: equ 1
    READ: equ 0
    EXIT: equ 60

    STDIN: equ 0
    STDOUT: equ 1

    BUF_SIZE: equ 64

    PROMPT: db "What is your name?", 10
    PROMPT_SIZE: equ $ - PROMPT

    HELLO: db "Hello, "
    HELLO_SIZE: equ $ - HELLO

section .bss
    buf: resb BUF_SIZE

section .text
_start:
    ; /usr/include/asm/unistd_64.h
    ; "The kernel interface uses %rdi, %rsi, %rdx, %r10, %r8 and %r9."

    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, PROMPT
    mov rdx, PROMPT_SIZE
    syscall

    mov rax, READ
    mov rdi, STDIN
    mov rsi, buf
    mov rdx, BUF_SIZE
    syscall

    mov rbx, rax

    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, HELLO
    mov rdx, HELLO_SIZE
    syscall

    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, buf
    mov rdx, rbx
    syscall

    mov rax, EXIT
    xor rdi, rdi
    syscall
