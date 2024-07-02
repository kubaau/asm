/*
; Feed a C compiler the following code:
;
;	struct pair {
;		int a;
;		int b;
;	};
;
;	int main(int argc, char **argv)
;	{
;		struct pair p = {2, 5};
;		// do something with p
;		return 0;
;	}
;
; And see the resulting program's instructions. Where is p stored?
; Now, change the main function to:
;
;	int main(int argc, char **argv)
;	{
;		struct pair *p = malloc(sizeof(struct pair));
;		p->a = 2;
;		p->b = 5;
;		// do something with p
;		free(p);
;		return 0;
;	}
;
; Where is p stored now?
*/

struct pair
{
    int a;
    int b;
};

/*
int main(int argc, char** argv)
{
    struct pair p = {2, 5};
    // do something with p
    return 0;
}
*/

#include <stdlib.h>

int main(int argc, char** argv)
{
    struct pair* p = malloc(sizeof(struct pair));
    p->a = 2;
    p->b = 5;
    // do something with p
    free(p);
    return 0;
}
