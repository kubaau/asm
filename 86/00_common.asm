global _start

section .rodata
    WRITE: equ 4
    READ: equ 3
    EXIT: equ 1

    STDIN: equ 0
    STDOUT: equ 1

    BUF_SIZE: equ 64

    ENDL: db 10

%macro EXIT 0
    mov eax, 1
    xor ebx, ebx
    int 0x80
%endmacro

%macro syscall 0
    int 0x80
%endmacro

%macro CALL_READ 2
    mov ecx, %1
    mov edx, %2
    mov eax, READ
    mov ebx, STDIN
    syscall
%endmacro

%macro CALL_WRITE 2
    mov ecx, %1
    mov edx, %2
    mov eax, WRITE
    mov ebx, STDOUT
    syscall
%endmacro
