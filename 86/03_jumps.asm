%include "00_common.asm"

section .rodata
    unused: db "bla"
    unused_size: equ $ - unused

    less: db 'size < 16', 10
    less_size: equ $ - less

    more: db 'size >= 16', 10
    more_size: equ $ - more

section .bss
    buf: resb BUF_SIZE

section .text
_start:
    jmp after_unused

    mov eax, WRITE
    mov ebx, STDOUT
    mov ecx, unused
    mov edx, unused_size
    syscall

after_unused:
    mov eax, READ
    mov ebx, STDIN
    mov ecx, buf
    mov edx, BUF_SIZE
    syscall

    mov esi, eax

    cmp eax, 16
    jl .less

    mov eax, WRITE
    mov ebx, STDOUT
    mov ecx, more
    mov edx, more_size
    syscall

    jmp after_less

.less:
    mov eax, WRITE
    mov ebx, STDOUT
    mov ecx, less
    mov edx, less_size
    syscall

after_less:
    dec esi

    xor ecx, ecx
loop_begin:
    cmp ecx, esi
    je loop_done

    inc byte [buf + ecx]
    inc ecx
    jmp loop_begin

loop_done:
    inc esi

    mov eax, WRITE
    mov ebx, STDOUT
    mov ecx, buf
    mov edx, esi
    syscall

    EXIT
