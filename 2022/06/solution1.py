import sys


def main():
    for l in sys.stdin.readlines():
        for i in range(len(l) - 3):
            if len(set(l[i : i + 4])) == 4:
                print(i + 4)
                break


if __name__ == '__main__':
    main()
