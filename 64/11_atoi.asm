%include "00_common.asm"

section .rodata
    ATOI_ERROR: db 'Invalid atoi input', 10
    ATOI_ERROR_SIZE: equ $ - ATOI_ERROR

section .bss
    buf: resb BUF_SIZE

section .text
_start:
    ; /usr/include/asm/unistd_64.h
    ; "The kernel interface uses %rdi, %rsi, %rdx, %r10, %r8 and %r9."
    ; callee-saved: rbx, rbp, rsp, r12-r15

    CALL_READ buf, BUF_SIZE

    mov rdi, buf
    lea rsi, [rax - 1]
    call atoi

    EXIT

atoi:                       ; unsigned atoi(const char* str, int size);
                            ; {
    xor rax, rax            ;   unsigned ret = 0;
    xor rcx, rcx            ;   int i = 0;
.loop:
    cmp rcx, rsi            ;   if (i >= size) goto .done
    jge .done

    mov rdx, 10
    mul rdx                 ;   ret *= 10;

    xor rdx, rdx
    mov dl, [rdi + rcx]     ;   unsigned n = str[i];
    sub dl, '0'             ;   n -= '0';
    cmp dx, 9               ;   if (n > 9) goto .error;
    jg .error

    add rax, rdx            ;   ret += n;
    inc rcx                 ;   ++i;
    jmp .loop               ;   goto .loop;
.error:
    CALL_WRITE ATOI_ERROR, ATOI_ERROR_SIZE
    mov rax, -1
.done:
                            ; }
    ret                     ;   return ret;
