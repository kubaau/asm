global _start

section .rodata
    WRITE: equ 4
    READ: equ 3
    EXIT: equ 1

    STDIN: equ 0
    STDOUT: equ 1

    BUF_SIZE: equ 64

section .data
    prompt: db "What is your name?", 10
    prompt_size: equ $ - prompt

    hello: db "Hello, "
    hello_size: equ $ - hello

section .bss
    buf: resb BUF_SIZE

section .text
_start:
    ; /usr/include/asm/unistd_32.h
    mov eax, WRITE
    mov ebx, STDOUT
    mov ecx, prompt
    mov edx, prompt_size
    int 0x80

    mov eax, READ
    mov ebx, STDIN
    mov ecx, buf
    mov edx, BUF_SIZE
    int 0x80

    mov esi, eax

    mov eax, WRITE
    mov ebx, STDOUT
    mov ecx, hello
    mov edx, hello_size
    int 0x80

    mov eax, WRITE
    mov ebx, STDOUT
    mov ecx, buf
    mov edx, esi
    int 0x80

    mov eax, EXIT
    xor ebx, ebx
    int 0x80
