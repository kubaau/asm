; Copyright 2018-2019 Mateus Carmo M de F Barbosa
;
; This file is licensed under the CC-BY-SA 2.0 license.
; See LICENSE for details.
;

; (4) leaf.sam: leaf functions, calling conventions, and the stack
;
; We've already seen how branches and loops work under the hood;
; now let's do the same for functions.
; For now, we'll only deal with _leaf_ functions -- that is, functions that
; do not call other functions. Non-leaf functions require some extra work and
; will be covered in the next file.

global _start

section .data
    STR: db 'this string will be reversed!',0xA
    STRSIZE: equ $ - STR

section .text
_start:
    ; So far, all the code we had was in _start; now some of it goes into
    ; a separate function. We'll call our function revstr to reverse STR
    ; before writing it to stdout.
    ; (You can see the parameters revstr takes and its return type below.)
    ;
    ; Calling a function is done simply with the 'call' instruction
    ; (more on this below). But where do the parameters go? And where does
    ; the function put its return value?
    ; Each operating system has a calling convention, which answers these
    ; questions; it is defined in the OS's Application Binary Interface
    ; (ABI). Linux follows the Unix System V ABI, which states, in section
    ; 3.2.3 (Parameter Passing):
    ;
    ; "2. If the class is INTEGER, the next available register of the sequence
    ;  %rdi, %rsi, %rdx, %rcx, %r8 and %r9 is used"
    ;
    ; (Note that the sequence is similar, but slightly different than that
    ; used for system calls.) The INTEGER class is defined as
    ;
    ; "INTEGER This class consists of integral types that fit into one of
    ; the general purpose registers."
    ;
    ; Since we're not dealing with floats yet, or with absurdly large
    ; values, all our parameters fit that definition.
    ; (Again, assembly doesn't have types, so pretty much everything can be
    ; seen as an "integral type", including pointers.)
    ; As for the return value:
    ;
    ; "3. If the class is INTEGER, the next available register of the
    ; sequence %rax, %rdx is used."
    ;
    ; Note that this allows us to return two 64-bit values, or a single
    ; 128-bit value, by placing its upper bits in rdx and its lower bits
    ; on rax. This isn't needed in most cases, though.
    ;
    mov rdi, STR		; 1st arg in rdi
    lea rsi, [STRSIZE - 1]	; 2nd arg in rsi (-1: don't include the newline)

    ; Now that the arguments are in the right place, we call the function.
    ; All it takes is using the CALL instruction, with the label that stores
    ; the address of the beginning of the function.
    ; But how does CALL work?
    ;
    ; Calling a function is a lot like an unconditional jump, because
    ; the next instruction we want to execute will be at the beginning of
    ; the function we want to call. There's only one catch: when the
    ; function returns, we have to go back to the instruction that was right
    ; after the call. So we could implement a call as a modified 'jmp' that
    ; stores the return address somewhere. And where is that?
    ;
    ; If you ever heard an explanation of how a recursive implementation
    ; of the Fibonnaci sequence or the factorial function work,
    ; you may have heard that each function's variables is stored in a stack.
    ; Well, that's the one. The call stack, or execution stack for some.
    ; (From now on, we'll just refer to it as "the stack".)
    ; It's also used to store the return addresses: it makes sense to store
    ; return addresses in a stack, because if function A calls B
    ; which calls C which calls D, when D returns, we expect it to return
    ; to C, meaning we must jump to the return address saved last, which is
    ; a last-in-first-out policy.
    ;
    ; Therefore, calling a function means pushing the next instruction's
    ; address (i.e. the contents of RIP) to the stack, then jumping to
    ; (setting RIP to) the argument supplied. (*)
    ; Indeed, from the instruction set:
    ;
    ; "
    ;[...]
    ;ELSE (* Near absolute call *)
    ;	IF OperandSize = 64
    ;	THEN
    ;		tempRIP <- DEST; (* DEST is r/m64 *)
    ;	IF stack not large enough for a 8-byte return address
    ;	THEN #SS(0); FI;
    ;	Push(RIP);
    ;	RIP <- tempRIP;
    ;	FI;
    ; "
    ; (Note: we omit the difference between near/far and absolute/relative
    ; calls for now. All calls we're dealing with are near and absolute.)
    ;
    call revstr

    ; write STR
    mov rax, 1 ; __NR_write
    mov rdi, 1 ; stdout
    mov rsi, STR
    mov rdx, STRSIZE
    syscall

    mov edi, 17
    call countCollatz

    call countCollatz

    mov edi, 2
    push .after_ret
    push countCollatz
    ret
.after_ret:
    ;call countCollatz

    ; quit
    mov rax, 60
    xor rdi, rdi
    syscall

; void revstr(char *s, size_t size);
;	reverses the bytes of the array s, which has size bytes.
;
; A function definition starts with a label, which we can use to call it.
; Note that the assembler doesn't know whether this is a label is a function
; or something else; labels are only meant to store addresses,
; and those addresses could be of anything.
; It's our use of this address (with the CALL instruction) that makes it
; a function.
;
revstr:
    ; There are some registers which functions are not allowed to change.
    ; Those are the callee-saved registers, and which registers have that
    ; property depends on the ABI.
    ; From SysV ABI's figure 3.4, they are rbx and r12 through r15.
    ; In leaf functions, all it takes to make sure these registers won't
    ; change is not writing to them.
    ; (Callee-saved registers will be explained further in the next file.)
    ;
    xor r8, r8
    lea r9, [rsi - 1]

    ; labels starting with a dot '.' are local labels.
    ; You can define several local labels with the same name in separate
    ; functions and they won't conflict.
    ; From the NASM manual, section 3.9: "
    ;
    ; label1 ; some code
    ; .loop
    ; [...]
    ;
    ; label2 ; some code
    ; .loop
    ; [...]
    ;
    ; [...] This is achieved by means of defining a local label
    ; in terms of the previous non-local label: the first definition of
    ; .loop above is really defining a symbol called label1.loop,
    ; and the second defines a symbol called label2.loop." (*)
.loop:
    cmp r8, r9
    jge .done

    ; swap s[r8] and s[r9]
    ; XCHG exchanges two values. Unfortunately, at least one of them has
    ; to be a register, or else we could simply do
    ; 'xchg byte [rsi + r8], byte [rsi + r9]'
    ;
    mov cl, byte [rdi + r8]
    xchg cl, byte [rdi + r9]
    mov byte [rdi + r8], cl

    inc r8
    dec r9
    jmp .loop
.done:
    ; Return from the function: pop the address stored in the stack
    ; and set RIP to that. From the instruction set:
    ;
    ;IF instruction = near return
    ;THEN;
    ;	IF OperandSize = 32
    ; [...]
    ;	ELSE IF OperandSize = 64
    ;	THEN
    ;		IF top 8 bytes of stack not within stack limits
    ;			THEN #SS(0); FI;
    ;			RIP <- Pop();
    ;
    ; Note that if a malicious agent manages to change the value
    ; corresponding to the return address in the stack, they can deviate
    ; execution to run malicious instructions: this is called stack smashing.
    ; Many protection mechanisms have been devised to prevent it.
    ;
    ret

countCollatz:
    xor ecx, ecx        ; int i = 0;

.loop:
    cmp edi, 1          ; if (n == 1) goto .done;
    je .done

    inc ecx             ; ++i;

    mov eax, edi        ; int temp = n;
    and eax, 1          ; temp &= 1;
    cmp eax, 1          ; if (temp == 1) goto .odd;
    je .odd

.even:
    shr edi, 1          ; n /= 2;
    jmp .loop           ; goto .loop;

.odd:
    mov eax, edi        ; temp = n;
    mov edx, 3          ; int temp2 = 3;
    mul edx             ; temp *= temp2;
    inc eax             ; ++temp
    mov edi, eax        ; n = temp
    jmp .loop           ; goto .loop;

.done:
    mov eax, ecx        ; int ret = i;
    ret ;countCollatz   ; return ret;

; Exercises
; (Note: all functions referred to here must be leaf functions.)
;
; === St Thomas' Wisdom ===
; Verify all claims marked with (*).
;
; === Learn to Love Your Compiler ===
; Write the following pseudocode in your favorite *compiled* language:
;
;	function halve_truncate(integer i) -> integer
;		return floor(i / 2);
;	end function
;	read integer n from standard input
;	print halve_truncate(n)
;
; Now inspect the program generated with "objdump -d". Do you see any call to
; halve_truncate? If you do, try out a more agressive optmization level
; (consult your compiler's documentation). If you don't, that's because the
; compiler realized the function is so small and it's only called from one
; place, there's no good reason to pay the overhead of calling it.
; Instead, it "copy-pastes" the function's code and places it where the
; function call once was, like so:
;
;	read integer n from standard input
;	print floor(n / 2)
;
; This is called *inlining*.
;
; === Your Turn ===
;	- Write a function that recieves an unsigned integer, and returns the
;	number of steps required for that number to become 1 with successive
;	applications of the Collatz function:
;		f(n) = n/2      if n is even
;		       3*n + 1  if n is odd
;
;	Bonus points if you use dynamic programming (storing the intermediate
;	results in a huge array, which can be declared in the .data section.)
;	Note: because the function must be leaf, you're required to implement
;	an iterative function (rather than a recursive one).
;
;	- Write a program that calls that function for several numbers,
;	at your choice. Run it in gdb to see your function's return values.
;
; === Pointless Constraints Make Amusing Puzzles ===
;	- Make a function call using only the instructions PUSH and RET,
;	and labels.
;	Note that the function is still expected to return to its caller in the
;	usual way - with a RET instruction at its end - and it must return to
;	the instruction immediately following the last one that caused
;	the function to be called.
;
;	- Write a program that reads a string, then calls a function that
;	replaces all its characters with '+' if the string's size is even,
;	but calls a different function that replaces them with '-' if the
;	size is odd. However, the program must contain *a single* CALL
;	instruction, and you're not allowed to use jumps instead of CALL,
;	or call the functions with any instruction that isn't CALL.
;	You'll probably need to read the instruction set's entry for CALL here.
;	(Hint: use two CALLs first, worry about the constraint later.)

; vim: set ft=nasm:
