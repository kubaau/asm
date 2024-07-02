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
    push rbp
    mov rbp, rsp
		
    call sse
	
    xor rax, rax

    mov rsp, rbp
    pop rbp
    ret
		
sse:	
    push rbp
    mov rbp, rsp
	
    and rsp, -16	
    sub rsp, 16
	
    ; add float
    mov rdi, PROMPT_FLOAT
    call printf
	
    mov rdi, SCANF_FLOAT
    lea rsi, [rsp]
    call scanf
	
    pxor xmm0, xmm0	
    movss xmm0, dword [rsp]
    addss xmm0, [FLOAT_1]
	
    cvtss2sd xmm0, xmm0

    mov rdi, PRINTF_FLOAT_DOUBLE
    call printf
	
    ; sub double
    mov rdi, PROMPT_DOUBLE
    call printf

    mov rdi, SCANF_DOUBLE
    lea rsi, [rsp]
    call scanf

    movsd xmm0, qword [rsp]
    subsd xmm0, [DOUBLE_1]

    mov rdi, PRINTF_FLOAT_DOUBLE
    call printf
	
    ; mul vec float4
    movaps xmm0, [FLOAT4_1]
    mulps xmm0, [FLOAT4_2]
	
    movaps [rsp], xmm0	
    movss xmm0, dword [rsp]
    movss xmm1, dword [rsp + 4]
    movss xmm2, dword [rsp + 8]
    movss xmm3, dword [rsp + 12]
	
    cvtss2sd xmm0, xmm0
    cvtss2sd xmm1, xmm1
    cvtss2sd xmm2, xmm2
    cvtss2sd xmm3, xmm3
	
    mov rdi, PRINTF_FLOAT4
    call printf
	
    ; div vec double2
    movapd xmm0, [DOUBLE2_1]
    divpd xmm0, [DOUBLE2_2]
	
    movapd [rsp], xmm0
    movsd xmm0, qword [rsp]
    movsd xmm1, qword [rsp + 8]
	
    mov rdi, PRINTF_FLOAT2
    call printf

    mov rsp, rbp
    pop rbp
    ret
