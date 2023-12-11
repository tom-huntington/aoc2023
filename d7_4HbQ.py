from collections import Counter

def eval(line):
    hand, bid = line.split()
    hand = hand.translate(str.maketrans('TJQKA', f'A{J}CDE'))
    return max((joker(hand, r), hand) for r in '23456789ABCDE'), int(bid)

def joker(hand, r):
    return sorted(Counter(hand.replace(r, '0')).values())[::-1]

for J in 'B':#, '0':
    print(sorted(map(eval, open('d7.ex'))))
