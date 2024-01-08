data = [[int(i) for i in l.replace('@',',').split(',')]
                for l in open(0)]


def solve(a, b):
    m = [a+[b] for a,b in zip(a, b)]
    m = [[a-b  for a,b in zip(a, m[4])] for a in m[:4]]

    for i in range(len(m)):
        m[i] = [m[i][k]/m[i][i] for k in range(len(m[i]))]

        for j in range(i+1, len(m)):
            m[j] = [m[j][k]-m[i][k]*m[j][i] for k in range(len(m[i]))]

    for i in reversed(range(len(m))):
        for j in range(i):
            m[j] = [m[j][k]-m[i][k]*m[j][i] for k in range(len(m[i]))]

    return [r[-1] for r in m]


def cols(a, b, c, d):
    A = [[r[c], -r[d], r[a], r[b]] for r in data]
    B = [r[b] * r[c] - r[a] * r[d] for r in data]
    return A, B

x, y, *_ = solve(*cols(0, 1, 3, 4))
z,    *_ = solve(*cols(1, 2, 4, 5))

print(x+y+z)
print(x,y,z)
