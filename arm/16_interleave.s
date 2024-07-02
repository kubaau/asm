.global main

.extern printf

.data
    PRINTF_FORMAT: .asciz "%c"
    ENDL: .asciz "\n"

.text
main:
    push {r4, r5, r11, lr}      @     push ebp                        ;{
    mov r11, sp                 @     mov ebp, esp
@     push edi
@     push esi

    mov r4, r0                  @     mov edi, [esp + 16]             ;    int r12 = argc;
    mov r5, r1                  @     mov esi, [esp + 20]             ;    char** r13 = argv;

    teq r4, #1                  @     cmp edi, 1                      ;    if (argc == 1)
    beq .done                   @     je .done                        ;       goto done;

    sub sp, #8                  @     sub esp, 8                      ;    int char_index, arg_index;

    eor r0, r0
    str r0, [sp]                @     mov dword [esp], 0              ;    char_index = 0;
.charLoop:
    mov r0, #1
    str r0, [sp, #4]            @     mov dword [esp + 4], 1          ;    arg_index = 1;
.argLoop:
    eor r0, r0                  @     xor eax, eax
    ldr r0, [sp, #4]            @     mov eax, dword [esp + 4]        ;    eax = arg_index
    teq r0, r4                  @     cmp eax, edi                    ;    if (arg_index == argc)
    beq .nextCharIter           @     je .nextCharIter                ;       goto nextCharIter;

    lsl r0, #2
    ldr r0, [r5, r0]            @     mov eax, dword [esi + 4 * eax]  ;    char* arg = argv[arg_index];

    ldr r2, [sp]                @     mov ecx, dword [esp]
    eor r1, r1
    ldrb r1, [r0, r2]           @     mov al, byte [eax + ecx]        ;    char c = arg[char_index];

    tst r1, r1                  @     test al, al                     ;    if (!c)
    beq .done                   @     jz .done                        ;        goto done;
                                @     push eax
    ldr r0, =PRINTF_FORMAT      @     push PRINTF_FORMAT
    bl printf                   @     call printf                     ;    printf("%c", c);
                                @     add esp, 8
.nextArgIter:
    ldr r0, [sp, #4]
    add r0, #1
    str r0, [sp, #4]            @     inc dword [esp + 4]             ;    ++arg_index;
    b .argLoop                  @     jmp .argLoop                    ;    goto argLoop;
.nextCharIter:
    ldr r0, =ENDL               @     push ENDL
    bl printf                   @     call printf                     ;    printf("\n");
                                @     add esp, 4
    ldr r0, [sp]
    add r0, #1
    str r0, [sp]                @     inc dword [esp]                 ;    ++char_index;
    b .charLoop                 @     jmp .charLoop                   ;    goto charLoop;
.done:
    mov sp, r11
    pop {r4, r5, r11, pc}       @     pop esi
                                @     pop edi
    eor r0, r0                  @     xor eax, eax
                                @     leave
    bx lr                       @     ret ; main                      ;}
