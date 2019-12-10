import sys


def main():
    p = [int(s) for s in sys.stdin.readline().split(',')]
    p[1] = 12
    p[2] = 2
    i = 0
    while True:
        if p[i] == 99:
            break
        elif p[i] == 1:
            p[p[i + 3]] = p[p[i + 1]] + p[p[i + 2]]
            i += 4
        elif p[i] == 2:
            p[p[i + 3]] = p[p[i + 1]] * p[p[i + 2]]
            i += 4
        else:
            raise RuntimeError()
    print(p[0])

if __name__  == '__main__':
    main()
