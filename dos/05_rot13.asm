INCLUDE 00common.asm
STACK BUF_SIZE

CODESEG
    sub sp, BUF_SIZE

    CALL_READ BUF_SIZE, ss, sp

    mov si, ax

    xor cx, cx              ; int i = 0;
    sub si, 2               ; int len = strlen(buf);

    mov ax, ss
    mov dx, ax
    mov bp, sp

begin:
    cmp cx, si              ; if (i == len) goto break;
    je done
    
                            ; char* cp = buf + i;
    xor ax, ax
    mov al, [bp]            ; char c = *cp;
    or al, 32               ; c = tolower(c);

    cmp al, 'a'             ; if (c < 'a') goto next_iteration;
    jl next_iteration
    cmp al, 'z'             ; if (c > 'z') goto next_iteration;
    jg next_iteration

    add al, 13              ; c += 13;
    cmp ax, 'z'             ; if (c <= 'z') goto next_iteration;
    jle next_iteration
    sub al, 26              ; c -= 26;

next_iteration:
    mov ah, [bp]            ; char mask = *cp;
    and ah, 32              ; mask &= 32; // islower
    or ah, 255 - 32         ; mask |= (255 - 32);
    and al, ah              ; c &= mask;

    mov [bp], al            ; *cp = c;
    inc cx                  ; ++i;
    inc bp
    jmp begin               ; goto begin;

done:
    add si, 2
    CALL_WRITE si, ss, sp

    CALL_EXIT
END