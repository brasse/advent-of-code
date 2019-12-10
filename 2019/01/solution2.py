import sys


def main():
    s = 0
    for l in sys.stdin.readlines():
        m = int(l)
        while True:
            f = m // 3 - 2
            if f < 0:
                break
            s += f
            m = f
    print(s)


if __name__  == '__main__':
    main()
