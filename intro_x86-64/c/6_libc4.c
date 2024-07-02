/*
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
*/

#include <GL/freeglut.h>

static void render()
{
    glClear(GL_COLOR_BUFFER_BIT);
    glutSwapBuffers();
}

int main(int argc, char** argv)
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA);
    glutInitWindowSize(1024, 768);
    glutInitWindowPosition(100, 100);
    glutCreateWindow("Tutorial 01");
    glutDisplayFunc(render);
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glutMainLoop();
}
