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
mov rdi, %1
call fib
mov rdi, rax
mov rsi, buf
call itoa
CALL_WRITE buf, rax
CALL_WRITE ENDL, 1
%endmacro

_start:
    ; /usr/include/asm/unistd_64.h
    ; "The kernel interface uses %rdi, %rsi, %rdx, %r10, %r8 and %r9."
    ; callee-saved: rbx, rbp, rsp, r12-r15

    lea rdi, [fibs]
    xor rax, rax
    mov rcx, FIBS_SIZE
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
    push rbx                ; {
    push r12

    cmp rdi, FIBS_SIZE
    jge .noLookup
    xor ax, ax
    mov ax, [fibs + rdi * 2];   fib_n = fibs[n];
    test ax, ax             ;   if (fib_n > 0) return fib_n;
    jz .noLookup

.retByLookup:
    mov rbx, rax

    mov rdi, rax
    mov rsi, buf
    call itoa
    CALL_WRITE buf, rax
    CALL_WRITE LOOKUP, LOOKUP_SIZE

    mov rax, rbx

    jmp .done

.noLookup:
    mov rbx, rdi            ;   temp_n = n;

    test rdi, rdi           ;   if (n == 0) return 0;
    jz .ret0

    cmp rdi, 2              ;   if (n <= 2) return 1;
    jle .ret1

    dec rdi                 ;   --n;
    call fib                ;   ret = fib(n);
    mov r12, rax            ;   temp_ret = ret;

    mov rdi, rbx            ;   n = temp_n;
    sub rdi, 2              ;   n -= 2;
    call fib                ;   ret = fib(n);
    add rax, r12            ;   return ret + temp_ret;

    cmp rbx, FIBS_SIZE
    jge .done
    jmp .save

.ret0:
    xor rax, rax
    jmp .save
.ret1:
    mov rax, 1
.save:
    mov word [fibs + rbx * 2], ax
.done:
    pop r12
    pop rbx                 ; }
    ret ; fib

itoa:                       ; int itoa(int n, char* dest)
    enter 0, 0
    push rbx

    xor rcx, rcx
.loop:
    mov rax, rdi
    mov rbx, 10
    xor rdx, rdx
    div rbx

    mov rdi, rax

    add rdx, '0'
    mov byte [buf + rcx], dl
    inc rcx

    test rdi, rdi
    jz .done

    jmp .loop

.done:
    mov rbx, rcx

    mov rdi, buf
    mov rsi, rcx
    call revstr

    mov rax, rbx
    pop rbx
    leave
    ret

revstr:
    xor rax, rax
    dec rsi
.loop:
    cmp rax, rsi
    jge .done

    mov dl, byte [rdi + rax]
    xchg dl, byte [rdi + rsi]
    mov byte [rdi + rax], dl

    inc rax
    dec rsi
    jmp .loop
.done:
    ret
