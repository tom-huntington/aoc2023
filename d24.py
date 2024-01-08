from itertools import combinations
import numpy as np
from math import prod

exterior3 = lambda u,v,w: u[0]*v[1]*w[2] + u[1]*v[2]*w[0] + u[2]*v[0]*w[1] - u[0]*v[2]*w[1] - u[1]*v[0]*w[2] - u[2]*v[1]*w[0]
exterior2 = lambda v,w: [v[0]*w[1] - v[1]*w[0], v[1]*w[2] - v[2]*w[1], v[2]*w[0] - v[0]*w[2]]
sub = lambda u,v: [a - b for a, b in zip(u, v)]

d = [[[int(i) for i in s.split(',')]
                for s in l.split('@')]
                for l in open(0)]

make_row = lambda i,j: exterior2(sub(d[i][1],d[j][1]), sub(d[i][0],d[j][0])) + [-exterior3(d[i][0],d[i][1],d[j][0]) - exterior3(d[j][0],d[j][1],d[i][0])]

am = np.array([make_row(i,j) for i,j in combinations([0,1,2],2)]).astype('float64')

print(sum(np.linalg.solve(am[:,:-1], am[:,-1])))
