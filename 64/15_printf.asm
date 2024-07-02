global main

extern printf
extern atoi

section .rodata
    PRINTF_FORMAT: db '%d + %d = %d', 10, 0
    USAGE_MSG: db 'Usage: %s {first_number} {second_number}', 10, 0

section .text
main:
    enter 8, 0
    push rbx
    push r12
    push r13

    mov r12, rdi ; argc
    mov r13, rsi ; argv
	
    cmp r12, 3
    jne .fail

    mov rdi, qword [r13 + 8] ; argv[1]
    call atoi
    mov dword [rsp], eax

    mov rdi, qword [r13 + 16] ; argv[2]
    call atoi
    mov dword [rsp + 4], eax

    mov ecx, dword [rsp]
    add ecx, dword [rsp + 4]

    mov rdi, PRINTF_FORMAT
    mov esi, [rsp] ; the argument is 4 bytes, so we use esi instead of rsi
    mov edx, [rsp + 4]
    ; the sum of the two numbers is already in ecx

    call printf

    xor rax, rax
    jmp .end
	
.fail:
    mov rdi, USAGE_MSG
    mov rsi, [r13] ; argv[0]
    call printf
    mov rax, 1
	
.end:
    pop r13
    pop r12
    pop rbx
    leave
    ret
