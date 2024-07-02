int main()
{
    asm
    (
    ".section .data\n"
    ".set WRITE, 4\n"
    ".set READ, 3\n"
    ".set STDIN, 0\n"
    ".set STDOUT, 1\n"
    "PROMPT: .ascii \"What is your name?\\n\"\n"
    "PROMPT_END:\n"
    ".set PROMPT_SIZE, PROMPT_END - PROMPT\n"
    "HELLO: .ascii \"Hello, \"\n"
    "HELLO_END:\n"
    ".set HELLO_SIZE, HELLO_END - HELLO\n"
    ".set BUF_SIZE, 64"
    );

    asm
    (
    ".section .bss\n"
    ".lcomm buf, BUF_SIZE"
    );

    asm
    (
    ".section .text\n"
    "mov $WRITE, %eax\n"
    "mov $STDOUT, %ebx\n"
    "mov $PROMPT, %ecx\n"
    "mov $PROMPT_SIZE, %edx\n"
    "int $0x80"
    );

    asm("mov $READ, %eax");
    asm("mov $STDIN, %ebx");
    asm("mov $buf, %ecx");
    asm("mov $BUF_SIZE, %edx");
    asm("int $0x80");

    asm("pushl %eax");

    asm("mov $WRITE, %eax");
    asm("mov $STDOUT, %ebx");
    asm("mov $HELLO, %ecx");
    asm("mov $HELLO_SIZE, %edx");
    asm("int $0x80");

    asm("mov $WRITE, %eax");
    asm("mov $STDOUT, %ebx");
    asm("mov $buf, %ecx");
    asm("popl %edx");
    asm("int $0x80");
}
