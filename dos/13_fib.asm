INCLUDE 00common.asm
FIBS_SIZE equ 24
STACK_SIZE equ BUF_SIZE + FIBS_SIZE * 2
STACK STACK_SIZE

DATASEG
LOOKUP db " lookup successful", 13, 10, "$"
ENDL db 13, 10, "$"

CODESEG

MACRO PRINT_FIB n
mov ax, ss
mov ds, ax
mov bx, n
mov cx, sp
lea dx, [bp - BUF_SIZE]
call fib
mov bx, ax
lea cx, [bp - BUF_SIZE]
call itoa
lea dx, [bp - BUF_SIZE]
CALL_WRITE ax, ss, dx
CALL_PUTS @data, [ENDL]
ENDM

    mov bp, sp
    sub sp, STACK_SIZE

    mov ax, ss
    mov es, ax
    mov di, sp
    xor ax, ax
    mov cx, FIBS_SIZE
    rep stosw

fibsZeroed:
    PRINT_FIB 0
    PRINT_FIB 1
    PRINT_FIB 2
    PRINT_FIB 3
    PRINT_FIB 4
    PRINT_FIB 5
    PRINT_FIB 6
    PRINT_FIB 7
    PRINT_FIB 8
    PRINT_FIB 9
    PRINT_FIB 10
    PRINT_FIB 11
    PRINT_FIB 12
    PRINT_FIB 13
    PRINT_FIB 23
    PRINT_FIB 24
    PRINT_FIB 25

    CALL_EXIT

fib:                        ; unsigned fib(unsigned n)
    push bp
    mov bp, sp
    push si                 ; {
    push di
    push cx

    cmp bx, FIBS_SIZE
    jge noLookup
    mov si, bx
    shl si, 1
    xchg bx, cx
    mov ax, [bx + si]       ;   fib_n = fibs[n];
    xchg bx, cx
    test ax, ax             ;   if (fib_n > 0) return fib_n;
    jz noLookup

retByLookup:
    mov si, ax

    mov bx, ax
    mov cx, dx
    push dx
    call itoa
    pop dx
    CALL_WRITE ax, ss, dx
    push ds
    push dx
    CALL_PUTS @data, [LOOKUP]
    pop dx
    pop ds

    mov ax, si

    jmp done_fib

noLookup:
    mov si, bx             ;   temp_n = n;

    test bx, bx            ;   if (n == 0) return 0;
    jz ret0

    cmp bx, 2              ;   if (n <= 2) return 1;
    jle ret1

    dec bx                 ;   --n;
    call fib               ;   ret = fib(n);
    mov di, ax             ;   temp_ret = ret;

    mov bx, si             ;   n = temp_n;
    sub bx, 2              ;   n -= 2;
    call fib               ;   ret = fib(n);
    add ax, di             ;   return ret + temp_ret;

    cmp bx, FIBS_SIZE
    jge done_fib
    jmp save

ret0:
    xor ax, ax
    jmp save
ret1:
    mov ax, 1
save:
    shl si, 1
    xchg bx, cx
    mov [bx + si], ax
    xchg bx, cx
done_fib:
    pop cx
    pop di
    pop si                 ; }
    mov sp, bp
    pop bp
    ret ; fib

itoa:                       ; int itoa(int n, char* dest)
    push bp
    mov bp, sp
    push bx
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
    pop bx
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