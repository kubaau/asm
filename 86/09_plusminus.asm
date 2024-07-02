%include "00_common.asm"

section .bss
    buf: resb BUF_SIZE

section .text
_start:
    CALL_READ buf, BUF_SIZE

    mov ebp, eax
    dec eax

    mov ebx, buf
    mov ecx, eax

    and eax, 1
    mov edx, plusize
    xor edi, edi ; mask = 00000000
    sub edi, eax ; mask = 11111111 if size is odd
    mov esi, minusize - plusize
    and esi, edi ; offset &= mask;
    add edx, esi
    call edx

    CALL_WRITE buf, ebp

    EXIT

plusize:
    xor edx, edx
.loop:
    cmp edx, ecx
    je .done
    mov byte [ebx + edx], '+'
    inc edx
    jmp .loop
.done:
    ret

minusize:
    xor edx, edx
.loop:
    cmp edx, ecx
    je .done
    mov byte [ebx + edx], '-'
    inc edx
    jmp .loop
.done:
    ret
