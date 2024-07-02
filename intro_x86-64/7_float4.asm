; - Write an avx512 function that does the same operations as avx, but using
; AVX-512 and the ZMM registers, then write a program to test it.

global main

extern printf

section .rodata
    printf_dbl_vec4_fmt: db '%f, %f, %f, %f',0xA,0x00

    ; these two need to be in a 32-byte alignment
    align 32
    dbl_vec4_1: dq 4.7, -6.8, 3.1, 6.7
    dbl_vec4_2: dq 8.4, 9.2, 4.9, -1.6

section .text
main:
    enter 0, 0

    call avx512

    xor rax, rax
    leave
    ret

avx512:
    enter 32, 0

    and rsp, -64

    vpxord zmm0, zmm0

    vmovapd zmm0, [dbl_vec4_1]
    vaddpd zmm0, zmm0, [dbl_vec4_2]

    vmovapd [rsp], zmm0

    vmovsd xmm0, qword [rsp]
    vmovsd xmm1, qword [rsp + 8]
    vmovsd xmm2, qword [rsp + 16]
    vmovsd xmm3, qword [rsp + 24]

    mov rdi, printf_dbl_vec4_fmt
    call printf

    vmovapd zmm0, [dbl_vec4_1]
    vpxord zmm1, zmm1
    vmovapd zmm1, [dbl_vec4_1]

    vfmadd231pd zmm0, zmm1, [dbl_vec4_2]

    vmovapd [rsp], zmm0
    movsd xmm0, qword [rsp]
    movsd xmm1, qword [rsp+8]
    movsd xmm2, qword [rsp+16]
    movsd xmm3, qword [rsp+24]
    mov rdi, printf_dbl_vec4_fmt
    call printf

    leave
    ret
