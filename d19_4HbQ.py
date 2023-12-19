flows, parts = open(0).read().split('\n\n')

A = lambda: 1 + x+m+a+s
R = lambda: 1

for f in flows.split():
    f = f.replace(':', 'and ')
    f = f.replace(',', '()or ')
    f = f.replace('{', '=lambda:')
    f = f.replace('}', '()')
    f = f.replace('in','IN')
    exec(f)

# S = 0
# for p in parts.split():
#     p = p.replace(',',';')
#     exec(p[1:-1] + ';S+=IN()-1')

# print(S)

import re

splits = {k: [0, 4000] for k in 'xmas'}

for f in flows.split():
    for c,o,v in re.findall(r'(\w+)(<|>)(\d+)', f):
        splits[c].append(int(v)-(o=='<'))

for c in splits: splits[c].sort()

pairs = lambda x: [(b,b-a,(b,a)) for a,b in zip(x,x[1:])]

S=0
for x,dx,x_ in pairs(splits['x']):
    for m,dm,m_ in pairs(splits['m']):
        for a,da,a_ in pairs(splits['a']):
            for s,ds,s_ in pairs(splits['s']):
                print(dx*dm*da*ds, {"dx":x_,"dm":m_,"da":a_,"ds":s_})
                S += dx * dm * da * ds * (IN()>1)

print(S)
