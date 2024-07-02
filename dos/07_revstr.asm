INCLUDE 00common.asm
STACK BUF_SIZE

CODESEG
    sub sp, BUF_SIZE

    CALL_READ BUF_SIZE, ss, sp

    mov di, ax

    mov bx, sp
    lea cx, [di - 2]
    call revstr

    CALL_WRITE di, ss, sp

    CALL_EXIT

revstr:
    push di
    xor di, di
    mov si, cx
    dec si
loop_start:
    cmp di, si
    jge done
    
    mov dl, [bx + di]
    xchg dl, [bx + si]
    mov [bx + di], dl

    inc di
    dec si
    jmp loop_start
done:
    pop di
    ret
END