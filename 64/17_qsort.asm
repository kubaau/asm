global main

extern free
extern malloc
extern printf
extern qsort
extern scanf

section .rodata
    SCANF_FORMAT: db "%d", 0
    PRINTF_FORMAT: db "%d ", 0

section .text

main:                               ;int main(int argc, char** argv)
    push rbp                        ;{
    mov rbp, rsp
    push rbx                        ;    int i;
    push r12                        ;    int* ints;
    push r13                        ;    int* current_int_ptr;

    and rsp, -16
    sub rsp, 16                     ;    int n;

    mov rdi, SCANF_FORMAT
    mov rsi, rsp
    call scanf                      ;    scanf("%d", &n);

    mov rax, 4                      ;    size_t size = sizeof(int);
    mov rcx, [rsp]
    mul ecx                         ;    size *= n;

    mov rdi, rax
    call malloc
    mov r12, rax                    ;    ints = malloc(size);

    xor ebx, ebx                    ;    i = 0;
    mov r13, r12                    ;    current_int_ptr = ints;
.scanLoop:
    cmp ebx, [rsp]                  ;    if (i == n)
    je .scanLoopDone                ;        goto scanLoopDone;

    mov rdi, SCANF_FORMAT
    mov rsi, r13
    call scanf                      ;    scanf("%d", current_int_ptr);

    add r13, 4                      ;    ++current_int_ptr;
    inc ebx                         ;    ++i;
    jmp .scanLoop                   ;    goto scanLoop;

.scanLoopDone:
    mov rdi, r12
    mov esi, [rsp]
    mov rdx, 4
    mov rcx, compareInt
    call qsort                      ;    qsort(ints, n, sizeof(int), compareInt);

    xor ebx, ebx                    ;    i = 0;
    mov r13, r12                    ;    current_int_ptr = ints;
.printLoop:
    cmp ebx, [rsp]                  ;    if (i == n)
    je .printLoopDone               ;        goto printLoopDone;

    mov rdi, PRINTF_FORMAT
    mov rsi, [r13]                  ;    int current_int = *current_int_ptr;
    call printf                     ;    printf("%d ", current_int);

    add r13, 4                      ;    ++current_int_ptr;
    inc ebx                         ;    ++i;
    jmp .printLoop                  ;    goto printLoop;

.printLoopDone:
    mov rdi, r12
    call free                       ;    free(ints);

.done:
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
