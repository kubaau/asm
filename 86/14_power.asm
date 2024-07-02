global main

section .text
main:
    push ebp
    mov ebp, esp

    mov eax, 1      ; int result = 1;
    mov ebx, 3      ; unsigned n = 3;
    mov ecx, 19     ; unsigned power = 19;

loop_start:
    test ecx, ecx   ; if (not power) goto loop_end;
    je loop_end

    test ecx, 1     ; if (power & 1 == 0) goto loop_tail;
    je loop_tail

    mul ebx         ; result *= n;
    dec ecx         ; --power;

loop_tail:
    mov edi, eax    ; int temp = result;
    mov eax, ebx    ; result = n;
    mul ebx         ; result *= n;
    mov ebx, eax    ; n = result;
    mov eax, edi    ; result = temp;
    shr ecx, 1      ; power /= 2;
    jmp loop_start

loop_end:
    leave
    ret
