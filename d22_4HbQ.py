import collections as C, re

def drop(stack, skip=None):
    peaks = C.defaultdict(int)
    falls = 0

    for i, (u,v,w, x,y,z) in enumerate(stack):
        if i == skip: continue

        area = [(a, b) for a in range(u, x+1)
                       for b in range(v, y+1)]
        peak = max(peaks[a] for a in area)+1
        for a in area: peaks[a] = peak+z-w

        stack[i] = (u,v,peak, x,y,peak+z-w)
        falls += peak < w

    return not falls, falls


stack = sorted([[*map(int, re.findall(r'\d+',l))]
    for l in open('d22.in')], key=lambda b:b[2])

drop(stack)

print(*map(sum, zip(*[drop(stack.copy(), skip=i)
    for i in range(len(stack))])))
