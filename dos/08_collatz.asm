INCLUDE 00common.asm
STACK 0

CODESEG
    mov bx, 17
    call countCollatz

    call countCollatz

    mov bx, 2
    lea ax, [after_ret]
    push ax
    lea ax, [countCollatz]
    push ax
    call countCollatz
    ret
after_ret:
    CALL_EXIT

countCollatz:
    xor cx, cx             ; int i = 0;

loop_start:
    cmp bx, 1              ; if (n <= 1) goto .done;
    jle done

    inc cx                 ; ++i;

    mov ax, bx             ; int temp = n;
    and ax, 1              ; temp &= 1;
    cmp ax, 1              ; if (temp == 1) goto .odd;
    je odd

_even:
    shr bx, 1              ; n /= 2;
    jmp loop_start         ; goto .loop;

odd:
    mov ax, 3
    mul bx
    inc ax
    mov bx, ax             ; n = n * 3 + 1;
    jmp loop_start         ; goto .loop;

done:
    mov ax, cx             ; int ret = i;
    ret ;countCollatz      ; return ret;
END