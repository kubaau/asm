int main()
{
    asm
    (
    ".section .data\n"
    ".set WRITE, 1\n"
    ".set READ, 0\n"
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
    "mov $WRITE, %rax\n"
    "mov $STDOUT, %rdi\n"
    "mov $PROMPT, %rsi\n"
    "mov $PROMPT_SIZE, %rdx\n"
    "syscall"
    );

    asm("mov $READ, %rax");
    asm("mov $STDIN, %rdi");
    asm("mov $buf, %rsi");
    asm("mov $BUF_SIZE, %rdx");
    asm("syscall");

    asm("mov %rax, %rbx");

    asm("mov $WRITE, %rax");
    asm("mov $STDOUT, %rdi");
    asm("mov $HELLO, %rsi");
    asm("mov $HELLO_SIZE, %rdx");
    asm("syscall");

    asm("mov $WRITE, %rax");
    asm("mov $STDOUT, %rdi");
    asm("mov $buf, %rsi");
    asm("mov %rbx, %rdx");
    asm("syscall");
}
