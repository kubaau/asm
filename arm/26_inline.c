int main()
{
    asm
    (
    ".section .rodata\n"
    ".set WRITE, 4\n"
    ".set READ, 3\n"
    ".set EXIT, 1\n"
    ".set STDIN, 0\n"
    ".set STDOUT, 1\n"
    ".set BUF_SIZE, 64\n"
    "PROMPT: .ascii \"What is your name?\\n\"\n"
    ".set PROMPT_SIZE, . - PROMPT\n"
    "HELLO: .ascii \"Hello, \"\n"
    ".set HELLO_SIZE, . - HELLO"
    );

    asm
    (
    ".bss\n"
    ".lcomm buf, BUF_SIZE"
    );

    asm
    (
    ".text\n"
    "ldr r7, =WRITE\n"
    "ldr r0, =STDOUT\n"
    "ldr r1, =PROMPT\n"
    "ldr r2, =PROMPT_SIZE\n"
    "svc #0"
    );

    asm("ldr r7, =READ");
    asm("ldr r0, =STDIN");
    asm("ldr r1, =buf");
    asm("ldr r2, =BUF_SIZE");
    asm("svc #0");

    asm("mov r3, r0");

    asm("ldr r7, =WRITE");
    asm("ldr r0, =STDOUT");
    asm("ldr r1, =HELLO");
    asm("ldr r2, =HELLO_SIZE");
    asm("svc #0");

    asm("ldr r7, =WRITE");
    asm("ldr r0, =STDOUT");
    asm("ldr r1, =buf");
    asm("mov r2, r3");
    asm("svc #0");
}
