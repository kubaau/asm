global main

extern printf

section .rodata
    PRINTF_FLOAT4: db '%f, %f, %f, %f', 10, 0

    align 32
    DOUBLE4_1: dq 4.7, -6.8, 3.1, 6.7
    DOUBLE4_2: dq 8.4, 9.2, 4.9, -1.6

section .text
main:
    push ebp
    mov ebp, esp

    call avx

    xor eax, eax

    mov esp, ebp
    pop ebp
    ret

avx:
    push ebp
    mov ebp, esp

    and esp, -32
    sub esp, 32

    vmovapd ymm0, [DOUBLE4_1]
    vaddpd ymm0, ymm0, [DOUBLE4_2]

    vmovapd [esp], ymm0
    push PRINTF_FLOAT4
    call printf
    add esp, 4

    vmovapd ymm0, [DOUBLE4_1]
    vmovapd ymm1, [DOUBLE4_1]

    vfmadd231pd ymm0, ymm1, [DOUBLE4_2]

    vmovapd [esp], ymm0
    push PRINTF_FLOAT4
    call printf
    add esp, 4

    mov esp, ebp
    pop ebp
    ret
