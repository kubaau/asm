global _start

section .rodata
    WRITE: equ 4
    READ: equ 3
    EXIT: equ 1

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
    mov eax, WRITE
    mov ebx, STDOUT
    mov ecx, str
    mov edx, str_size
    int 0x80

    mov byte [str], 'a'
    mov eax, WRITE
    int 0x80

    mov word [str + 1], "bc"
    mov eax, WRITE
    int 0x80

    mov dword [str + 3], "defg"
    mov eax, WRITE
    int 0x80

    mov eax, 2
    mov byte [str + 2 * eax + 1], "x"   ; *(str + 2 * eax + 1) = 'x';
    mov eax, WRITE
    int 0x80

    mov eax, 2
    lea esi, [str + eax * 2]            ; esi = str + eax * 2;
    sub edx, 4
    mov eax, WRITE
    mov ecx, esi
    int 0x80

    mov eax, READ
    mov ebx, STDIN
    mov ecx, buf
    mov edx, BUF_SIZE
    int 0x80

    mov edx, eax
    dec eax
    shr eax, 1
    mov byte [buf + eax], 10
    mov eax, WRITE
    mov ebx, STDOUT
    mov ecx, buf
    int 0x80

    mov eax, EXIT
    xor ebx, ebx
    int 0x80
