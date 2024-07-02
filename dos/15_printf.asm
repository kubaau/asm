IDEAL
MODEL small

EXTRN _printf: PROC
EXTRN _atoi: PROC

DATASEG
    PRINTF_FORMAT db '%d + %d = %d', 0
    USAGE_MSG db 'Usage: %s {first_number} {second_number}', 0

    ARG0 db '.exe', 0
    ARG1 db '-7', 0
    ARG2 db '11', 0

CODESEG
PROC _main
ARG argc, argv
PUBLIC _main
    push bp
    mov bp, sp

    mov ax, ss
    mov ds, ax

    push offset ARG2
    push offset ARG1
    push offset ARG0
    push sp
    push 3
    call mainer
    mov sp, bp
    pop bp
    ret
ENDP

mainer:
    push bp
    mov bp, sp
    push di
    push si

    mov di, [bp + 4] ; argc
    mov si, [bp + 6] ; argv

    cmp di, 3
    jne fail

    sub sp, 4

    push [si + 2]
    call _atoi
    add sp, 2
    mov [bp - 4], ax

    push [si + 4]
    call _atoi
    add sp, 2
    mov [bp - 2], ax

    add ax, [bp - 4]

    push ax
    push [bp - 2]
    push [bp - 4]
    push offset PRINTF_FORMAT
    call _printf
    add sp, 8

    xor ax, ax
    jmp end_main

fail:
    push [si]
    push offset USAGE_MSG
    call _printf
    add sp, 4
    mov ax, 1

end_main:
    pop si
    pop di
    mov sp, bp
    pop bp
    ret
END