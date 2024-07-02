; === Fly Higher ===
; We've shown how to use the standard C library with assembly, but you can use
; any C library in a similar fashion (as long as you link it against the final
; executable.) Write a simple assembly program that uses some library you're
; familiar with.
; If you're out of ideas, here are a few, with the suggested libraries in
; parenthesis:
;	- Create a blank GUI window, then destroy it after N seconds (SDL, XCB)
;	- Play a WAV file, or a single note with fixed duration (SDL, openAL?)
;	- Encrypt user input with AES, or compute its MD5 hash (openSSL)
;	- Fetch an HTML file from an HTTP URL (libcurl)

global main

extern glClear
extern glClearColor
extern glutCreateWindow
extern glutDisplayFunc
extern glutInit
extern glutInitDisplayMode
extern glutInitWindowPosition
extern glutInitWindowSize
extern glutMainLoop
extern glutSwapBuffers

section .rodata
    window_title: db "Assembly GLUT", 0
    blue: dd 1.0

section .text

main:                               ;int main(int argc, char** argv)
    push rbp                        ;{
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15

    sub rsp, 8
    mov qword [rsp + 8], rdi
    lea rdi, [rsp + 8]
    call glutInit                   ;    glutInit(&argc, argv);

    mov rdi, 2                      ;    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA);
    call glutInitDisplayMode

    mov rdi, 1024
    mov rsi, 768
    call glutInitWindowSize         ;    glutInitWindowSize(1024, 768);

    mov rdi, 100
    mov rsi, 100
    call glutInitWindowPosition     ;    glutInitWindowPosition(100, 100);

    mov rdi, window_title
    call glutCreateWindow           ;    glutCreateWindow("Tutorial 01");

    mov rdi, render
    call glutDisplayFunc            ;    glutDisplayFunc(render);

    pxor xmm0, xmm0
    pxor xmm1, xmm1
    movss xmm2, dword [blue]
    pxor xmm3, xmm3
    call glClearColor               ;    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);

    call glutMainLoop               ;    glutMainLoop();

.done:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    xor rax, rax
    ret ; main                      ;}

render:                             ;static void render()
                                    ;{
    push rbp                        ;enter 0, 0
    mov rbp, rsp

    mov rdi, 0x4000
    call glClear                    ;    glClear(GL_COLOR_BUFFER_BIT);

    call glutSwapBuffers            ;    glutSwapBuffers();

    mov rsp, rbp
    pop rbp                         ;leave
    ret ; render                    ;}
