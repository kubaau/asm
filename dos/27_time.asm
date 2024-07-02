IDEAL
MODEL small

EXTRN _printf: PROC

DATASEG
    PRINTF_FORMAT db '%u.%02us / %lu clock counts / %u timer ticks', 0
    ticks dw 0
    int8_original_es dw ?
    int8_original_bx dw ?

CODESEG
PROC _main
PUBLIC _main
    push bp
    mov bp, sp

    mov ax, 3508h
    int 21h

    mov [int8_original_es], es
    mov [int8_original_bx], bx

    mov al, 36h
    out 43h, al
    xor al, al
    out 40h, al
    ;inc al
    out 40h, al

    push ds
    mov ax, cs
    mov ds, ax
    lea dx, [int8]
    mov ax, 2508h
    int 21h
    pop ds

    push 27
    push 2
    lea ax, [fib]
    push ax
    call time
    add sp, 6

    push ds
    mov ax, 2508h
    mov dx, [int8_original_bx]
    mov ds, [int8_original_es]
    int 21h
    pop ds

    mov al, 36h
    out 43h, al
    xor ax, ax
    out 40h, ax

    mov sp, bp
    pop bp
    ret
ENDP

int8:
    push bp
    mov bp, sp

    inc [ticks]

    push [word int8_original_es]
    push [word int8_original_bx]
    call [dword bp - 4]

    mov sp, bp
    pop bp
    iret

time:
; [bp + 4] - function
; [bp + 6] - sizeof(args)
; [bp + 8, ...] - args
    push bp
    mov bp, sp    
    push bx
    push di

    TIME_STACK_SIZE equ 18
    sub sp, TIME_STACK_SIZE

    ; push function's args
    mov cx, [bp + 6]
    sub sp, cx
    mov bx, sp
    xor di, di
push_arg:
    cmp di, cx
    je args_pushed
    mov al, [bp + 8 + di]
    mov [ss:bx + di], al
    inc di
    jmp push_arg
args_pushed:
    ; GET CURRENT TIME
    mov ah, 2Ch
    int 21h
    mov [bp - 6], cx
    mov [bp - 8], dx

    ; GET TIME OF DAY
    xor ah, ah
    int 1Ah
    mov [bp - 14], cx
    mov [bp - 16], dx

    ; ticks before
    mov di, [ticks]
    mov [bp - 22], ax

    call [word bp + 4]

    ; diff ticks
    mov di, [ticks]
    sub di, [bp - 22]
    push di

    ; GET CURRENT TIME
    mov ah, 2Ch
    int 21h
    mov [bp - 10], cx
    mov [bp - 12], dx

    ; GET TIME OF DAY
    xor ah, ah
    int 1Ah
    mov [bp - 18], cx
    mov [bp - 20], dx

    ; diff time of day
    mov ax, [bp - 18]
    mov bx, [bp - 20]
    sub bx, [bp - 16]
    sbb ax, [bp - 14]
    push ax
    push bx

    xor bx, bx
    mov cx, 100

    ; convert current time to the count of hundredths of a second
    xor ax, ax
    mov al, [bp - 11]
    mul cx
    mov bl, [bp - 12]
    add ax, bx

    mov di, ax

    ; convert previous time to the count of hundredths of a second
    xor ax, ax
    mov al, [bp - 7]
    mul cx
    mov bl, [bp - 8]
    add ax, bx

    ; if we've looped around a minute, fix the count
    ;mov di, 0100
    ;mov ax, 5998
    sub di, ax
    jns not_negative
negative:
    add di, 6000

not_negative:
    ; store seconds in ax, hundreths in dx
    xor dx, dx
    mov ax, di
    div cx
    push dx
    push ax

    push offset PRINTF_FORMAT
    call _printf
    add sp, [bp + 6]
    add sp, TIME_STACK_SIZE
    add sp, 12
    
    pop di
    pop bx
    mov sp, bp
    pop bp
    ret
    
fib:                        ; unsigned fib(unsigned n)
    push bp
    mov bp, sp
    push si                 ; {
    push di

    mov bx, [bp + 4]

noLookup:
    mov si, bx             ;   temp_n = n;

    test bx, bx            ;   if (n == 0) return 0;
    jz ret0

    cmp bx, 2              ;   if (n <= 2) return 1;
    jle ret1

    dec bx                 ;   --n;
    push bx
    call fib               ;   ret = fib(n);
    add sp, 2
    mov di, ax             ;   temp_ret = ret;

    mov bx, si             ;   n = temp_n;
    sub bx, 2              ;   n -= 2;
    push bx
    call fib               ;   ret = fib(n);
    add sp, 2
    add ax, di             ;   return ret + temp_ret;

    jmp done_fib

ret0:
    xor ax, ax
ret1:
    mov ax, 1
done_fib:
    pop di
    pop si                 ; }
    mov sp, bp
    pop bp
    ret ; fib
END