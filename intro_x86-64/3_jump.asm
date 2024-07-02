; Copyright 2018-2019 Mateus Carmo M de F Barbosa
;
; This file is licensed under the CC-BY-SA 2.0 license.
; See LICENSE for details.
;

; (3) jump.asm: conditional and unconditional jumps, eip and eflags.
;
; All code written so far had instructions that were executed sequentially.
; But almost any program needs loops (while, for) and branches (if, else, ...);
; under the hood, those are all jumps.
;
global _start

section .data
    NEW_LINE: equ 0xA
    new_line: db NEW_LINE

    prompt_str: db 'Write something! (max 32 bytes)', NEW_LINE
    PROMPT_STRSIZE: equ $ - prompt_str

    unused_str: db "This string won't be printed",0xA
    UNUSED_STRSIZE: equ $ - unused_str

    less_str: db 'The input string has less than 16 bytes',0xA
    LESS_STRSIZE: equ $ - less_str

    more_str: db 'The input string has 16 bytes or more',0xA
    MORE_STRSIZE: equ $ - more_str

    arr: dd 3, 1, 3, 3, 7, 2
    ARR_END: equ $

section .bss
    buf: resb 32
    BUF_SIZE: equ 32 ; keep the same as above

    max: resd 1

section .text
_start:
    ; write the prompt string
    mov rax, 1 ; __NR_write
    mov rdi, 1 ; stdout
    mov rsi, prompt_str
    mov rdx, PROMPT_STRSIZE
    syscall

    ; jmp: unconditional jump. This instruction makes execution deviate from
    ; its usual path, in such a way that the instruction after my_label
    ; will be executed next. (This is the same as 'goto' in C.)
    ; But how does that work?
    ; From the basic architecture manual, section 3.5:
    ;
    ; "The instruction pointer (EIP) register contains the offset in the
    ; current code segment for the next instruction to be executed.
    ; It is advanced from one instruction boundary to the next
    ; in straight-line code or it is moved ahead or backwards by a number
    ; of instructions [...]"
    ;
    ; So the address of the next instruction is stored in this special
    ; register, eip. The manual goes on:
    ;
    ; "The EIP register cannot be accessed directly by software; it is
    ; controlled implicitly by control-transfer instructions
    ; (such as JMP, Jcc, CALL, and RET), interrupts, and exceptions."
    ;
    ; This means we can't use eip with the mov instruction, i.e.
    ; 'mov eip, <label>' is illegal. However, 'jmp <label>' has the same
    ; effect as that.
    ;
    jmp my_label

    ; because of the previous jump, these instructions won't be executed.
    ; (If they were to be, they would print unused_str.)
    mov rax, 1
    mov rdi, 1
    mov rsi, unused_str
    mov rdx, UNUSED_STRSIZE
    syscall

    ; we need to use labels to know where to jump to.
    ; The labels in the .text section store the address of the instruction
    ; immediately following them.
my_label:
    ; ask the user for input.
    xor rax, rax ; __NR_read == 0
    xor rdi, rdi ; stdin == 0
    mov rsi, buf
    mov rdx, BUF_SIZE
    syscall

    ; The number of bytes that have been read is returned by the
    ; read system call, so it's on rax now. We store this value in rbx,
    ; which won't be altered by the next system calls.
    mov rbx, rax

rot13_start:
    xor rcx, rcx            ; int i = 0;
    dec rbx                 ; int len = strlen(buf);

rot13_begin:
    cmp rcx, rbx            ; if (i >= len) goto break;
    jge rot13_break

    lea rdx, [buf + rcx]    ; char* cp = buf + i;
    mov al, [rdx]           ; char c = *cp;
    or al, 32               ; c = tolower(c);

    cmp al, 97              ; if (c < 97) goto next_iteration;
    jl rot13_next_iteration
    cmp al, 122             ; if (c > 122) goto next_iteration;
    jg rot13_next_iteration

    xor ah, ah              ; empty carry
    add al, 13              ; c += 13;
    cmp ax, 122             ; if (c <= 122) goto next_iteration;
    jle rot13_next_iteration
    sub al, 26              ; c -= 26;

rot13_next_iteration:
    mov ah, [rdx]           ; char mask = *cp;
    and ah, 32              ; mask &= 32; // islower
    or ah, 255 - 32         ; mask |= (255 - 32);
    and al, ah              ; c &= mask;

    mov [rdx], al           ; *cp = c;
    inc rcx                 ; ++i;
    jmp rot13_begin         ; goto begin;

rot13_break:
    inc rbx
    mov rax, 1 ; __NR_write
    mov rdi, 1 ; STDOUT
    mov rsi, buf
    mov rdx, rbx
    syscall

    ; now we see whether the input has less than 16 bytes.
    ; we compare the input size in rbx with 16, through 'cmp'.
    ;
    ; cmp subtracts the operands, but discards the result, storing only
    ; some info about it in a special register: eflags. (*)
    ; eflags stores several flags, but we're mostly interested in two:
    ; the zero flag and the sign flag.
    ; From the basic architecture manual, section 3.4.3.1:
    ;
    ; "ZF (bit 6) Zero flag - Set if the result is zero; cleared otherwise.
    ; SF (bit 7) Sign flag - Set equal to the most-significant bit of
    ; the result, which is the sign bit of a signed integer.
    ; (0 indicates a positive value and 1 indicates a negative value.)"
    ;
    ; These two flags, along with 'cmp', are enough to know whether
    ; x - y == 0 <=> x == y and whether x - y < 0 <=> x < y.
    ; This is enough to compare two integers in any possible way.
    ;
    cmp rbx, 16

    ; conditional jump: if the previous comparsion instruction gives a
    ; 'less than' result - that is, if the sign flag is 1 - jump to the
    ; address stored in the operand label; otherwise, execute the
    ; next instruction as usual. (*)
    ; Just like with 'jmp', this is also changes the value of eip.
    ; There are several instructions for conditional jumps, which are
    ; grouped as 'Jcc' in the instruction set. For the 'jl' instruction,
    ; the instruction set says:
    ; "JL rel8	[...]		Jump short if less (SF != 0F)"
    jl less_16

    ; if we're here, the previous jump didn't happen, so the input must
    ; have 16 bytes or more.
    mov rax, 1 ; __NR_write
    mov rdi, 1 ; stdout
    mov rsi, more_str
    mov rdx, MORE_STRSIZE
    syscall

    ; if it wasn't for this jump, the instructions after the label
    ; less_16 would be executed, so it would simultaneously print
    ; that the input has less than 16 bytes, but also that it has
    ; 16 or more. That's not what we want.
    ; Note that these two jumps effectively implement an if-else; in C,
    ; this would be something like
    ;	if(size > 16) {
    ;		/* print more_str */
    ;	} else {
    ;		/* print less_str */
    ;	}
    ;
    jmp size_printed

less_16:
    ; if we're here, the conditional jump did happen, and the input has
    ; less than 16 bytes
    mov rax, 1 ; __NR_write
    mov rdi, 1 ; stdout
    mov rsi, less_str
    mov rdx, LESS_STRSIZE
    syscall

size_printed:
    ; iterate over buf, adding 1 to each byte.
    ; but first, we temporarily decrease the buf's size by 1,
    ; because we don't want to touch its last character (the newline).
    dec rbx ; dec: decrement

    ; The following code is equivalent to:
    ;	for(i = 0; i < size; i++) {
    ;		str[i];
    ;	}
    ;
    xor rcx, rcx
loop_begin:
    ; if the condition i < size is false, i.e. if i >= size,
    ; get out of the loop at once. If we only made this comparison
    ; at the bottom of the loop, we would have something akin to a
    ; do ... while instead.
    ;
    cmp rcx, rbx
    jge loop_done

    inc byte [buf + rcx] ; inc: increment (++)

    inc rcx ; i++

    ; jump to loop_begin's address, starting a new iteration of the loop
    jmp loop_begin

loop_done:
    ; restore the string's size
    inc rbx

    ; finally, print the string...
    mov rax, 1 ; __NR_write
    mov rdi, 1 ; STDOUT
    mov rsi, buf
    mov rdx, rbx
    syscall

max_start:
    mov rax, arr            ; addr = arr;
    mov edx, [rax]          ; val = *addr;
max_store:
    mov dword [max], edx    ; max = val;
max_no_store:
    add rax, 4              ; ++addr;
    cmp rax, ARR_END        ; if (addr == ARR_END) goto max_done;
    je max_done
    mov edx, [rax]          ; val = *addr;
    mov ebx, dword [max]
    cmp edx, ebx            ; if (val > max) goto max_store;
    jg max_store
    jmp max_no_store        ; else goto max_no_store;
max_done:
    add ebx, 48             ; to ASCII
    mov dword [max], ebx

    mov rax, 1 ; __NR_write
    mov rdi, 1 ; STDOUT
    mov rsi, max
    mov rdx, 1
    syscall

    mov rax, 1 ; __NR_write
    mov rsi, new_line
    syscall

    ; ...and quit!
    mov rax, 60
    xor rdi, rdi
    syscall

; Exercises
;
; === St Thomas' Wisdom ===
; Verify all claims marked with (*).
;	- You can see that how CMP affects the eflags register by printing its
;	value in gdb, and you can see the JL works as stated by putting a
;	breakpoint on it and stepping one instruction.
;
; === Learn to Love Your Compiler ===
; Write the following pseudocode in your favorite *compiled* language:
;	n <- 0
;	for i in range 1 to 9 inclusive do
;		n += i
;	end
;	print n
;
; Now inspect the program generated with "objdump -d".
; Do you see any jumps in the corresponding assembly code? If you do, try out
; a more agressive optmization level (consult your compiler's documentation).
; If you don't, that's because the compiler can figure out that the loop's
; index values are all known at compile time, so it transforms the code into
;	n <- 0
;	n += 1
;	n += 2
;	...
;	n += 9
;	print n
;
; This is called *loop unrolling*. Then, it figures that all those computations
; can also be done in compile time, and finally turns that into
;	n <- 45
;	print n
;
; === Your Turn ===
;	- Max: write a program that, given an array of integers, places the
;	largest of them in a certain register. (The array can be hardcoded,
;	i.e. declared in the .data section)
;
;	- ROT13: write a program that reads a string, then replaces all
;	of its characters in range a-z (lowercase) with its ROT13 equivalent,
;	and prints the string. Bonus points if you do it for uppercase A-Z too.
;	Characters not in range a-z (possibly A-Z as well) must be unchanged.
;
; Bonus
;
; === Race Against the Compiler ===
; Write the same program, both in assembly and in your favourite *compiled*
; progamming language, and compare the execution times of both.
; (Interpreters have the overhead of parsing the code at runtime, so it
; wouldn't be fair. Java counts as interpreted here, because it translates
; its bytecode to native instructions at runtime.)
; Use hardcoded values as input and do NOT print any results, so the timing
; measurements won't be tainted by I/O.
;	- The program must compute the exponentiation of two unsigned integers,
;	using the square and multiply algorithm.
;

; vim: set ft=nasm:
