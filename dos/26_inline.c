#define BUF_SIZE 64

#define PUTS 9h
#define READ 3Fh
#define WRITE 40h
#define EXIT 4Ch

#define STDOUT 1

int main()
{
    const char* prompt = "What is your name?\n$";
    const far char* hello = "Hello, $";

    asm {
        sub sp, BUF_SIZE

        mov dx, prompt
        mov ah, PUTS
        int 21h

        mov cx, BUF_SIZE
        mov ax, ss
        mov ds, ax
        mov dx, sp
        mov ah, READ
        xor bx, bx
        int 21h
        sub ax, 2
        mov cx, ax

        lds dx, [hello]
        mov ah, PUTS
        int 21h

        mov ax, ss
        mov ds, ax
        mov dx, sp
        mov ah, WRITE
        mov bx, STDOUT
        int 21h
    }

    return 0;
}