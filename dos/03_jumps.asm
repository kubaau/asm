INCLUDE 00common.asm
STACK BUF_SIZE

DATASEG
less_str db "size < 16", 10, "$"

more_str db "size >= 16", 10, "$"

CODESEG
    sub sp, BUF_SIZE

    jmp after_unused

    int 21h
    
after_unused:  
    xor bx, bx
    mov cx, BUF_SIZE
    mov ax, ss
    mov ds, ax
    mov dx, sp
    mov ah, READ
    int 21h    
    sub ax, 2

    mov bx, ax

    mov ax, @data
    mov ds, ax

    cmp bx, 16
    jl less

    lea dx, [more_str]
    mov ah, PUTS
    int 21h

    jmp after_less

less:
    lea dx, [less_str]
    mov ah, PUTS
    int 21h

after_less:
    xor cx, cx
loop_begin:
    cmp cx, bx
    je loop_done

    mov bp, sp
    add bp, cx
    inc [byte bp]
    inc cx
    jmp loop_begin

loop_done:
    mov cx, bx
    mov bx, STDOUT
    mov ax, ss
    mov ds, ax
    mov dx, sp
    mov ah, WRITE
    int 21h

    xor al, al
	mov	ah, EXIT
	int	21h
END