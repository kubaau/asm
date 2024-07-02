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
    push ebp                        ;{
    mov ebp, esp
    push edi                        ;    int i;
    push esi                        ;    int* current_int_ptr;

    and esp, -16
    sub esp, 16                     ;    int n, *ints;

    push esp
    push SCANF_FORMAT
    call scanf                      ;    scanf("%d", &n);
    add esp, 8

    mov eax, 4                      ;    size_t size = sizeof(int);
    mov ecx, [esp]
    mul ecx                         ;    size *= n;

    push eax
    call malloc
    add esp, 4
    mov [esp + 4], eax              ;    ints = malloc(size);

    xor edi, edi                    ;    i = 0;
    mov esi, [esp + 4]              ;    current_int_ptr = ints;
.scanLoop:
    cmp edi, [esp]                  ;    if (i == n)
    je .scanLoopDone                ;        goto scanLoopDone;

    push esi
    push SCANF_FORMAT
    call scanf                      ;    scanf("%d", current_int_ptr);
    add esp, 8

    add esi, 4                      ;    ++current_int_ptr;
    inc edi                         ;    ++i;
    jmp .scanLoop                   ;    goto scanLoop;

.scanLoopDone:
    mov eax, esp
    push compareInt
    push dword 4
    push dword [eax]
    push dword [eax + 4]
    call qsort                      ;    qsort(ints, n, sizeof(int), compareInt);
    add esp, 16

    xor edi, edi                    ;    i = 0;
    mov esi, [esp + 4]              ;    current_int_ptr = ints;
.printLoop:
    cmp edi, [esp]                  ;    if (i == n)
    je .printLoopDone               ;        goto printLoopDone;

    mov eax, [esi]                  ;    int current_int = *current_int_ptr;
    push eax
    push PRINTF_FORMAT
    call printf                     ;    printf("%d ", current_int);
    add esp, 8

    add esi, 4                      ;    ++current_int_ptr;
    inc edi                         ;    ++i;
    jmp .printLoop                  ;    goto printLoop;

.printLoopDone:
    push dword [esp + 4]
    call free                       ;    free(ints);
    add esp, 4

.done:
    xor eax, eax
    pop esi
    pop edi
    leave
    ret ; main                      ;}

compareInt:                         ;int compareInt(const void* lhs, const void* rhs)
                                    ;{               
    mov edx, [esp + 4]              ;    int lhsi = *(int*)(lhs);
    mov edx, [edx]
    mov ecx, [esp + 8]              ;    int rhsi = *(int*)(rhs);
    cmp edx, [ecx]
    jl .retl                        ;    if (lhsi < rhsi) return -1;
    jg .retg                        ;    if (lhsi > rhsi) return 1;
    xor eax, eax                    ;    return 0;
    ret
.retl:
    mov eax, -1
    ret
.retg:
    mov eax, 1
    ret ; compareInt                ;}
