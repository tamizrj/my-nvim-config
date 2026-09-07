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
    // one line if statements allowed
    if (foo.size() < 3) return 0;
    else if (foo.size() < 5) {
        return 1;
    } else cout << "welp\n";

    // braces should be multi line
    if (foo.size() > 10) {
        cout << "lots of elements\n";
    }

    if (foo.size() < 10) {
        foo[0]++;
    }

    if (foo.size() > 15) {
        cout << "even more!!\n";
    }

    // spaces around lists
    vector<int> bar = { 3, 1, 4, 1, 5 };

    int res = 1;
    // similar behaviour with loops as ifs
    for (int x : bar) res *= x;

    return res;
}

int aVeryLongFunctionWithLotsOfParameters(
    int parameterOne, int parameterTwo, int parameterThree
) {
    // something like this for long expressions
    return parameterOne * parameterThree * parameterTwo * parameterThree
           - 145 * parameterTwo + 3 * parameterThree * parameterTwo;
}
