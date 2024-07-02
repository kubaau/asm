global _start

section .rodata
    WRITE: equ 1
    READ: equ 0
    EXIT: equ 60

    STDIN: equ 0
    STDOUT: equ 1

    BUF_SIZE: equ 64

    ENDL: db 10

%macro EXIT 0
    mov rax, EXIT
    xor rdi, rdi
    syscall
%endmacro

%macro CALL_READ 2
    mov rsi, %1
    mov rdx, %2
    mov rax, READ
    mov rdi, STDIN
    syscall
%endmacro

%macro CALL_WRITE 2
    mov rsi, %1
    mov rdx, %2
    mov rax, WRITE
    mov rdi, STDOUT
    syscall
%endmacro
