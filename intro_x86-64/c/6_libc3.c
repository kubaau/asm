/*
;	- Write a program that reads a sequence of integers from standard input
;	and sorts it using the qsort() function.
*/

#include <stdio.h>
#include <stdlib.h>

int compareInt(const void* lhs, const void* rhs)
{
    int lhsi = *(int*)(lhs);
    int rhsi = *(int*)(rhs);
    if (lhsi < rhsi)
        return -1;
    if (lhsi > rhsi)
        return 1;
    return 0;
}

int main(int argc, char** argv)
{
    int n;
    scanf("%d", &n);
    size_t size = sizeof(int);
    size *= n;
    int* ints = malloc(size);

    int i = 0;
scanLoop:
    if (i == n)
        goto scanLoopDone;
    int* current_int_ptr = ints + i;
    scanf("%d", current_int_ptr);
    ++i;
    goto scanLoop;

scanLoopDone:
    qsort(ints, n, sizeof(int), compareInt);

    i = 0;
printLoop:
    if (i == n)
        goto printLoopDone;
    int current_int = ints[i];
    printf("%d ", current_int);
    ++i;
    goto printLoop;

printLoopDone:;
}
