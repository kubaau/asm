global main

extern printf

section .rodata	
    PRINTF_LONG_DOUBLE: db '%.18Lf', 10, 0
	
    LONG_DOUBLE_1: dt 2.222222222222222222
    LONG_DOUBLE_2: dt 7.777777777777777777

section .text
main:	
    push rbp
    mov rbp, rsp
		
    call x87
	
    xor rax, rax

    mov rsp, rbp
    pop rbp
    ret
x87:
    push rbp
    mov rbp, rsp
	
    and rsp, -16
    sub rsp, 16
		
    fld tword [LONG_DOUBLE_1]
    fst st1
    fld tword [LONG_DOUBLE_2]	
    fadd st1
	
    fstp tword [rsp]
	
    mov rdi, PRINTF_LONG_DOUBLE
    mov rsi, rsp
    call printf

    fldpi
    fcos

    fstp tword [rsp]

    mov rdi, PRINTF_LONG_DOUBLE
    mov rsi, rsp
    call printf

    mov rsp, rbp
    pop rbp
    ret
