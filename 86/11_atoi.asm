%include "00_common.asm"

section .rodata
    ATOI_ERROR: db 'Invalid atoi input', 10
    ATOI_ERROR_SIZE: equ $ - ATOI_ERROR

section .bss
    buf: resb BUF_SIZE

section .text
_start:
    CALL_READ buf, BUF_SIZE

    mov ebx, buf
    lea ecx, [eax - 1]
    call atoi

    EXIT

atoi:                       ; unsigned atoi(const char* str, int size);
                            ; {
    xor eax, eax            ;   unsigned ret = 0;
    xor esi, esi            ;   int i = 0;
.loop:
    cmp esi, ecx            ;   if (i >= size) goto .done
    jge .done

    mov edx, 10
    mul edx                 ;   ret *= 10;

    xor edx, edx
    mov dl, [ebx + esi]     ;   unsigned n = str[i];
    sub dl, '0'             ;   n -= '0';
    cmp dx, 9               ;   if (n > 9) goto .error;
    jg .error

    add eax, edx            ;   ret += n;
    inc esi                 ;   ++i;
    jmp .loop               ;   goto .loop;
.error:
    CALL_WRITE ATOI_ERROR, ATOI_ERROR_SIZE
    mov eax, -1
.done:
                            ; }
    ret                     ;   return ret;
