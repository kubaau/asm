IDEAL
MODEL small

EXTRN _printf: PROC

DATASEG
    PRINTF_FLT_FORMAT: db "%.18f", 10, 0
    PRINTF_DBL_FORMAT: db "%.18f", 10, 0
    PRINTF_LDB_FORMAT: db "%.18Lf", 10, 0
    FLT: dd 0.2
    DBL: dq 0.2
    LDB: dt 0.2

CODESEG
PROC _main
PUBLIC _main
    push bp
    mov bp, sp

    sub sp, 10

    fld [dword FLT]
    fstp [qword bp - 10]
    push [dword bp - 6]
    push [dword bp - 10]
    lea ax, [PRINTF_FLT_FORMAT]
    push ax
    call _printf
    add sp, 10

    fld [qword DBL]
    fstp [qword bp - 10]
    push [dword bp - 6]
    push [dword bp - 10]
    lea ax, [PRINTF_DBL_FORMAT]
    push ax
    call _printf
    add sp, 10

    fld [tbyte LDB]
    fstp [tbyte bp - 10]
    push [dword bp - 2]
    push [dword bp - 6]
    push [dword bp - 10]
    lea ax, [PRINTF_LDB_FORMAT]
    push ax
    call _printf
    add sp, 14

    xor ax, ax
    mov sp, bp
    pop bp
    ret
ENDP
END