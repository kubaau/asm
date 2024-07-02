;	- Write a program that reads a string, then calls a function that
;	replaces all its characters with '+' if the string's size is even,
;	but calls a different function that replaces them with '-' if the
;	size is odd. However, the program must contain *a single* CALL
;	instruction, and you're not allowed to use jumps instead of CALL,
;	or call the functions with any instruction that isn't CALL.
;	You'll probably need to read the instruction set's entry for CALL here.
;	(Hint: use two CALLs first, worry about the constraint later.)

global _start

section .bss
    BUF_SIZE: equ 32
    buf: resb BUF_SIZE

section .text
_start:

.read:
    xor rax, rax        ; __NR_read == 0
    xor rdi, rdi        ; stdin == 0
    mov rsi, buf
    mov rdx, BUF_SIZE
    syscall

    dec rax             ; ignore newline

    mov rdi, buf
    mov rsi, rax

    and rax, 1
    mov rbx, plusize
    mov rcx, 0 ; mask = 00000000
    mov rdx, minusize - plusize

    sub rcx, rax ; mask = 11111111 if size is odd
    and rdx, rcx ; offset &= mask;
    add rbx, rdx
.even:
    call rbx

;    jz .call_plusize
;    jmp .call_minusize
;.call_plusize:
;    call plusize
;    jmp .write
;.call_minusize:
;    call minusize

.write:
    mov rax, 1
    mov rdi, 1
    mov rdx, rsi
    mov rsi, buf
    syscall

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall

plusize:                ; void plusize(char* str, size_t size)
    xor rcx, rcx
.loop:
    cmp rcx, rsi
    je .done
    mov byte [buf + rcx], '+'
    inc rcx
    jmp .loop
.done:
    ret ; plusize

minusize:
    xor rcx, rcx
.loop:
    cmp rcx, rsi
    je .done
    mov byte [buf + rcx], '-'
    inc rcx
    jmp .loop
.done:
    ret ; minusize
