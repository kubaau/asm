.global main

.extern free
.extern malloc
.extern printf
.extern qsort
.extern scanf

.section .rodata
    SCANF_FORMAT: .asciz "%d"
    PRINTF_FORMAT: .asciz "%d "

.text
main:
    push {r4, r5, r6, r11, lr}  @     push rbp                        ;{
    mov r11, sp                 @     mov rbp, rsp
@     push rbx                        ;    int i;
@     push r12                        ;    int* ints;
@     push r13                        ;    int* current_int_ptr;

    and sp, #-16                @     and rsp, -16
    sub sp, #16                 @     sub rsp, 16                     ;    int n;

    ldr r0, =SCANF_FORMAT       @     mov rdi, SCANF_FORMAT
    mov r1, sp                  @     mov rsi, rsp
    bl scanf                    @     call scanf                      ;    scanf("%d", &n);

    mov r0, #4                  @     mov rax, 4                      ;    size_t size = sizeof(int);
    ldr r2, [sp]                @     mov rcx, [rsp]
    mul r0, r2                  @     mul ecx                         ;    size *= n;

                                @     mov rdi, rax
    bl malloc                   @     call malloc
    mov r5, r0                  @     mov r12, rax                    ;    ints = malloc(size);

    eor r4, r4                  @     xor ebx, ebx                    ;    i = 0;
    mov r6, r5                  @     mov r13, r12                    ;    current_int_ptr = ints;
.scanLoop:
    ldr r0, [sp]
    teq r4, r0                  @     cmp ebx, [rsp]                  ;    if (i == n)
    beq .scanLoopDone           @     je .scanLoopDone                ;        goto scanLoopDone;

    ldr r0, =SCANF_FORMAT       @     mov rdi, SCANF_FORMAT
    mov r1, r6                  @     mov rsi, r13
    bl scanf                    @     call scanf                      ;    scanf("%d", current_int_ptr);

    add r6, #4                  @     add r13, 4                      ;    ++current_int_ptr;
    add r4, #1                  @     inc ebx                         ;    ++i;
    b .scanLoop                 @     jmp .scanLoop                   ;    goto scanLoop;

.scanLoopDone:
    mov r0, r5                  @     mov rdi, r12
    ldr r1, [sp]                @     mov esi, [rsp]
    mov r2, #4                  @     mov rdx, 4
    ldr r3, =compareInt         @     mov rcx, compareInt
    bl qsort                    @     call qsort                      ;    qsort(ints, n, sizeof(int), compareInt);

    eor r4, r4                  @     xor ebx, ebx                    ;    i = 0;
    mov r6, r5                  @     mov r13, r12                    ;    current_int_ptr = ints;
.printLoop:
    ldr r0, [sp]
    teq r4, r0                  @     cmp ebx, [rsp]                  ;    if (i == n)
    beq .printLoopDone          @     je .printLoopDone               ;        goto printLoopDone;

    ldr r0, =PRINTF_FORMAT      @     mov rdi, PRINTF_FORMAT
    ldr r1, [r6]                @     mov rsi, [r13]                  ;    int current_int = *current_int_ptr;
    bl printf                   @     call printf                     ;    printf("%d ", current_int);

    add r6, #4                  @     add r13, 4                      ;    ++current_int_ptr;
    add r4, #1                  @     inc ebx                         ;    ++i;
    b .printLoop                @     jmp .printLoop                  ;    goto printLoop;

.printLoopDone:
    mov r0, r5                  @     mov rdi, r12
    bl free                     @     call free                       ;    free(ints);

.done:
    mov sp, r11
    pop {r4, r5, r6, r11, pc}  @ pop r13
@     pop r12
@     pop rbx
@     mov rsp, rbp
@     pop rbp
    eor r0, r0                  @     xor rax, rax
    bx lr                       @     ret ; main                      ;}

compareInt:
    ldr r0, [r0]                @     mov edx, [rdi]                  ;    int lhsi = *(int*)(lhs);
    ldr r1, [r1]
    cmp r0, r1                  @     cmp edx, [rsi]                  ;    int rhsi = *(int*)(rhs);
    blt .retl                   @     jl .retl                        ;    if (lhsi < rhsi) return -1;
    bgt .retg                   @     jg .retg                        ;    if (lhsi > rhsi) return 1;
    eor r0, r0                  @     xor rax, rax                    ;    return 0;
    bx lr                       @     ret
.retl:
    mov r0, #-1                 @     mov rax, -1
    bx lr                       @     ret
.retg:
    mov r0, #1                  @     mov rax, 1
    bx lr                       @     ret ; compareInt                ;}
