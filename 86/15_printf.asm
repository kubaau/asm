global main

extern printf
extern atoi

section .rodata
    PRINTF_FORMAT: db '%d + %d = %d', 10, 0
    USAGE_MSG: db 'Usage: %s {first_number} {second_number}', 10, 0

section .text
main:
    push ebp
    mov ebp, esp
    push edi
    push esi

    mov edi, [esp + 16] ; argc
    mov esi, [esp + 20] ; argv

    cmp edi, 3
    jne .fail

    sub esp, 8

    push dword [esi + 4]
    call atoi
    add esp, 4
    mov dword [esp], eax

    push dword [esi + 8]
    call atoi
    add esp, 4
    mov dword [esp + 4], eax

    add eax, dword [esp]

    mov edi, esp
    push eax
    push dword [edi + 4]
    push dword [edi]
    push dword PRINTF_FORMAT
    call printf
    add esp, 12

    xor eax, eax
    jmp .end

.fail:
    push dword [esi]
    push dword USAGE_MSG
    call printf
    add esp, 8
    mov eax, 1

.end:
    pop esi
    pop edi
    leave
    ret
