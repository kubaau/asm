%include "00_common.asm"

section .text
_start:
    mov ebx, 17
    call countCollatz

    call countCollatz

    mov ebx, 2
    push .after_ret
    push countCollatz
    ret
.after_ret:
    EXIT

countCollatz:
    xor ecx, ecx            ; int i = 0;

.loop:
    cmp ebx, 1              ; if (n <= 1) goto .done;
    jle .done

    inc ecx                 ; ++i;

    mov eax, ebx            ; int temp = n;
    and eax, 1              ; temp &= 1;
    cmp eax, 1              ; if (temp == 1) goto .odd;
    je .odd

.even:
    shr ebx, 1              ; n /= 2;
    jmp .loop               ; goto .loop;

.odd:
    lea ebx, [ebx * 3 + 1]  ; n = n * 3 + 1;
    jmp .loop               ; goto .loop;

.done:
    mov eax, ecx            ; int ret = i;
    ret ;countCollatz       ; return ret;
