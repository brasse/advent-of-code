import sys


def main():
    s = 0
    for l in sys.stdin.readlines():
        m = int(l)
        s += m // 3 - 2
    print(s)


if __name__  == '__main__':
    main()
