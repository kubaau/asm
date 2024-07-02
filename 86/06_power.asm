global _start

section .text
_start:
    mov ebx, 3      ; unsigned n = 3;
    mov ecx, 19     ; unsigned power = 19;
    mov edi, 1      ; int result = 1;

loop_start:
    test ecx, ecx   ; if (not power) goto loop_end;
    jz loop_end

    mov eax, ecx
    and eax, 1      ; if (power & 1 == 0) goto loop_tail;
    jz loop_tail

    mov eax, edi    ; int temp = result;
    mul ebx         ; temp *= n;
    mov edi, eax    ; result = temp;
    dec ecx         ; --power;

loop_tail:
    mov eax, ebx    ; temp = n;
    mul ebx         ; temp *= n;
    mov ebx, eax    ; n = temp;
    shr ecx, 1      ; power /= 2;
    jmp loop_start

loop_end:
    mov eax, 1
    xor ebx, ebx
    int 0x80
