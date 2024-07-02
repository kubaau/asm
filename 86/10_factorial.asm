%include "00_common.asm"

section .text
_start:
    mov ebx, 5
    call factorial

    EXIT

factorial:
    push ebp
    mov ebp, esp

    push esi

    mov esi, ebx

    cmp ebx, 0
    je .zero

    dec ebx
    call factorial

    mul esi
    jmp .done

.zero:
    mov eax, 1

.done:
    pop esi

    mov esp, ebp
    pop ebp
    ret
