#include <stdint.h>
#include <stdio.h>
#include <string.h>

#define BUFFER_SIZE 1024

uint64_t factorial(uint64_t);
uint64_t atoi2(const char*, size_t);
int itoa2(uint64_t, char*);

int main(int argc, char* argv[])
{
    if (argc < 2)
        return 1;

    char buf[BUFFER_SIZE];
    const int n = atoi2(argv[1], strlen(argv[1]));
    const uint64_t f = factorial(n);
    buf[itoa2(f, buf)] = '\0';
    printf("%d! = %ld = %s\n", n, f, buf);

    return 0;
}
