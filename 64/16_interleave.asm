global main

extern printf

section .data
    PRINTF_FORMAT: db '%c', 0
    ENDL: db 10, 0

section .text

main:                               ;int main(int argc, char** argv)
    enter 0, 0                      ;{
    push rbx
    push r12
    push r13

    mov r12, rdi                    ;    int r12 = argc;
    mov r13, rsi                    ;    char** r13 = argv;

    cmp rdi, 1                      ;    if (argc == 1)
    je .done                        ;       goto done;

    sub rsp, 8                      ;    int char_index, arg_index;

    mov dword [rsp], 0              ;    char_index = 0;
.charLoop:
    mov dword [rsp + 4], 1          ;    arg_index = 1;
.argLoop:
    xor rax, rax
    mov eax, dword [rsp + 4]        ;    eax = arg_index
    cmp rax, r12                    ;    if (arg_index == argc)
    je .nextCharIter                ;       goto nextCharIter;

    mov rax, qword [r13 + 8 * rax]  ;    char* arg = argv[arg_index];

    xor rcx, rcx
    mov ecx, dword [rsp]
    xor rsi, rsi
    mov sil, byte [rax + rcx]       ;    char c = arg[char_index];

    test sil, sil                   ;    if (!c)
    jz .done                        ;        goto done;
    mov rdi, PRINTF_FORMAT
    call printf                     ;    printf("%c", c);
.nextArgIter:
    inc dword [rsp + 4]             ;    ++arg_index;
    jmp .argLoop                    ;    goto argLoop;
.nextCharIter:
    mov rdi, ENDL
    call printf                     ;    printf("\n");
    inc dword [rsp]                 ;    ++char_index;
    jmp .charLoop                   ;    goto charLoop;
.done:
    pop r13
    pop r12
    pop rbx
    xor rax, rax
    leave
    ret ; main                      ;}
