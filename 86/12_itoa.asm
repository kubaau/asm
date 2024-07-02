%include "00_common.asm"

section .bss
    buf: resb BUF_SIZE

section .text
_start:
    mov ebx, 31337
    mov ecx, buf
    call itoa

    CALL_WRITE buf, eax

    EXIT

itoa:                       ; int itoa(int n, char* dest)
    enter 0, 0
    push edi
    push esi

    mov edi, ebx
    xor esi, esi

.loop:
    mov eax, edi
    mov ebx, 10
    xor edx, edx
    div ebx

    mov edi, eax

    add edx, '0'
    mov byte [buf + esi], dl
    inc esi

    test edi, edi
    jz .done

    jmp .loop

.done:
    mov ebx, buf
    mov ecx, esi
    call revstr

    mov eax, esi
    pop esi
    pop edi
    leave
    ret

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
