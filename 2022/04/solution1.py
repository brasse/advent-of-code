import sys


def input():
    def assignments(s):
        a1, a2 = s.split('-')
        return range(int(a1), int(a2) + 1)

    input = []
    for l in sys.stdin.readlines():
        s1, s2 = l.strip().split(',')
        input.append((assignments(s1), assignments(s2)))
    return input


def main():
    n = 0
    for e1, e2 in input():
        s1 = set(e1)
        s2 = set(e2)
        if s1.issubset(s2) or s2.issubset(s1):
            n += 1
    print(n)


if __name__ == '__main__':
    main()
