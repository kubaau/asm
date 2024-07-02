IDEAL
MODEL small

EXTRN _free: PROC
EXTRN _malloc: PROC
EXTRN _printf: PROC
EXTRN _qsort: PROC
EXTRN _scanf: PROC

DATASEG
    SCANF_FORMAT: db "%d", 0
    PRINTF_FORMAT: db "%d ", 0

CODESEG
PROC _main
PUBLIC _main
    push bp                        ;{
    mov bp, sp
    push di                        ;    int i;
    push si                        ;    int* current_int_ptr;

    sub sp, 4                      ;    int n, *ints;

    push sp
    lea ax, [SCANF_FORMAT]
    push ax
    call _scanf                    ;    scanf("%d", &n);
    add sp, 4

    mov ax, 2                      ;    size_t size = sizeof(int);
    mov cx, [bp - 8]
    mul cx                         ;    size *= n;

    push ax
    call _malloc
    add sp, 2
    mov [bp - 6], ax               ;    ints = malloc(size);

    xor di, di                     ;    i = 0;
    mov si, [bp - 6]               ;    current_int_ptr = ints;
scanLoop:
    cmp di, [bp - 8]               ;    if (i == n)
    je scanLoopDone                ;        goto scanLoopDone;

    push si
    lea ax, [SCANF_FORMAT]
    push ax
    call _scanf                    ;    scanf("%d", current_int_ptr);
    add sp, 4

    add si, 2                      ;    ++current_int_ptr;
    inc di                         ;    ++i;
    jmp scanLoop                   ;    goto scanLoop;

scanLoopDone:
    mov bx, sp
    lea ax, [compareInt]
    push ax
    push 2
    push [bx]
    push [bx + 2]
    call _qsort                    ;    qsort(ints, n, sizeof(int), compareInt);
    add sp, 8

    xor di, di                     ;    i = 0;
    mov si, [bp - 6]               ;    current_int_ptr = ints;
printLoop:
    cmp di, [bp - 8]               ;    if (i == n)
    je printLoopDone               ;        goto printLoopDone;

    mov ax, [si]                   ;    int current_int = *current_int_ptr;
    push ax
    lea ax, [PRINTF_FORMAT]
    push ax
    call _printf                   ;    printf("%d ", current_int);
    add sp, 4

    add si, 2                      ;    ++current_int_ptr;
    inc di                         ;    ++i;
    jmp printLoop                  ;    goto printLoop;

printLoopDone:
    push [bp - 6]
    call _free                     ;    free(ints);
    add sp, 2

done:
    xor ax, ax
    pop si
    pop di
    mov sp, bp
    pop bp
    ret ; main                     ;}
ENDP

compareInt:                        ;int compareInt(const void* lhs, const void* rhs)
                                   ;{               
    push bp
    mov bp, sp
    push bx
    mov bx, [bp + 4]               ;    int lhsi = *(int*)(lhs);
    mov dx, [bx]
    mov bx, [bp + 6]               ;    int rhsi = *(int*)(rhs);
    cmp dx, [bx]
    jl retl                        ;    if (lhsi < rhsi) return -1;
    jg retg                        ;    if (lhsi > rhsi) return 1;
    xor ax, ax                     ;    return 0;
    jmp retany
retl:
    mov ax, -1
    jmp retany
retg:
    mov ax, 1
retany:
    pop bx
    mov sp, bp
    pop bp
    ret ; compareInt               ;}
END