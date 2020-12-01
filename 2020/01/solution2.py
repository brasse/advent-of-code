import sys


def main():
    l = [int(l) for l in sys.stdin.readlines()]
    for x in range(len(l)):
        for y in range(x + 1, len(l)):
            for z in range(y + 1, len(l)):
                if l[x] + l[y] + l[z] == 2020:
                    print(l[x] * l[y] * l[z])


if __name__  == '__main__':
    main()
