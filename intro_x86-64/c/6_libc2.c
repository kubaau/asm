/*
;	- Write a program that takes any number of command line arguments,
;	and prints their characters interleaved: the first character of each
;	argument must be printed in sequence, then the second, and so on.
;	For simplicity's sake, your program can refuse arguments of different
;	lengths.
*/

#include <stdio.h>

int main(int argc, char** argv)
{
    int char_index = 0;
charLoop:;
    int arg_index = 1;
argLoop:;
    if (arg_index == argc)
        goto nextCharIter;
    char c = argv[arg_index][char_index];
    if (!c)
        goto done;
    printf("%c", c);
nextArgIter:
    ++arg_index;
    goto argLoop;
nextCharIter:
    printf("\n");
    ++char_index;
    goto charLoop;
done:;
}
