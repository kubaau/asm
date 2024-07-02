%include "00_common.asm"

section .bss
    buf: resb BUF_SIZE

section .text
_start:
    CALL_READ buf, BUF_SIZE

    mov esi, eax

    xor ecx, ecx            ; int i = 0;
    dec esi                 ; int len = strlen(buf);

begin:
    cmp ecx, esi            ; if (i == len) goto break;
    je done

    lea ebx, [buf + ecx]    ; char* cp = buf + i;
    xor eax, eax
    mov al, [ebx]           ; char c = *cp;
    or al, 32               ; c = tolower(c);

    cmp al, 'a'             ; if (c < 'a') goto next_iteration;
    jl next_iteration
    cmp al, 'z'             ; if (c > 'z') goto next_iteration;
    jg next_iteration

    add al, 13              ; c += 13;
    cmp ax, 'z'             ; if (c <= 'z') goto next_iteration;
    jle next_iteration
    sub al, 26              ; c -= 26;

next_iteration:
    mov ah, [ebx]           ; char mask = *cp;
    and ah, 32              ; mask &= 32; // islower
    or ah, 255 - 32         ; mask |= (255 - 32);
    and al, ah              ; c &= mask;

    mov [ebx], al           ; *cp = c;
    inc ecx                 ; ++i;
    jmp begin               ; goto begin;

done:
    inc esi
    CALL_WRITE buf, esi

    EXIT
