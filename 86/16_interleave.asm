global main

extern printf

section .data
    PRINTF_FORMAT: db '%c', 0
    ENDL: db 10, 0

section .text

main:                               ;int main(int argc, char** argv)
    push ebp                        ;{
    mov ebp, esp
    push edi
    push esi

    mov edi, [esp + 16]             ;    int r12 = argc;
    mov esi, [esp + 20]             ;    char** r13 = argv;

    cmp edi, 1                      ;    if (argc == 1)
    je .done                        ;       goto done;

    sub esp, 8                      ;    int char_index, arg_index;

    mov dword [esp], 0              ;    char_index = 0;
.charLoop:
    mov dword [esp + 4], 1          ;    arg_index = 1;
.argLoop:
    xor eax, eax
    mov eax, dword [esp + 4]        ;    eax = arg_index
    cmp eax, edi                    ;    if (arg_index == argc)
    je .nextCharIter                ;       goto nextCharIter;

    mov eax, dword [esi + 4 * eax]  ;    char* arg = argv[arg_index];

    mov ecx, dword [esp]
    mov al, byte [eax + ecx]        ;    char c = arg[char_index];

    test al, al                     ;    if (!c)
    jz .done                        ;        goto done;
    push eax
    push PRINTF_FORMAT
    call printf                     ;    printf("%c", c);
    add esp, 8
.nextArgIter:
    inc dword [esp + 4]             ;    ++arg_index;
    jmp .argLoop                    ;    goto argLoop;
.nextCharIter:
    push ENDL
    call printf                     ;    printf("\n");
    add esp, 4
    inc dword [esp]                 ;    ++char_index;
    jmp .charLoop                   ;    goto charLoop;
.done:
    pop esi
    pop edi
    xor eax, eax
    leave
    ret ; main                      ;}
