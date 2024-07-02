IDEAL
MODEL small

EXTRN _printf: PROC

DATASEG
    PRINTF_LONG_DOUBLE: db '%.18Lf', 10, 0

    LONG_DOUBLE_1: dt 2.222222222222222222
    LONG_DOUBLE_2: dt 7.777777777777777777

CODESEG
PROC _main
PUBLIC _main
    push bp
    mov bp, sp

    call x87

    xor ax, ax

    mov sp, bp
    pop bp
    ret
ENDP

x87:
    push bp
    mov bp, sp

    sub sp, 20

    fld [tbyte LONG_DOUBLE_1]
    fst st(1)
    fld [tbyte LONG_DOUBLE_2]
    fadd st(0), st(1)

    fstp [tbyte bp - 20]

    mov ax, ss
    mov ds, ax
    mov bx, sp
    push [dword bx + 8]
    push [dword bx + 4]
    push [dword bx]
    lea ax, [PRINTF_LONG_DOUBLE]
    push ax
    call _printf
    add sp, 14

    fldpi
    fsqrt

    fstp [tbyte bp - 20]

    mov bx, sp
    push [dword bx + 8]
    push [dword bx + 4]
    push [dword bx]
    lea ax, [PRINTF_LONG_DOUBLE]
    push ax
    call _printf
    add sp, 14

    mov sp, bp
    pop bp
    ret
END