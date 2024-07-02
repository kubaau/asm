/*
;	function foo(integer x) -> integer
;		n <- 0
;		i <- 0
;		while (i < x)
;			n += i
;			i += 1
;		end while
;		return n
;	end function
;
;	function bar(integer x) -> integer
;		y <- foo(x)
;		return x * y
;	end function
*/

#include <stdio.h>

int foo(int x)
{
    int n = 0;
    int i = 0;
    while (i < x)
    {
        n += i;
        i += 1;
    }
    return n;
}

int bar(int x)
{
    int y = foo(x);
    return x * y;
}

int main()
{
    printf("%d\n", bar(7));
}
