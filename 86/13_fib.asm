%include "00_common.asm"

section .rodata
    FIBS_SIZE: equ 24

    LOOKUP: db ' lookup successful', 10
    LOOKUP_SIZE: equ $ - LOOKUP

section .bss
    buf: resb BUF_SIZE

    fibs: resw FIBS_SIZE

section .text
%macro PRINT_FIB 1
mov ebx, %1
call fib
mov ebx, eax
mov ecx, buf
call itoa
CALL_WRITE buf, eax
CALL_WRITE ENDL, 1
%endmacro

_start:
    lea edi, [fibs]
    xor eax, eax
    mov ecx, FIBS_SIZE
    rep stosw

.fibsZeroed:
    PRINT_FIB 0
    PRINT_FIB 1
    PRINT_FIB 2
    PRINT_FIB 3
    PRINT_FIB 4
    PRINT_FIB 5
    PRINT_FIB 6
    PRINT_FIB 7
    PRINT_FIB 8
    PRINT_FIB 9
    PRINT_FIB 10
    PRINT_FIB 11
    PRINT_FIB 12
    PRINT_FIB 13
    PRINT_FIB 23
    PRINT_FIB 24
    PRINT_FIB 25

    EXIT

fib:                        ; unsigned fib(unsigned n)
    push esi                ; {
    push edi

    cmp ebx, FIBS_SIZE
    jge .noLookup
    xor ax, ax
    mov ax, [fibs + ebx * 2];   fib_n = fibs[n];
    test ax, ax             ;   if (fib_n > 0) return fib_n;
    jz .noLookup

.retByLookup:
    mov esi, eax

    mov ebx, eax
    mov ecx, buf
    call itoa
    CALL_WRITE buf, eax
    CALL_WRITE LOOKUP, LOOKUP_SIZE

    mov eax, esi

    jmp .done

.noLookup:
    mov esi, ebx            ;   temp_n = n;

    test ebx, ebx           ;   if (n == 0) return 0;
    jz .ret0

    cmp ebx, 2              ;   if (n <= 2) return 1;
    jle .ret1

    dec ebx                 ;   --n;
    call fib                ;   ret = fib(n);
    mov edi, eax            ;   temp_ret = ret;

    mov ebx, esi            ;   n = temp_n;
    sub ebx, 2              ;   n -= 2;
    call fib                ;   ret = fib(n);
    add eax, edi            ;   return ret + temp_ret;

    cmp ebx, FIBS_SIZE
    jge .done
    jmp .save

.ret0:
    xor eax, eax
    jmp .save
.ret1:
    mov eax, 1
.save:
    mov word [fibs + esi * 2], ax
.done:
    pop edi
    pop esi                 ; }
    ret ; fib

itoa:                       ; int itoa(int n, char* dest)
    enter 0, 0
    push edi
    push esi

    mov edi, ebx
    xor esi, esi

.loop:
    mov eax, edi
    mov ebx, 10
    xor edx, edx
    div ebx

    mov edi, eax

    add edx, '0'
    mov byte [buf + esi], dl
    inc esi

    test edi, edi
    jz .done

    jmp .loop

.done:
    mov ebx, buf
    mov ecx, esi
    call revstr

    mov eax, esi
    pop esi
    pop edi
    leave
    ret

revstr:
    xor eax, eax
    dec ecx
.loop:
    cmp eax, ecx
    jge .done

    mov dl, byte [ebx + eax]
    xchg dl, byte [ebx + ecx]
    mov byte [ebx + eax], dl

    inc eax
    dec ecx
    jmp .loop
.done:
    ret
