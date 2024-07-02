%macro syscall 0
    int 0x80
%endmacro

%macro CALL_WRITE 2
    mov ecx, %1
    mov edx, %2
    mov eax, WRITE
    mov ebx, STDOUT
    syscall
%endmacro

global factorial
global itoa2
global atoi2

section .rodata
    ATOI_ERROR: db 'Invalid atoi input', 10
    ATOI_ERROR_SIZE: equ $ - ATOI_ERROR

    WRITE: equ 4

    STDOUT: equ 1

section .text
factorial:
    push ebp
    mov ebp, esp
    push edi

    mov edi, dword [esp + 12]
    test edi, edi
    je .zero

    push edi
    dec dword [esp]
    call factorial
    add esp, 4

    mul edi
    jmp .done

.zero:
    mov eax, 1

.done:
    pop edi
    mov esp, ebp
    pop ebp
    ret

atoi2:                      ; unsigned atoi(const char* str, int size);
                            ; {
    xor eax, eax            ;   unsigned ret = 0;
    xor esi, esi            ;   int i = 0;
    mov ecx, [esp + 4]
.loop:
    cmp esi, dword [esp + 8] ;   if (i >= size) goto .done
    jge .done

    mov edx, 10
    mul edx                 ;   ret *= 10;

    xor edx, edx
    mov dl, [ecx + esi]     ;   unsigned n = str[i];
    sub dl, '0'             ;   n -= '0';
    cmp dx, 9               ;   if (n > 9) goto .error;
    jg .error

    add eax, edx            ;   ret += n;
    inc esi                 ;   ++i;
    jmp .loop               ;   goto .loop;
.error:
    CALL_WRITE ATOI_ERROR, ATOI_ERROR_SIZE
    mov eax, -1
.done:
                            ; }
    ret                     ;   return ret;

itoa2:                      ; int itoa(int n, char* dest)
    enter 0, 0
    mov edx, dword [esp + 8]
    mov ecx, dword [esp + 12]

    push edi
    push esi
    push ebx

    mov edi, edx
    xor esi, esi

.loop:
    test edi, edi
    jz .done

    mov eax, edi
    mov ebx, 10
    xor edx, edx
    div ebx

    mov edi, eax

    add edx, '0'
    mov byte [ecx + esi], dl
    inc esi

    jmp .loop

.done:
    mov ebx, ecx
    mov ecx, esi
    call revstr

    mov eax, esi
    pop ebx
    pop esi
    pop edi
    leave
    ret

revstr:
    xor eax, eax
    dec ecx
.loop:
    cmp eax, ecx
    jge .done

    mov dl, byte [ebx + eax]
    xchg dl, byte [ebx + ecx]
    mov byte [ebx + eax], dl

    inc eax
    dec ecx
    jmp .loop
.done:
    ret
