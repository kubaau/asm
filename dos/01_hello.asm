IDEAL
MODEL tiny
BUF_SIZE equ 64
STACK BUF_SIZE

PUTS equ 9h
READ equ 3Fh
WRITE equ 40h
EXIT equ 4Ch

STDOUT equ 1

DATASEG
prompt: db "What is your name?", 10, "$"
hello: db "Hello, $"

CODESEG
    sub sp, BUF_SIZE
    mov bp, sp

    mov ax, @data
	mov ds, ax
	mov dx, offset prompt
	mov ah, PUTS
    int 21h

    mov cx, BUF_SIZE
    mov ax, ss
    mov ds, ax
    mov dx, sp
    mov ah, READ
    xor bx, bx
    int 21h
    sub ax, 2
    mov cx, ax

    mov ax, @data
	mov ds, ax
	lea dx, [hello]
	mov ah, PUTS
    int 21h

    mov ax, ss
    mov ds, ax
    mov dx, sp
    mov ah, WRITE
    mov bx, STDOUT
    int 21h

    xor al, al
	mov	ah, EXIT
	int	21h
END