IDEAL
MODEL small

CODESEG
PROC _main
PUBLIC _main
    push bp
    mov bp, sp

    mov bx, 3      ; unsigned n = 3;
    mov cx, 10     ; unsigned power = 19;
    mov di, 1      ; int result = 1;

loop_start:
    test cx, cx    ; if (not power) goto loop_end;
    jz loop_end

    mov ax, cx
    and ax, 1      ; if (power & 1 == 0) goto loop_tail;
    jz loop_tail

    mov ax, di     ; int temp = result;
    mul bx         ; temp *= n;
    mov di, ax     ; result = temp;
    dec cx         ; --power;

loop_tail:
    mov ax, bx     ; temp = n;
    mul bx         ; temp *= n;
    mov bx, ax     ; n = temp;
    shr cx, 1      ; power /= 2;
    jmp loop_start

loop_end:
    mov sp, bp
    pop bp
    ret
ENDP
END