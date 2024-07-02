global main

extern printf
extern scanf

section .rodata
    SCANF_FORMAT: db "%lf %lf %lf %lf", 0
    PRINTF_FORMAT: db "%f", 10, 0

%macro SCANF_VECTOR 1
lea eax, %1
push eax
add eax, 8
push eax
add eax, 8
push eax
add eax, 8
push eax
push SCANF_FORMAT
call scanf
add esp, 20
%endmacro

section .text
main:
    push ebp
    mov ebp, esp

    and esp, -32
    sub esp, 64

    SCANF_VECTOR [esp]
    SCANF_VECTOR [esp + 32]

    vmovapd ymm0, [esp]
    vmulpd ymm0, [esp + 32]
    vmovapd [esp], ymm0

    movsd xmm0, qword [esp]
    addsd xmm0, qword [esp + 8]
    addsd xmm0, qword [esp + 16]
    addsd xmm0, qword [esp + 24]

    movdqa [esp], xmm0
    push PRINTF_FORMAT
    call printf
    add esp, 4

    xor eax, eax
    leave
    ret
