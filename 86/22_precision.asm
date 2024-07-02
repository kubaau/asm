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
    push ebp
    mov ebp, esp

    and esp, -16
    sub esp, 16

    pxor xmm0, xmm0

    movss xmm0, dword [FLT]
    cvtss2sd xmm0, xmm0
    movdqa [esp], xmm0
    push PRINTF_FLT_FORMAT
    call printf
    add esp, 4

    movsd xmm0, qword [DBL]
    movdqa [esp], xmm0
    push PRINTF_DBL_FORMAT
    call printf
    add esp, 4

    fld tword [LDB]
    fstp tword [esp]
    mov eax, esp
    push dword [eax + 8]
    push dword [eax + 4]
    push dword [eax]
    push PRINTF_LDB_FORMAT
    call printf
    add esp, 16

    xor eax, eax
    leave
    ret
