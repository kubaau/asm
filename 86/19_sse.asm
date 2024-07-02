global main

extern printf
extern scanf

section .rodata
    PROMPT_FLOAT: db 'type a float (x, result will be x + 1): ', 0
    PROMPT_DOUBLE: db 'type a double (x, result will be x - 1): ', 0

    SCANF_FLOAT: db '%f', 0
    SCANF_DOUBLE: db '%lf', 0

    PRINTF_FLOAT_DOUBLE: db 'result = %f', 10, 0
    PRINTF_FLOAT2: db '%f, %f', 10, 0
    PRINTF_FLOAT4: db '%f, %f, %f, %f', 10, 0

    align 16
    FLOAT_1: dd 1.0
    DOUBLE_1: dq 1.0

    align 16
    FLOAT4_1: dd 2.0, -1.0, 3.5, 4.2
    FLOAT4_2: dd 1.2, 3.4, -1.2, 7.8

    DOUBLE2_1: dq 2.0, -1.0
    DOUBLE2_2: dq 1.2, 3.2

section .text
main:
    push ebp
    mov ebp, esp

    call sse

    xor eax, eax

    mov esp, ebp
    pop ebp
    ret

sse:
    push ebp
    mov ebp, esp

    and esp, -16
    sub esp, 32

    ; add float
    push PROMPT_FLOAT
    call printf
    add esp, 4

    lea eax, [esp]
    push eax
    push SCANF_FLOAT
    call scanf
    add esp, 8

    pxor xmm0, xmm0
    movss xmm0, dword [esp]
    addss xmm0, [FLOAT_1]

    cvtss2sd xmm0, xmm0

    movdqa [esp], xmm0
    push PRINTF_FLOAT_DOUBLE
    call printf
    add esp, 4

    ; sub double
    push PROMPT_DOUBLE
    call printf
    add esp, 4

    lea eax, [esp]
    push eax
    push SCANF_DOUBLE
    call scanf
    add esp, 8

    movsd xmm0, qword [esp]
    subsd xmm0, [DOUBLE_1]

    movdqa [esp], xmm0
    push PRINTF_FLOAT_DOUBLE
    call printf
    add esp, 4

    ; mul vec float4
    movaps xmm0, [FLOAT4_1]
    mulps xmm0, [FLOAT4_2]

    movaps [esp], xmm0
    movss xmm0, dword [esp]
    movss xmm1, dword [esp + 4]
    movss xmm2, dword [esp + 8]
    movss xmm3, dword [esp + 12]

    cvtss2sd xmm0, xmm0
    cvtss2sd xmm1, xmm1
    cvtss2sd xmm2, xmm2
    cvtss2sd xmm3, xmm3

    movsd [esp], xmm0
    movsd [esp + 8], xmm1
    movsd [esp + 16], xmm2
    movsd [esp + 24], xmm3
    push PRINTF_FLOAT4
    call printf
    add esp, 4

    ; div vec double2
    movapd xmm0, [DOUBLE2_1]
    divpd xmm0, [DOUBLE2_2]

    movapd [esp], xmm0

    push PRINTF_FLOAT2
    call printf
    add esp, 4

    mov esp, ebp
    pop ebp
    ret
