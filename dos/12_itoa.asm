INCLUDE 00common.asm
STACK 0

CODESEG
    mov ax, ss
    mov ds, ax

    mov bx, 31337
    mov cx, sp
    call itoa

    CALL_WRITE ax, ss, sp

    CALL_EXIT

itoa:                       ; int itoa(int n, char* dest)
    push bp
    mov bp, sp
    push di
    push si

    xchg bx, cx

    mov di, cx
    xor si, si

loop_itoa:
    mov ax, di
    mov cx, 10
    xor dx, dx
    div cx

    mov di, ax

    add dx, '0'
    mov [bx + si], dl
    inc si

    test di, di
    jz done_itoa

    jmp loop_itoa

done_itoa:
    mov cx, si
    call revstr

    mov ax, si
    pop si
    pop di
    mov sp, bp
    pop bp
    ret

revstr:
    push di
    push si
    xor di, di
    mov si, cx
    dec si
loop_revstr:
    cmp di, si
    jge done_revstr
    
    mov dl, [bx + di]
    xchg dl, [bx + si]
    mov [bx + di], dl

    inc di
    dec si
    jmp loop_revstr
done_revstr:
    pop si
    pop di
    ret
END