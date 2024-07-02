global main

extern printf

section .rodata
    PRINTF_LONG_DOUBLE: db '%.18Lf', 10, 0

    LONG_DOUBLE_1: dt 2.222222222222222222
    LONG_DOUBLE_2: dt 7.777777777777777777

section .text
main:
    push ebp
    mov ebp, esp

    call x87

    xor eax, eax

    mov esp, ebp
    pop ebp
    ret
x87:
    push ebp
    mov ebp, esp

    sub esp, 20

    fld tword [LONG_DOUBLE_1]
    fst st1
    fld tword [LONG_DOUBLE_2]
    fadd st1

    fstp tword [esp]

    mov eax, esp
    push dword [eax + 8]
    push dword [eax + 4]
    push dword [eax]
    push PRINTF_LONG_DOUBLE
    call printf
    add esp, 16

    fldpi
    fcos

    fstp tword [esp]

    mov eax, esp
    push dword [eax + 8]
    push dword [eax + 4]
    push dword [eax]
    push PRINTF_LONG_DOUBLE
    call printf
    add esp, 16

    mov esp, ebp
    pop ebp
    ret
