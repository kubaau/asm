;	- Write a program that reads a sequence of integers from standard input
;	and sorts it using the qsort() function.

global main

extern malloc
extern printf
extern qsort
extern scanf

section .data
    fmt_in: db "%d", 0
    fmt_out: db "%d ", 0

section .text

main:                               ;int main(int argc, char** argv)
    push rbp                        ;{
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15

    and rsp, -16
    sub rsp, 16                     ;    int n, i, *ints;

    mov rdi, fmt_in
    lea rsi, [rsp + 4]
    call scanf                      ;    scanf("%d", &n);

    mov rax, 4                      ;    size_t size = sizeof(int);
    mov rcx, [rsp + 4]
    mul rcx                         ;    size *= n;

    mov rdi, rax
    call malloc
    mov [rsp + 16], rax             ;    int* ints = malloc(size);

    mov dword [rsp + 8], 0          ;    int i = 0;
.scanLoop:
    mov eax, [rsp + 8]
    cmp eax, [rsp + 4]              ;    if (i == n)
    je .scanLoopDone                ;        goto scanLoopDone;

    mov rdi, fmt_in
    mov rcx, [rsp + 8]
    lea rsi, [rsp + 16 + 4 * rcx]   ;    int* current_int_ptr = ints + i;
    call scanf                      ;    scanf("%d", current_int_ptr);

    inc dword [rsp + 8]             ;    ++i;
    jmp .scanLoop                   ;    goto scanLoop;

.scanLoopDone:
    lea rdi, [rsp + 16]
    mov esi, [rsp + 4]
    mov rdx, 4
    mov rcx, compareInt
    call qsort                      ;    qsort(ints, n, sizeof(int), compareInt);

    mov dword [rsp + 8], 0          ;    i = 0;
.printLoop:
    mov eax, [rsp + 8]
    cmp eax, [rsp + 4]              ;    if (i == n)
    je .printLoopDone               ;        goto printLoopDone;

    mov rdi, fmt_out
    mov rcx, [rsp + 8]
    mov rsi, [rsp + 16 + 4 * rcx]   ;    int current_int = ints[i];
    call printf                     ;    printf("%d ", current_int);

    inc dword [rsp + 8]             ;    ++i;
    jmp .printLoop                  ;    goto printLoop;

.printLoopDone:

.done:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    xor rax, rax
    ret ; main                      ;}

compareInt:                         ;int compareInt(const void* lhs, const void* rhs)
                                    ;{
    mov edx, [rdi]                  ;    int lhsi = *(int*)(lhs);
    cmp edx, [rsi]                  ;    int rhsi = *(int*)(rhs);
    jl .retl                        ;    if (lhsi < rhsi) return -1;
    jg .retg                        ;    if (lhsi > rhsi) return 1;
    xor rax, rax                    ;    return 0;
    ret
.retl:
    mov rax, -1
    ret
.retg:
    mov rax, 1
    ret ; compareInt                ;}
