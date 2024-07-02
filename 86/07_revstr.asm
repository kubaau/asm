%include "00_common.asm"

section .bss
    buf: resb BUF_SIZE

section .text
_start:
    CALL_READ buf, BUF_SIZE

    mov edi, eax

    mov ebx, buf
    lea ecx, [edi - 1]
    call revstr

    CALL_WRITE buf, edi

    EXIT

revstr:
    xor eax, eax
    dec ecx
.loop:
    cmp eax, ecx
    jge .done

    mov dl, byte [ebx + eax]
    xchg dl, byte [ebx + ecx]
    mov byte [ebx + eax], dl

    inc eax
    dec ecx
    jmp .loop
.done:
    ret
