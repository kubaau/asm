INCLUDE 00common.asm
STACK 0

CODESEG
    mov bx, 5
    call factorial

    CALL_EXIT

factorial:
    push bp
    mov bp, sp

    push si

    mov si, bx

    test bx, bx
    je zero

    dec bx
    call factorial

    mul si
    jmp done

zero:
    mov ax, 1

done:
    pop si

    mov sp, bp
    pop bp
    ret
END