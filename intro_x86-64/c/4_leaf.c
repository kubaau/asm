/*
;	function halve_truncate(integer i) -> integer
;		return floor(i / 2);
;	end function
;	read integer n from standard input
;	print halve_truncate(n)
*/

#include <math.h>
#include <stdio.h>

int halve_truncate(int i)
{
    return floor(i / 2.0);
}

int main()
{
    int i;
    scanf("%d", &i);
    printf("%d\n", halve_truncate(i));
}
