#include <io.h>
#include <string.h>

unsigned fib(unsigned n, unsigned* f)
{
    if (n <= 24)
        if (f[n] != 0)
            return f[n];

    if (n == 0)
        return 0;
    if (n <= 2)
        return 1;        
    return f[n] = fib(n - 1, f) + fib(n - 2, f);
}

void revstr(char* buf, unsigned len)
{
    unsigned i = 0;
    char temp;
    --len;
    while (i < len)
    {
        temp = buf[i];
        buf[i] = buf[len];
        buf[len] = temp;
        ++i;
        --len;
    }
}

unsigned utoa(unsigned n, char* buf)
{
    unsigned ret = 0;
    do
    {
        buf[ret++] = '0' + n % 10;
        n /= 10;
    } 
    while (n > 0);
    revstr(buf, ret);
    return ret;
}

#define PRINT_FIB(n) len = utoa(fib(n, fibs), buf); write(1, buf, len); write(1, "\n", 1);

int main()
{
    unsigned fibs[24];
    char buf[64];
    unsigned len;

    memset(fibs, 0, sizeof(fibs));

    PRINT_FIB(0)
    PRINT_FIB(1)
    PRINT_FIB(2)
    PRINT_FIB(3)
    PRINT_FIB(4)
    PRINT_FIB(5)
    PRINT_FIB(6)
    PRINT_FIB(7)
    PRINT_FIB(8)
    PRINT_FIB(9)
    PRINT_FIB(10)
    PRINT_FIB(11)
    PRINT_FIB(12)
    PRINT_FIB(13)
    PRINT_FIB(23)
    PRINT_FIB(24)
    //PRINT_FIB(25)

    return 0;
}