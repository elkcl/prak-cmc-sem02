#include <stdio.h>

int main(void) {
    int a = 0, b = 0;
    char c = 0;
    scanf("%d", &a);
    c = getchar();
    scanf("%d", &b);
    switch (c) {
        case '+':
            printf("%d\n", a + b);
            break;
        case '-':
            printf("%d\n", a - b);
            break;
        case '*':
            printf("%d\n", a * b);
            break;
        case '/':
            printf("%d\n", a / b);
            break;
	default:
	    break;
    }
}
