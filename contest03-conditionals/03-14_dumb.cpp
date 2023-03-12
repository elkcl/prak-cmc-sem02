#include <iostream>

using namespace std;

int main() {
    uint32_t n, k;
    cin >> n >> k;
    uint32_t ans = 0;
    for (uint32_t i = 1; i <= n; ++i) {
        uint32_t curr = 32;
        curr -= __builtin_popcount(i);
        curr -= __builtin_clz(i);
        if (curr == k)
            ++ans;
    }
    cout << ans << '\n';
}
