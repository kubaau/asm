%include "00_common.asm"

section .rodata
    arr: dd 3, 1, 3, 3, 7, 2
    arr_end: equ $

    endl: db 10

section .bss
    max: resd 1

section .text
_start:
    mov eax, arr            ; addr = arr;
    mov ebx, [eax]          ; val = *addr;
store:
    mov ecx, ebx            ; max = val;
no_store:
    add eax, 4              ; ++addr;
    cmp eax, arr_end        ; if (addr == ARR_END) goto done;
    je done

    mov ebx, [eax]          ; val = *addr;
    cmp ebx, ecx            ; if (val > max) goto store_max;
    jg store
    jmp no_store            ; else goto max_no_store;

done:
    add ecx, 48             ; to ASCII
    mov [max], ecx

    mov eax, WRITE
    mov ebx, STDOUT
    mov ecx, max
    mov edx, 1
    syscall

    mov eax, WRITE
    mov ecx, endl
    syscall

    EXIT
