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
    total_score = 0
    for l in sys.stdin.readlines():
        l = l.strip()
        if l in ['A Y', 'B Z', 'C X']:
            score = 6
        elif l in ['A X', 'B Y', 'C Z']:
            score = 3
        else:
            score = 0

        if l[2] == 'X':
            score += 1
        elif l[2] == 'Y':
            score += 2
        else:
            score += 3

        total_score += score

    print(total_score)


if __name__ == '__main__':
    main()
