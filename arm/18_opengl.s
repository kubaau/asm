.global main

.extern glClear
.extern glClearColor
.extern glutCreateWindow
.extern glutDisplayFunc
.extern glutInit
.extern glutInitDisplayMode
.extern glutInitWindowPosition
.extern glutInitWindowSize
.extern glutMainLoop
.extern glutSwapBuffers

.section .rodata
    WINDOW_TITLE: .asciz "Assembly GLUT"
    .set ZERO, 0
    .set BLUE, 0x3f800000       @     BLUE: dd 1.0

.text
main:
    push {r11, lr}              @     push rbp                        ;{
    mov r11, sp                 @     mov rbp, rsp

    and sp, #-16                @     and rsp, -16
    sub sp, #16                 @     sub rsp, 16

    str r0, [sp]                @     mov dword [rsp], edi
    mov r0, sp                  @     lea rdi, [rsp]
    bl glutInit                 @     call glutInit                   ;    glutInit(&argc, argv);

    mov r0, #2                  @     mov rdi, 2                      ;    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA);
    bl glutInitDisplayMode      @     call glutInitDisplayMode

    ldr r0, =320                @     mov rdi, 1024
    ldr r1, =200                @     mov rsi, 768
    bl glutInitWindowSize       @     call glutInitWindowSize         ;    glutInitWindowSize(1024, 768);

    ldr r0, =100                @     mov rdi, 100
    ldr r1, =100                @     mov rsi, 100
    bl glutInitWindowPosition   @     call glutInitWindowPosition     ;    glutInitWindowPosition(100, 100);

    ldr r0, =WINDOW_TITLE       @     mov rdi, WINDOW_TITLE
    bl glutCreateWindow         @     call glutCreateWindow           ;    glutCreateWindow("Assembly GLUT");

    ldr r0, =render             @     mov rdi, render
    bl glutDisplayFunc          @     call glutDisplayFunc            ;    glutDisplayFunc(render);

    vldr s0, =ZERO              @     pxor xmm0, xmm0
    vldr s1, =ZERO              @     pxor xmm1, xmm1
    vldr s2, =BLUE              @     movss xmm2, dword [BLUE]
    vldr s3, =ZERO              @     pxor xmm3, xmm3
    bl glClearColor             @     call glClearColor               ;    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);

    bl glutMainLoop             @     call glutMainLoop               ;    glutMainLoop();

.done:
    mov sp, r11                 @     mov rsp, rbp
    pop {r11, pc}               @     pop rbp
    eor r0, r0                  @     xor rax, rax
    bx lr                       @     ret ; main                      ;}

render:
                                @                                     ;{
    push {r11, lr}              @     push rbp                        ;enter 0, 0
    mov r11, sp                 @     mov rbp, rsp

    mov r0, #0x4000             @     mov rdi, 0x4000
    bl glClear                  @     call glClear                    ;    glClear(GL_COLOR_BUFFER_BIT);

    bl glutSwapBuffers          @     call glutSwapBuffers            ;    glutSwapBuffers();

    mov sp, r11                 @     mov rsp, rbp
    pop {r11, pc}               @     pop rbp                         ;leave
    bx lr                       @     ret ; render                    ;}
