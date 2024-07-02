IDEAL
MODEL tiny
BUF_SIZE equ 64
STACK BUF_SIZE

PUTS equ 9
READ equ 3Fh
WRITE equ 40h
EXIT equ 4Ch

STDOUT equ 1

DATASEG
string db "0123456789", 10, "$"

CODESEG
    sub sp, BUF_SIZE

    mov ax, @data
    mov ds, ax
    lea dx, [string]
    mov ah, PUTS
    int 21h

    lea si, [string]
    mov [byte si], 'a'
    mov ah, PUTS
    int 21h

    mov [word si + 1], "cb"
    mov ah, PUTS
    int 21h

    mov di, si
    mov ax, 2
    shl ax, 1
    add di, ax
    inc di
    mov [byte di], "x"
    mov ah, PUTS
    int 21h

    mov ax, 2
    shl ax, 1
    add dx, ax
    mov ah, PUTS
    int 21h

    xor bx, bx
    mov cx, BUF_SIZE
    mov ax, ss
    mov ds, ax
    mov dx, sp
    mov ah, READ
    int 21h    
    sub ax, 2

    mov cx, ax 
    dec ax
    shr ax, 1
    mov bp, ax
    add bp, sp
    mov [byte bp], 10
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