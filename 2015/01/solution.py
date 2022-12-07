import sys


def main():
    s = sys.stdin.read()

    print('1:', sum(1 if c == '(' else -1 for c in s))

    lvl = 0
    for i, c in enumerate(s):
        lvl += 1 if c == '(' else -1
        if lvl == -1:
            print('2:', i + 1)
            break


if __name__ == '__main__':
    main()
