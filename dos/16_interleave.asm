IDEAL
MODEL small

EXTRN _printf: PROC

DATASEG
    PRINTF_FORMAT: db '%c', 0
    ENDL: db 13, 10, 0

    ARG0 db '.exe', 0
    ARG1 db 'elephant', 0
    ARG2 db 'hyena', 0
    ARG3 db 'partridge', 0

CODESEG
PROC _main
ARG argc, argv
PUBLIC _main
    push bp
    mov bp, sp

    mov ax, ss
    mov ds, ax

    push offset ARG3
    push offset ARG2
    push offset ARG1
    push offset ARG0
    push sp
    push 4
    call mainer
    mov sp, bp
    pop bp
    ret
ENDP

mainer:
    push bp                        ;{
    mov bp, sp
    push di
    push si
    push bx

    mov di, [bp + 4]               ;    int r12 = argc;
    mov si, [bp + 6]               ;    char** r13 = argv;

    cmp di, 1                      ;    if (argc == 1)
    je done                        ;       goto done;

    sub sp, 4                      ;    int char_index, arg_index;

    mov [word bp - 4], 0           ;    char_index = 0;
charLoop:
    mov [word bp - 2], 1           ;    arg_index = 1;
argLoop:
    xor ax, ax
    mov ax, [bp - 2]               ;    eax = arg_index
    cmp ax, di                     ;    if (arg_index == argc)
    je nextCharIter                ;       goto nextCharIter;

    shl ax, 1
    mov bx, ax
    mov ax, [si + bx]              ;    char* arg = argv[arg_index];

    mov bx, [bp - 4]
    mov cx, si
    mov si, ax
    mov al, [si + bx]              ;    char c = arg[char_index];
    mov si, cx

    test al, al                    ;    if (!c)
    jz done                        ;        goto done;
    push ax
    lea ax, [PRINTF_FORMAT]
    push ax
    call _printf                   ;    printf("%c", c);
    add sp, 4
nextArgIter:
    inc [word bp - 2]              ;    ++arg_index;
    jmp argLoop                    ;    goto argLoop;
nextCharIter:
    lea ax, [ENDL]
    push ax
    call _printf                   ;    printf("\n");
    add sp, 2
    inc [word bp - 4]              ;    ++char_index;
    jmp charLoop                   ;    goto charLoop;
done:
    pop bx
    pop si
    pop di
    xor ax, ax
    mov sp, bp
    pop bp
    ret ; main                     ;}
END