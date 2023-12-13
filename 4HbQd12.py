from functools import cache

def f(line):
    P, N = line.split()
    P += "."
    N = [int(n) for n in N.split(',')]
    print("P", P, len(P), "N", N, len(N));
    # P, N = (P+'?') * 5, eval(N) * 5

    @cache
    def dp(p, n, r=0):
        if p == len(P):
            print("p", p, "n", "n==len(N)", n==len(N))
            return n == len(N)

        if P[p] in '.?': r += dp(p+1, n)

        try:
            q = p+N[n]
            if P[p] in '#?' and '.' not in P[p:q] and '#' not in P[q]:
                r += dp(q+1, n+1)
        except IndexError: print("pass", "p", p, "n", n)
        print("p", p, "n", n, "r", r)
        return r

    return dp(0, 0)

print(sum(map(f, open(0))))
