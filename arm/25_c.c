#include <stdint.h>
#include <stdio.h>
#include <string.h>

#define BUFFER_SIZE 1024

unsigned factorial(unsigned);
unsigned atoi2(const char*, size_t);
int itoa2(unsigned, char*);

int main(int argc, char* argv[])
{
    if (argc < 2)
        return 1;

    char buf[BUFFER_SIZE];
    int n = atoi2(argv[1], strlen(argv[1]));
    const unsigned f = factorial(n);
    buf[itoa2(f, buf)] = '\0';
    printf("%d! = %d = %s\n", n, f, buf);

    return 0;
}
