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
    WINDOW_TITLE: db "Assembly GLUT", 0
    BLUE: dd 1.0

section .text

main:                               ;int main(int argc, char** argv)
    push rbp                        ;{
    mov rbp, rsp

    and rsp, -16
    sub rsp, 16

    mov dword [rsp], edi
    lea rdi, [rsp]
    call glutInit                   ;    glutInit(&argc, argv);

    mov rdi, 2                      ;    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA);
    call glutInitDisplayMode

    mov rdi, 1024
    mov rsi, 768
    call glutInitWindowSize         ;    glutInitWindowSize(1024, 768);

    mov rdi, 100
    mov rsi, 100
    call glutInitWindowPosition     ;    glutInitWindowPosition(100, 100);

    mov rdi, WINDOW_TITLE
    call glutCreateWindow           ;    glutCreateWindow("Assembly GLUT");

    mov rdi, render
    call glutDisplayFunc            ;    glutDisplayFunc(render);

    pxor xmm0, xmm0
    pxor xmm1, xmm1
    movss xmm2, dword [BLUE]
    pxor xmm3, xmm3
    call glClearColor               ;    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);

    call glutMainLoop               ;    glutMainLoop();

.done:
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
