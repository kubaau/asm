INCLUDE 00common.asm
STACK BUF_SIZE

CODESEG
    sub sp, BUF_SIZE

    CALL_READ BUF_SIZE, ss, sp

    mov bp, ax
    sub ax, 2

    mov bx, sp
    mov cx, ax

    and ax, 1
    lea dx, [plusize]
    xor di, di ; mask = 00000000
    sub di, ax ; mask = 11111111 if size is odd
    mov si, minusize - plusize
    and si, di ; offset &= mask;
    add dx, si
    call dx

    CALL_WRITE bp, ss, sp

    CALL_EXIT

plusize:
    xor di, di
loop_plusize:
    cmp di, cx
    je done_plusize
    mov [byte bx + di], '+'
    inc di
    jmp loop_plusize
done_plusize:
    ret

minusize:
    xor di, di
loop_minusize:
    cmp di, cx
    je done_minusize
    mov [byte bx + di], '-'
    inc di
    jmp loop_minusize
done_minusize:
    ret
END