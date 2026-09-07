#include <bits/stdc++.h>

#define newl '\n'

using ll = long long;
using namespace std;

int main(void) {
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);

    return 0;
}

int demo(vector<int>& foo) {
    if (foo.size() < 3) return 3;

    if (foo.size() > 10) { cout << "big function \n"; }

    vector<int> bar = {3, 1, 4, 1, 5};
    int res = 1;
    for (int x : bar)
        res *= x;

    return -1;
}

int aVeryLongFunctionWithLotsOfParameters(
    int parameterOne,
    int parameterTwo,
    int parameterThree
) {
    return parameterOne * parameterTwo + parameterThree;
}
