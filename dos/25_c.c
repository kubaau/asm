#include <stdio.h>
#include <string.h>

#define BUFFER_SIZE 64

unsigned factorial(unsigned);
unsigned atoi2(const char*, size_t);
int itoa2(unsigned, char*);

int main(int argc, char* argv[])
{    
    char buf[BUFFER_SIZE];
    unsigned f;
    int n;

    if (argc < 2)
        return 1;

    n = atoi2(argv[1], strlen(argv[1]));
    f = factorial(n);
    buf[itoa2(f, buf)] = '\0';
    printf("%d! = %d = %s\n", n, f, buf);

    return 0;
}
