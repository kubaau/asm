IDEAL
MODEL tiny

PUTS equ 9
READ equ 3Fh
WRITE equ 40h
EXIT equ 4Ch

STDOUT equ 1

BUF_SIZE equ 64

MACRO CALL_EXIT
    xor al, al
	mov	ah, EXIT
	int	21h
ENDM

MACRO CALL_READ cxr, dsr, dxr
    xor bx, bx
    mov cx, cxr
    mov ax, dsr
    mov ds, ax
    mov dx, dxr
    mov ah, READ
    int 21h
ENDM

MACRO CALL_WRITE cxr, dsr, dxr
    mov bx, STDOUT
    mov cx, cxr
    mov ax, dsr
    mov ds, ax
    mov dx, dxr
    mov ah, WRITE
    int 21h
ENDM

MACRO CALL_PUTS dsr, dxr
    mov ax, dsr
    mov ds, ax
    lea dx, dxr
    mov ah, PUTS
    int 21h
ENDM