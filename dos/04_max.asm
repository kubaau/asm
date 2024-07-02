INCLUDE 00common.asm
STACK_SIZE equ 2
STACK STACK_SIZE

DATASEG
arr dw 3, 1, 3, 3, 7, 2
arr_end:

endl db 10

CODESEG
    sub sp, STACK_SIZE

    mov ax, @data
    mov ds, ax
    lea di, [arr]
    lea si, [arr_end]
    mov bx, [di]
store:
    mov cx, bx
no_store:
    add di, 2
    cmp di, si
    je done

    mov bx, [di]
    cmp bx, cx
    jg store
    jmp no_store

done:
    add cx, '0'
    mov ax, ss
    mov ds, ax
    mov bp, sp
    mov [bp], cx

    mov bx, STDOUT
    mov cx, 1
    mov dx, sp
    mov ah, WRITE
    int 21h

    mov cx, 1
    mov ax, @data
    mov ds, ax
    lea dx, [endl]
    mov ah, WRITE
    int 21h

    xor al, al
	mov	ah, EXIT
	int	21h
END