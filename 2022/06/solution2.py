import sys


def main():
    for l in sys.stdin.readlines():
        for i in range(len(l) - 13):
            if len(set(l[i : i + 14])) == 14:
                print(i + 14)
                break


if __name__ == '__main__':
    main()
