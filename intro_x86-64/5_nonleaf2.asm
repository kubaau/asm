; === Your turn ===
;	- We've shown a function that converts an unsigned int to string.
;	Write a function that does the opposite: given a string that represents
;	a number and the string size, return the corresponding number.
;	If the function recieves a string that does not represent an unsigned
;	integer, it should print an error message.
;	A string that starts with a number but then derails, like "123abc",
;	may or may not be seen as invalid input: that's up to you.
;
;	- Write a program that reads a string from stdin, turns it into a number
;	with your function, multiplies it by two, turns the result into a string
;	with uint2str, and finally prints that string.
;
;	- Write a recursive function that recieves an unsigned integer N
;	and returns the N-th number in the Fibonacci sequence.
;	Again, bonus points if you use dynamic programming.
;
;	- Write a program to test your Fibonacci function, by calling it with
;	several numbers and printing the return values (again using uint2str).

global _start

section .data
    ATOI_ERROR: db 'Invalid atoi input',0xA
    ATOI_ERROR_SIZE: equ $ - ATOI_ERROR

    STR1: db '3','1','3','3','7'
    STR1_SIZE: equ $ - STR1

    STR2: db '3','1','x','3','7'
    STR2_SIZE: equ $ - STR2

    LOOKUP: db ' lookup successful',0xA
    LOOKUP_SIZE: equ $ - LOOKUP

section .bss
    BUF_SIZE: equ 32
    buf: resb BUF_SIZE

    FIBS_SIZE: equ 24
    fibs: resw FIBS_SIZE

%macro printFib 1
mov rdi, %1
call fib
mov rdi, rax
mov rsi, buf
mov rdx, BUF_SIZE
call uint2str
mov rdx, rax
mov rax, 1
mov rdi, 1
mov rsi, buf
syscall
%endmacro

section .text
_start:
    xor rcx, rcx
.fibsZeroLoop:
    cmp rcx, FIBS_SIZE
    je .fibsZeroed
    mov word [fibs + rcx * 2], 0
    inc rcx
    jmp .fibsZeroLoop

.fibsZeroed:
    printFib 0
    printFib 1
    printFib 2
    printFib 3
    printFib 4
    printFib 5
    printFib 6
    printFib 7
    printFib 8
    printFib 9
    printFib 10
    printFib 11
    printFib 12
    printFib 13
    printFib 24

    xor rax, rax            ; __NR_read == 0
    xor rdi, rdi            ; stdin == 0
    mov rsi, buf
    mov rdx, BUF_SIZE
    syscall

    mov rdi, buf
    dec rax
    mov rsi, rax
    call atoi

    cmp rax, -1
    je .exit

    mov rdi, rax
    shl rdi, 1
    mov rsi, buf
    mov rdx, BUF_SIZE
    call uint2str

    mov rdx, rax
    mov rax, 1              ; __NR_write
    mov rdi, 1              ; stdout
    mov rsi, buf
    syscall

    ;mov rdi, STR1
    ;mov rsi, STR1_SIZE
    ;call atoi

    ;mov rdi, STR2
    ;mov rsi, STR2_SIZE
    ;call atoi

    ;mov rdi, STR2
    ;mov rsi, 0
    ;call atoi

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall

atoi:                       ; unsigned atoi(const char* str, int size);
    ;push rbx               ; {
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
    mov rax, 1              ; __NR_write
    mov rdi, 1              ; stdout
    mov rsi, ATOI_ERROR
    mov rdx, ATOI_ERROR_SIZE
    syscall                 ;   printf("Invalid atoi input\n");
    mov rax, -1
.done:
    ;pop rbx                ; }
    ret ; atoi              ;   return ret;

uint2str:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15

    mov r12, rdi ; n
    mov r13, rsi ; buf
    mov r14, rdx ; bufsize

    xor r15, r15 ; i = 0 (counter)
    mov rax, r12 ; rax = n

    mov rdi, 10
.loop:
    cmp r15, r14
    jge .done	; if(i >= bufsize) break;

    xor rdx, rdx
    div rdi

    add dl, '0'
    mov byte [r13 + r15], dl ; write that value to the string

    inc r15     ; i++

    cmp rax, 0
    je .done	; if(n == 0) break;

    jmp .loop

.done:
    mov byte [r13 + r15], 0x0a
    inc r15

    mov rdi, r13 ; buf
    lea rsi, [r15 - 1] ; number of chars written -1 (don't include the newline)
    call revstr

    mov rax, r15 ; return value: the counter

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx

    mov rsp, rbp
    pop rbp
    ret

revstr:
    xor r8, r8
    lea r9, [rsi - 1]

.loop:
    cmp r8, r9
    jge .done

    ; swap s[r8] and s[r9]
    mov cl, byte [rdi + r8]
    xchg cl, byte [rdi + r9]
    mov byte [rdi + r8], cl

    inc r8
    dec r9
    jmp .loop
.done:
    ret

fib:                        ; unsigned fib(unsigned n)
    push r12                ; {
    push r13
    push r14

    cmp rdi, FIBS_SIZE
    jge .noLookup
    xor ax, ax
    mov ax, [fibs + rdi * 2];   fib_n = fibs[n];
    test ax, ax               ;   if (fib_n > 0) return fib_n;
    jz .noLookup

.retByLookup:
    mov r14, rax

    mov rsi, buf
    mov rdx, BUF_SIZE
    call uint2str
    mov rdx, rax
    dec rdx
    mov rax, 1
    mov rdi, 1
    mov rsi, buf
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, LOOKUP
    mov rdx, LOOKUP_SIZE
    syscall

    mov rax, r14

    jmp .done

.noLookup:
    mov r12, rdi            ;   temp_n = n;

    test rdi, rdi           ;   if (n == 0) return 0;
    jz .ret0

    cmp rdi, 2              ;   if (n <= 2) return 1;
    jle .ret1

    dec rdi                 ;   --n;
    call fib                ;   ret = fib(n);
    mov r13, rax            ;   temp_ret = ret;

    mov rdi, r12            ;   n = temp_n;
    sub rdi, 2              ;   n -= 2;
    call fib                ;   ret = fib(n);
    add rax, r13            ;   return ret + temp_ret;

    jmp .save

.ret0:
    xor rax, rax
    jmp .save
.ret1:
    mov rax, 1
.save:
    mov word [fibs + r12 * 2], ax
.done:
    pop r14
    pop r13
    pop r12                 ; }
    ret ; fib
