%include "00_common.asm"

section .text
_start:
    ; /usr/include/asm/unistd_64.h
    ; "The kernel interface uses %rdi, %rsi, %rdx, %r10, %r8 and %r9."

    mov rdi, 17
    call countCollatz

    call countCollatz

    mov rdi, 2
    push .after_ret
    push countCollatz
    ret
.after_ret:
    EXIT

countCollatz:
    xor rcx, rcx            ; int i = 0;

.loop:
    cmp rdi, 1              ; if (n <= 1) goto .done;
    jle .done

    inc rcx                 ; ++i;

    mov rax, rdi            ; int temp = n;
    and rax, 1              ; temp &= 1;
    cmp rax, 1              ; if (temp == 1) goto .odd;
    je .odd

.even:
    shr rdi, 1              ; n /= 2;
    jmp .loop               ; goto .loop;

.odd:
    lea rdi, [rdi * 3 + 1]  ; n = n * 3 + 1;
    jmp .loop               ; goto .loop;

.done:
    mov rax, rcx            ; int ret = i;
    ret ;countCollatz       ; return ret;
