#include <stdio.h>
#include <string.h>

#define MAXN 5000

int main(void) {
    unsigned char tr[256];
    for (int i = 0; i < 256; ++i) {
        tr[i] = i;
    }
    unsigned char buf1[MAXN], buf2[MAXN];
    fgets(buf1, MAXN, stdin);
    fgets(buf2, MAXN, stdin);
    int n = strlen(buf1) - 1;
    buf1[n] = '\0';
    if (strlen(buf2) - 1 != n)
        return 0;
    buf2[n] = '\0';
    for (int i = 0; i < n; ++i) {
        tr[buf1[i]] = buf2[i];
    }
    int k = 0;
    scanf("%d", &k);
    while (getchar() != '\n')
        ;
    while (k--) {
        fgets(buf1, MAXN, stdin);
        for (int i = 0; buf1[i] != '\n'; ++i) {
            putchar(tr[buf1[i]]);
        }
        putchar('\n');
    }
}
