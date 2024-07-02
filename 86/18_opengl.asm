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
    push ebp                        ;{
    mov ebp, esp
    push edi
    push esi

    mov edi, [esp + 16]             ;    int r12 = argc;
    mov esi, [esp + 20]             ;    char** r13 = argv;

    and esp, -16
    sub esp, 16

    mov eax, esp
    push esi
    push eax
    call glutInit                   ;    glutInit(&argc, argv);
    add esp, 8

    push 2
    call glutInitDisplayMode        ;    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA);
    add esp, 4

    push 768
    push 1024
    call glutInitWindowSize         ;    glutInitWindowSize(1024, 768);
    add esp, 8

    push 100
    push 100
    call glutInitWindowPosition     ;    glutInitWindowPosition(100, 100);
    add esp, 8

    push WINDOW_TITLE
    call glutCreateWindow           ;    glutCreateWindow("Assembly GLUT");
    add esp, 4

    push render
    call glutDisplayFunc            ;    glutDisplayFunc(render);
    add esp, 4

    push 0
    sub esp, 4
    fld dword [BLUE]
    fstp dword [esp]
    push 0
    push 0
    call glClearColor               ;    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    add esp, 16

    call glutMainLoop               ;    glutMainLoop();

.done:
    pop esi
    pop edi
    mov esp, ebp
    pop ebp
    xor eax, eax
    ret ; main                      ;}

render:                             ;static void render()
                                    ;{
    push ebp                        ;enter 0, 0
    mov ebp, esp

    push 0x4000
    call glClear                    ;    glClear(GL_COLOR_BUFFER_BIT);
    add esp, 4

    call glutSwapBuffers            ;    glutSwapBuffers();

    mov esp, ebp
    pop ebp                         ;leave
    ret ; render                    ;}
