.global main

.extern printf
.extern atoi

.section .rodata
    PRINTF_FORMAT: .asciz "%d + %d = %d\n"
    USAGE_MSG: .asciz "Usage: %s {first_number} {second_number}\n"

.text
main:
@     enter 8, 0
    push {r4, r5, r11, lr}  @     push rbx
    mov r11, sp
    sub sp, #8
@     push r12
@     push r13

    mov r4, r0              @     mov r12, rdi ; argc
    mov r5, r1              @     mov r13, rsi ; argv

    teq r4, #3              @     cmp r12, 3    
    bne .fail               @     jne .fail

    ldr r0, [r5, #4]        @     mov rdi, qword [r13 + 8] ; argv[1]
    bl atoi                 @     call atoi
    str r0, [sp]            @     mov dword [rsp], eax

    ldr r0, [r5, #8]        @     mov rdi, qword [r13 + 16] ; argv[2]
    bl atoi                 @     call atoi
    str r0, [sp, #4]        @     mov dword [rsp + 4], eax

    ldr r2, [sp]            @     mov ecx, dword [rsp]
    ldr r3, [sp, #4]
    add r3, r2              @     add ecx, dword [rsp + 4]

    ldr r0, =PRINTF_FORMAT  @     mov rdi, PRINTF_FORMAT
    ldr r1, [sp]            @     mov esi, [rsp] ; the argument is 4 bytes, so we use esi instead of rsi
    ldr r2, [sp, #4]        @     mov edx, [rsp + 4]
                            @     ; the sum of the two numbers is already in ecx

    bl printf               @     call printf

    eor r0, r0              @     xor rax, rax
    b .end                  @     jmp .end
	
.fail:
    ldr r0, =USAGE_MSG      @     mov rdi, USAGE_MSG
    ldr r1, [r5]            @     mov rsi, [r13] ; argv[0]
    bl printf               @     call printf
    mov r0, #1              @     mov rax, 1
	
.end:
    mov sp, r11
    pop {r4, r5, r11, pc}   @     pop r13
@     pop r12
@     pop rbx
@     leave
    bx lr                   @     ret
