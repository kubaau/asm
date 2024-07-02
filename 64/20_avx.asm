global main

extern printf

section .rodata
    PRINTF_FLOAT4: db '%f, %f, %f, %f', 10, 0
	
    align 32
    DOUBLE4_1: dq 4.7, -6.8, 3.1, 6.7
    DOUBLE4_2: dq 8.4, 9.2, 4.9, -1.6

section .text
main:	
    push rbp
    mov rbp, rsp
		
    call avx
	
    xor rax, rax

    mov rsp, rbp
    pop rbp
    ret
	
avx:	
    push rbp
    mov rbp, rsp
		
    and rsp, -32	
    sub rsp, 32
		
    vmovapd ymm0, [DOUBLE4_1]
    vaddpd ymm0, ymm0, [DOUBLE4_2]
	
    vmovapd [rsp], ymm0	
    vmovsd xmm0, qword [rsp]
    vmovsd xmm1, qword [rsp + 8]
    vmovsd xmm2, qword [rsp + 16]
    vmovsd xmm3, qword [rsp + 24]
	
    mov rdi, PRINTF_FLOAT4
    call printf
	
    vmovapd ymm0, [DOUBLE4_1]
    vmovapd ymm1, [DOUBLE4_1]
	
    vfmadd231pd ymm0, ymm1, [DOUBLE4_2]

    vmovapd [rsp], ymm0
    movsd xmm0, qword [rsp]
    movsd xmm1, qword [rsp + 8]
    movsd xmm2, qword [rsp + 16]
    movsd xmm3, qword [rsp + 24]
    mov rdi, PRINTF_FLOAT4
    call printf

    mov rsp, rbp
    pop rbp
    ret
