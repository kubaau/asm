%include "00_common.asm"

section .bss
    buf: resb BUF_SIZE

section .text
_start:
    ; /usr/include/asm/unistd_64.h
    ; "The kernel interface uses %rdi, %rsi, %rdx, %r10, %r8 and %r9."

    CALL_READ buf, BUF_SIZE

    mov rdx, rax

    xor rcx, rcx            ; int i = 0;
    dec rdx                 ; int len = strlen(buf);

begin:
    cmp rcx, rdx            ; if (i == len) goto break;
    je done

    lea rbx, [buf + rcx]    ; char* cp = buf + i;
    xor rax, rax
    mov al, [rbx]           ; char c = *cp;
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
    mov ah, [rbx]           ; char mask = *cp;
    and ah, 32              ; mask &= 32; // islower
    or ah, 255 - 32         ; mask |= (255 - 32);
    and al, ah              ; c &= mask;

    mov [rbx], al           ; *cp = c;
    inc rcx                 ; ++i;
    jmp begin               ; goto begin;

done:
    inc rdx
    CALL_WRITE buf, rdx

    EXIT
