#include <stdio.h>
#include <stdlib.h>

int customMain()
{
    puts("This is a program without a main() function!");
    return 0;
}

void _start()
{
    exit(customMain());
}

