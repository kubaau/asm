IDEAL
MODEL small

PUTS equ 9
WRITE equ 40h

STDOUT equ 1

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

DATASEG
ATOI_ERROR db "Invalid atoi input$"

CODESEG
PROC _factorial
PUBLIC _factorial
    push bp
    mov bp, sp
    push si
    
    mov bx, [bp + 4]

    mov si, bx

    test bx, bx
    je zero_factorial

    dec bx
    push bx
    call _factorial
    add sp, 2

    mul si
    jmp short done_factorial

zero_factorial:
    mov ax, 1

done_factorial:
    pop si

    mov sp, bp
    pop bp
    ret
ENDP

PROC _atoi2                 ; unsigned atoi(const char* str, int size);
PUBLIC _atoi2
    push bp
    mov bp, sp
    mov bx, [bp + 4]
    mov cx, [bp + 6]
                            ; {
    xor ax, ax              ;   unsigned ret = 0;
    xor si, si              ;   int i = 0;
loop_atoi:
    cmp si, cx              ;   if (i >= size) goto .done
    jge done_atoi

    mov dx, 10
    mul dx                  ;   ret *= 10;

    xor dx, dx
    mov dl, [bx + si]       ;   unsigned n = str[i];
    sub dl, '0'             ;   n -= '0';
    cmp dx, 9               ;   if (n > 9) goto .error;
    jg error_atoi

    add ax, dx              ;   ret += n;
    inc si                  ;   ++i;
    jmp loop_atoi          ;   goto .loop;
error_atoi:
    CALL_PUTS @data, [ATOI_ERROR]
    mov ax, -1
done_atoi:
                            ; }
    mov sp, bp
    pop bp
    ret                     ;   return ret;
ENDP

PROC _itoa2                 ; int itoa(int n, char* dest)
PUBLIC _itoa2
    push bp
    mov bp, sp
    push di
    push si

    mov bx, [bp + 4]
    mov cx, [bp + 6]

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
ENDP

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