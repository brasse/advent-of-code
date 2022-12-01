import sys


def read_calories():
    elf = []
    for l in sys.stdin.readlines():
        l = l.strip()
        if l:
            elf.append(int(l))
        else:
            yield elf
            elf = []
        if l is None:
            break


def main():
    print(max([sum(elf) for elf in read_calories()]))


if __name__ == '__main__':
    main()
