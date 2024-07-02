%macro CALL_WRITE 2
    mov rsi, %1
    mov rdx, %2
    mov rax, WRITE
    mov rdi, STDOUT
    syscall
%endmacro

global factorial
global itoa2
global atoi2

section .rodata
    ATOI_ERROR: db 'Invalid atoi input', 10
    ATOI_ERROR_SIZE: equ $ - ATOI_ERROR

    WRITE: equ 1

    STDOUT: equ 1

section .text
factorial:
    push rbp
    mov rbp, rsp

    push rbx

    mov rbx, rdi

    cmp rdi, 0
    je .zero

    dec rdi
    call factorial

    mul rbx
    jmp .done

.zero:
    mov rax, 1

.done:
    pop rbx

    mov rsp, rbp
    pop rbp
    ret

atoi2:                      ; unsigned atoi(const char* str, int size);
                            ; {
    xor rax, rax            ;   unsigned ret = 0;
    xor rcx, rcx            ;   int i = 0;
.loop:
    cmp rcx, rsi            ;   if (i >= size) goto .done
    jge .done

    mov rdx, 10
    mul rdx                 ;   ret *= 10;

    xor rdx, rdx
    mov dl, [rdi + rcx]     ;   unsigned n = str[i];
    sub dl, '0'             ;   n -= '0';
    cmp dx, 9               ;   if (n > 9) goto .error;
    jg .error

    add rax, rdx            ;   ret += n;
    inc rcx                 ;   ++i;
    jmp .loop               ;   goto .loop;
.error:
    CALL_WRITE ATOI_ERROR, ATOI_ERROR_SIZE
    mov rax, -1
.done:
                            ; }
    ret                     ;   return ret;

itoa2:                      ; int itoa(int n, char* dest)
    enter 0, 0
    push rbx

    xor rcx, rcx
.loop:
    test rdi, rdi
    jz .done

    mov rax, rdi
    mov rbx, 10
    xor rdx, rdx
    div rbx

    mov rdi, rax

    add rdx, '0'
    mov byte [rsi + rcx], dl
    inc rcx

    jmp .loop

.done:
    mov rbx, rcx

    mov rdi, rsi
    mov rsi, rcx
    call revstr

    mov rax, rbx
    pop rbx
    leave
    ret

revstr:
    xor rax, rax
    dec rsi
.loop:
    cmp rax, rsi
    jge .done

    mov dl, byte [rdi + rax]
    xchg dl, byte [rdi + rsi]
    mov byte [rdi + rax], dl

    inc rax
    dec rsi
    jmp .loop
.done:
    ret
