; - Write a program that prints the number 0.2 as a float, double, and
; long double, using the same number of decimal places for all of them so you
; can compare the rounding errors.

global main

extern printf

section .rodata
    PRINTF_FLT_FORMAT: db "%.18f", 10, 0
    PRINTF_DBL_FORMAT: db "%.18f", 10, 0
    PRINTF_LDB_FORMAT: db "%.18Lf", 10, 0
    FLT: dd 0.2
    DBL: dq 0.2
    LDB: dt 0.2

section .text
main:
    enter 10, 0

    and rsp, -16

    pxor xmm0, xmm0

    movss xmm0, dword [FLT]
    cvtss2sd xmm0, xmm0
    mov rdi, PRINTF_FLT_FORMAT
    call printf

    movsd xmm0, qword [DBL]
    mov rdi, PRINTF_DBL_FORMAT
    call printf

    fld tword [LDB]
    fstp tword [rsp]
    mov rdi, PRINTF_LDB_FORMAT
    mov rsi, rsp
    call printf

    xor rax, rax
    leave
    ret
