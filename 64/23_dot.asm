global main

extern printf
extern scanf

section .rodata
    SCANF_FORMAT: db "%lf %lf %lf %lf", 0
    PRINTF_FORMAT: db "%f", 10, 0

%macro SCANF_VECTOR 1
mov rdi, SCANF_FORMAT
lea rbx, %1
mov rsi, rbx
add rbx, 8
mov rdx, rbx
add rbx, 8
mov rcx, rbx
add rbx, 8
mov r8, rbx
call scanf
%endmacro

section .text
main:
    enter 64, 0
    push rbx

    and rsp, -32

    SCANF_VECTOR [rsp]
    SCANF_VECTOR [rsp + 32]

    vmovapd ymm0, [rsp]
    vmulpd ymm0, [rsp + 32]
    vmovapd [rsp], ymm0

    movsd xmm0, qword [rsp]
    addsd xmm0, qword [rsp + 8]
    addsd xmm0, qword [rsp + 16]
    addsd xmm0, qword [rsp + 24]

    mov rdi, PRINTF_FORMAT
    call printf

    xor rax, rax
    pop rbx
    leave
    ret
