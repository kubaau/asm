INCLUDE 00common.asm
STACK BUF_SIZE

DATASEG
ATOI_ERROR db "Invalid atoi input$"

CODESEG
    sub sp, BUF_SIZE

    CALL_READ BUF_SIZE, ss, sp

    mov di, ax

    mov bx, sp
    lea cx, [di - 2]
    call atoi

    CALL_EXIT

atoi:                       ; unsigned atoi(const char* str, int size);
                            ; {
    xor ax, ax              ;   unsigned ret = 0;
    xor si, si              ;   int i = 0;
loop_start:
    cmp si, cx              ;   if (i >= size) goto .done
    jge done

    mov dx, 10
    mul dx                  ;   ret *= 10;

    xor dx, dx
    mov dl, [bx + si]       ;   unsigned n = str[i];
    sub dl, '0'             ;   n -= '0';
    cmp dx, 9               ;   if (n > 9) goto .error;
    jg error

    add ax, dx              ;   ret += n;
    inc si                  ;   ++i;
    jmp loop_start          ;   goto .loop;
error:
    CALL_PUTS @data, [ATOI_ERROR]
    mov ax, -1
done:
                            ; }
    ret                     ;   return ret;
END