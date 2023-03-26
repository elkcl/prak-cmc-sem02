#include <stdio.h>

int main(void) {
    unsigned int a = 0;
    scanf("%u", &a);
    unsigned int curr = 1u << 31;
    while (a % curr != 0)
	    curr /= 2;
    printf("%u", curr);
}
