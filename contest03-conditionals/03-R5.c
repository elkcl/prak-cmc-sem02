#include <stdio.h>
#include <stdbool.h>

int main(void) {
    unsigned int n = 0;
    scanf("%u", &n);
    int ans = 0;
    if (n % 2 == 0) {
	n /= 2;
        do {
            int x1 = 0;
            int x2 = 0;
            scanf("%d", &x1);
            scanf("%d", &x2);
            ans += x1 * x2;
            --n;
        } while (n != 0);
    }
    printf("%d\n", ans);
}
